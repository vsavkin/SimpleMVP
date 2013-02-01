part of vint_test;

testEvents() {
  group("events", () {
    var listener1 = (e){};
    var listener2 = (e){};

    group("Event bus", (){
      test("notifies registered listeners when an event type matches", (){
        var capturer = new EventCapturer();
        var b = new EventBus();

        b.stream("event1").listen(capturer.callback);
        b.sink("event1").add("some data");

        expect(capturer.event, equals("some data"));
      });

      test("doesn't notify otherwise", (){
        var capturer = new EventCapturer();
        var b = new EventBus();

        b.stream("event1").listen(capturer.callback);
        b.sink("event2").add("some data");

        expect(capturer.event, isNull);
      });
    });
  });
}
