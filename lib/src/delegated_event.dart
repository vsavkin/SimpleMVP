part of vint;

/**
* Utility class implementing "jquery delegate" functionality.
*/
class _DelegatedEvent {
  final _eventSelector, _callback;

  _DelegatedEvent(this._eventSelector, this._callback);

  void registerOn(html.Element parent) {
    var parentCallback = createCallbackOn(parent);
    var eventList = parent.on[eventType()];
    eventList.listen(parentCallback);
  }

  createCallbackOn(parent) => (event) {
    if (isTriggeredBySelector(parent, event)) {
      _callback(event);
    }
  };

  isTriggeredBySelector(parent, event) =>
    delimiter() == -1 ?
      true :
      parent.queryAll(selector()).any((el) => el == event.target);

  eventType() =>
    delimiter() == -1 ?
      _eventSelector :
      _eventSelector.substring(0, delimiter());

  selector() => _eventSelector.substring(delimiter() + 1);

  delimiter() => _eventSelector.indexOf(' ');
}