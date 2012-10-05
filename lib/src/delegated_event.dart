/**
* Utility class implementing "jquery delegate" functionality.
*/
class _DelegatedEvent {
  final _eventSelector, _callback;

  _DelegatedEvent(this._eventSelector, this._callback);

  void registerOn(Element parent) {
    var parentCallback = _createCallbackOn(parent);
    var eventList = parent.on[_eventType()];
    eventList.add(parentCallback);
  }

  _createCallbackOn(parent) => (event) {
    if (_isTriggeredBySelector(parent, event)) {
      _callback(event);
    }
  };

  _isTriggeredBySelector(parent, event) =>
    _delimiter() == -1 ?
      true :
      parent.queryAll(_selector()).some((el) => el == event.target);

  _eventType() =>
    _delimiter() == -1 ?
      _eventSelector :
      _eventSelector.substring(0, _delimiter());

  _selector() => _eventSelector.substring(_delimiter() + 1);

  _delimiter() => _eventSelector.indexOf(' ');
}