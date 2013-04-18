part of vint;

/**
* Utility class to be used by an application to transfer app events.
*/
class EventBus {
  final _map = {};

  Stream stream(String eventType){
    _map.putIfAbsent(eventType, () => new StreamController());
    return _map[eventType].stream;
  }

  EventSink sink(String eventType){
    _map.putIfAbsent(eventType, () => new StreamController());
    return _map[eventType].sink;
  }

  StreamSubscription listen(String eventType, callback) =>
    stream(eventType).listen(callback);

  fire(String eventType, event) =>
    sink(eventType).add(event);
}

/**
* Event map for the ModelList class.
*/
class CollectionEvents {
  var _resetController, _insertController, _removeController, _updateController;
  var _resetStream, _insertStream, _removeStream, _updateStream;

  CollectionEvents(){
    _resetController = new StreamController();
    _resetStream = _resetController.stream.asBroadcastStream();

    _insertController = new StreamController();
    _insertStream = _insertController.stream.asBroadcastStream();

    _removeController = new StreamController();
    _removeStream = _removeController.stream.asBroadcastStream();

    _updateController = new StreamController();
    _updateStream = _updateController.stream.asBroadcastStream();
  }

  Stream<CollectionResetEvent> get onReset => _resetStream;
  Stream<CollectionInsertEvent> get onInsert => _insertStream;
  Stream<CollectionRemoveEvent> get onRemove => _removeStream;
  Stream get onUpdate => _updateStream;

  void fireReset(CollectionResetEvent event) => _resetController.add(event);
  void fireInsert(CollectionInsertEvent event) => _insertController.add(event);
  void fireRemove(CollectionRemoveEvent event) => _removeController.add(event);
  void fireUpdate(event) => _updateController.add(event);
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
  var _changeController;
  var _changeStream;
  
  var _validationController;
  var _validationStream;
  
  ModelEvents(){
    _changeController = new StreamController();
    _changeStream = _changeController.stream.asBroadcastStream();
      
    _validationController = new StreamController();
    _validationStream = _validationController.stream.asBroadcastStream();
  }

  Stream<ChangeEvent> get onChange => _changeStream;
  Stream get onValidation => _validationStream;

  void fireChange(ChangeEvent event) => _changeController.add(event);
  void fireValidation(event) => _validationController.add(event);
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