part of vint;

typedef String Template<T>(T model);

/**
* It binds a model and view.
* Sends commands to the model when the associated view changes.
* Updates the view when the model changes.
*/
abstract class Presenter<T> {
  final html.Element el;
  final T model;

  final List<StreamSubscription> streamSubscriptions = [];

  /**
   * Improves readability when the model is a list.
   **/
  T get modelList => model;
  
  /**
   * Maps events to event handlers.
   * 
   * Example:
   * {"click a.delete": _onDelete}
   **/
  Map get events => {};

  /**
   * Provides convenient access to rendered elements.
   * 
   * For example:
   * 
   * {firstName : "input[name='firstName']"}
   * 
   * defines a getter on the presenter that returns the input element.
   * It can be used in any method of the presenter:
   * 
   * void _submitForm(){
   *   var firstName = this.firstName.value
   *   ...
   * }
   **/
  Map get ui => {};

  Presenter(this.model, this.el){
    subscribeToModelEvents();
    subscribeToDOMEvents();
  }

  Presenter<T> render();

  void subscribeToDOMEvents(){
    events.forEach((eventSelector, callback){
      var delegate = new _DelegatedEvent(eventSelector, callback);
      streamSubscriptions.add(delegate.registerOn(el));
    });
  }

  void subscribeToModelEvents(){
  }

  dispose(){
    streamSubscriptions..forEach((_) => _.cancel())..clear();
  }

  noSuchMethod(Invocation invocation){
    if(invocation.isGetter && ui.containsKey(invocation.memberName)){
      return el.query(ui[invocation.memberName]);
    }
    super.noSuchMethod(invocation);
  }
}


/**
* A template based implementation of Presenter.
* A subclass must define the template property.
*/
abstract class TemplateBasedPresenter<T> extends Presenter<T> {
  Template<T> get template;
  
  TemplateBasedPresenter(model, el) : super(model, el);
  
  Presenter<T> render(){
    if(template != null){
      el.innerHtml = template(model);
    }
    return this;
  }
}


/**
* An implementation of Presenter rendering a collection of models.
* A subclass must define the makeItemPresenter constructor.
*/
abstract class CollectionPresenter<T> extends Presenter<T>{
  Presenter makeItemPresenter(obj);

  CollectionPresenter(model, el) : super(model, el);

  Presenter<T> render() {
    el.children..clear()
               ..addAll(_buildItemElements());
    return this;
  }

  _buildItemElements() => model.
                          map((model) => makeItemPresenter(model)).
                          map((presenter) => presenter.render().el);
}