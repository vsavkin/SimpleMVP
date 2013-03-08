part of vint;

/**
* The base class for evented model lists.
*/
class ModelList<T extends Model> {
  final CollectionEvents events = new CollectionEvents();
  List<T> models = [];

  forEach(fn(T)) => models.forEach(fn);

  map(fn(T)) => models.map(fn);

  void add(T model){
    models.add(model);
    events.fireInsert(new CollectionInsertEvent(this, model));
  }

  void remove(T model){
    var index = models.indexOf(model);
    if(index == -1) return;

    models.removeAt(index);
    events.fireRemove(new CollectionRemoveEvent(this, model));
  }

  void reset(List list){
    models.clear();
    models.addAll(list);
    events.fireReset(new CollectionResetEvent(this));
  }
}