part of vint;

/**
* Utility class to be used by an application to transfer app events.
*/
class EventBus {
  final _map = {};

  Stream stream(String eventType){
    _map.putIfAbsent(eventType, () => new StreamController.broadcast());
    return _map[eventType].stream;
  }

  StreamSink sink(String eventType){
    _map.putIfAbsent(eventType, () => new StreamController.broadcast());
    return _map[eventType].sink;
  }
}

/**
* Event map for the ModelList class.
*/
class CollectionEvents {
  final _reset = new StreamController.broadcast();
  final _insert = new StreamController.broadcast();
  final _remove = new StreamController.broadcast();
  final _update = new StreamController.broadcast();


  Stream<CollectionResetEvent> get onReset => _reset.stream;
  Stream<CollectionInsertEvent> get onInsert => _insert.stream;
  Stream<CollectionRemoveEvent> get onRemove => _remove.stream;
  Stream get onUpdate => _update.stream;

  void fireReset(CollectionResetEvent event) => _reset.add(event);
  void fireInsert(CollectionInsertEvent event) => _insert.add(event);
  void fireRemove(CollectionRemoveEvent event) => _remove.add(event);
  void fireUpdate(event) => _update.add(event);
}

/**
* An event that is raised after a collection's initial load.
*/
class CollectionResetEvent {
  final collection;

  CollectionResetEvent(this.collection);
}

/**
* Event raised after a new record was inserted into a collection.
*/
class CollectionInsertEvent {
  final collection, model;

  CollectionInsertEvent(this.collection, this.model);
}

/**
* Event raised after a record was removed from its collection.
*/
class CollectionRemoveEvent {
  final collection, model;

  CollectionRemoveEvent(this.collection, this.model);
}

/**
* Event map for the Model class.
*/
class ModelEvents {
  final _change = new StreamController.broadcast();
  final _validation = new StreamController.broadcast();

  Stream<ChangeEvent> get onChange => _change.stream;
  Stream get onValidation => _validation.stream;

  void fireChange(ChangeEvent event) => _change.add(event);
  void fireValidation(event) => _validation.add(event);
}

/**
* Event raised after a model's attribute was changed.
*/
class ChangeEvent {
  final String attrName;
  final model;
  final oldValue;
  final newValue;

  ChangeEvent(this.model, this.attrName, this.oldValue, this.newValue);
}