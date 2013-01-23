part of vint;

typedef Listener(event);

/**
* Utility class to manage event listeners.
*/
class Listeners {
  final List listeners = [];

  Listeners add(Listener listener){
    listeners.add(listener);
    return this;
  }

  void dispatch(event) {
    listeners.forEach((fn) {fn(event);});
  }
}

/**
* Utility class to manage multiple event types.
*/
class EventMap {
  final Map _listeners = {};

  Listeners listeners(String eventType){
    _listeners.putIfAbsent(eventType, () => new Listeners());
    return _listeners[eventType];
  }

  bool hasListeners(eventType)
    => _listeners.containsKey(eventType);
}


/**
* Utility class to be used by an application to transfer app events.
*/
class EventBus {
  final EventMap _map = new EventMap();

  void on(String eventType, Listener listener){
    _map.listeners(eventType).add(listener);
  }

  void fire(String eventType, event){
    if(_map.hasListeners(eventType)){
      _map.listeners(eventType).dispatch(event);
    }
  }
}

/**
* Event map for the ModelList class.
*/
class CollectionEvents extends EventMap {
  Listeners get reset => listeners("reset");
  Listeners get insert => listeners("insert");
  Listeners get remove => listeners("remove");
  Listeners get update => listeners("update");
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
class ModelEvents extends EventMap {
  Listeners get change => listeners("change");
  Listeners get validation => listeners("validation");
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