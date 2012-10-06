testEvents() {
  group("events_test", () {
    var listener1 = (e){};
    var listener2 = (e){};
    var capturer = new EventCapturer();

    group("Listeners", () {
      test("adds listeners", () {
        var l = new smvp.Listeners();
        l.add(listener1).add(listener2);
        expect(l.listeners, equals([listener1, listener2]));
      });

      test("dispatches events", () {
        var l = new smvp.Listeners();
        l.add(capturer.callback);

        l.dispatch("expected event");

        expect(capturer.event, equals("expected event"));
      });
    });

    group("EventMap", () {
      test("stores a list of listeners for the given event type", () {
        var e = new smvp.EventMap();
        e.listeners("type1").add(listener1);
        expect(e.listeners("type1").listeners, equals([listener1]));
      });

      test("creates a new list for every event type", () {
        var e = new smvp.EventMap();
        expect(e.listeners("type1"), isNot(equals(e.listeners("type2"))));
      });
    });
  });
}
