part of simple_mvp;

/**
* The base class for model lists.
*/
abstract class ModelList<T extends Model> {
  final CollectionEvents on = new CollectionEvents();
  final List<T> models = [];
  Storage storage;

  ModelList(){
    storage = new Storage({"readAll" : rootUrl});
  }

  /**
  * Abstract property to be overridden by subclasses. It's used by Storage.
  */
  String get rootUrl;

  T makeInstance(Map attrs, ModelList list);

  forEach(fn(T)) => models.forEach(fn);

  map(fn(T)) => models.map(fn);

  void add(T model){
    models.add(model);
    model.modelList = this;
    on.insert.dispatch(new CollectionInsertEvent(this, model));
  }

  void remove(T model){
    var index = models.indexOf(model);
    if(index == -1) return;

    models.removeRange(index, 1);
    on.remove.dispatch(new CollectionRemoveEvent(this, model));
  }

  void reset(List list){
    models.clear();
    models.addAll(list.map((attrs) => makeInstance(attrs, this)));
    on.load.dispatch(new CollectionLoadEvent(this));
  }

  void fetch(){
    storage.readAll().then(reset);
  }
}