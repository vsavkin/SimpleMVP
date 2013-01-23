part of simple_mvp;

/**
* The base class for evented model lists.
*/
class ModelList<T extends Model> {
  final CollectionEvents on = new CollectionEvents();
  List<T> models = [];

  forEach(fn(T)) => models.forEach(fn);

  map(fn(T)) => models.mappedBy(fn);

  void add(T model){
    models.add(model);
    on.insert.dispatch(new CollectionInsertEvent(this, model));
  }

  void remove(T model){
    var index = models.indexOf(model);
    if(index == -1) return;

    models.removeAt(index);
    on.remove.dispatch(new CollectionRemoveEvent(this, model));
  }

  void reset(List list){
    models.clear();
    models.addAll(list);
    on.reset.dispatch(new CollectionResetEvent(this));
  }
}