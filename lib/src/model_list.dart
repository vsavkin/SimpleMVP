part of vint;

/**
* The base class for evented model lists.
*/
class ModelList<T extends Model> extends Object with IterableMixin<T> {
  final CollectionEvents events = new CollectionEvents();
  final List<T> models;
  
  get iterator => models.iterator;
  
  ModelList([List<T> models])
      : models = _models(models); 
  
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
  
  static _models(models) => models != null ? models : [];
}