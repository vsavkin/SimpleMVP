part of vint_test;

testEvents() {
  group("events_test", () {
    var listener1 = (e){};
    var listener2 = (e){};

    group("Listeners", () {
      test("adds listeners", () {
        var l = new Listeners();
        l.add(listener1).add(listener2);
        expect(l.listeners, equals([listener1, listener2]));
      });

      test("dispatches events", () {
        var capturer = new EventCapturer();
        var l = new Listeners();

        l.add(capturer.callback);

        l.dispatch("expected event");

        expect(capturer.event, equals("expected event"));
      });
    });

    group("EventMap", () {
      test("stores a list of listeners for the given event type", () {
        var e = new EventMap();
        e.listeners("type1").add(listener1);
        expect(e.listeners("type1").listeners, equals([listener1]));
      });

      test("creates a new list for every event type", () {
        var e = new EventMap();
        expect(e.listeners("type1"), isNot(equals(e.listeners("type2"))));
      });
    });

    group("Event bus", (){
      test("notifies registered listeners when an event type matches", (){
        var capturer = new EventCapturer();
        var b = new EventBus();
        b.on("event1", capturer.callback);

        b.fire("event1", "some data");

        expect(capturer.event, equals("some data"));
      });

      test("doesn't notify otherwise", (){
        var capturer = new EventCapturer();
        var b = new EventBus();
        b.on("event1", capturer.callback);

        b.fire("event2", "some data");

        expect(capturer.event, isNull);
      });
    });
  });
}
