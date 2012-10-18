part of simple_mvp;

typedef String Template<T>(T model);

/**
* It binds a model and view.
* Sends commands to the model when the associated view changes.
* Updates the view when the model changes.
*/
class Presenter<T> {
  final html.Element el;
  final Template<T> template;
  final T model;

  Map get events => {};

  Presenter(this.model, this.el, [this.template]){
    subscribeToModelEvents();
    subscribeToDOMEvents();
  }

  Presenter<T> render(){
    if(template != null){
      el.innerHTML = template(model);
    }
    return this;
  }

  void subscribeToDOMEvents(){
    events.forEach((eventSelector, callback){
      new _DelegatedEvent(eventSelector, callback).registerOn(el);
    });
  }

  void subscribeToModelEvents(){
  }
}