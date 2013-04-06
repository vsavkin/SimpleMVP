part of vint_test;

testEvents() {
  group("[events]", () {
    var listener1 = (e) {
    };
    var listener2 = (e) {
    };

    group("[event bus]", () {
      group("[stream/sink]", () {
        test("notifies registered listeners when the event type matches", () {
          var capturer = new EventCapturer();
          var b = new EventBus();

          b.stream("event1").listen(capturer.callback);
          b.sink("event1").add("some data");

          expect(capturer.event, equals("some data"));
        });

        test("doesn't notify otherwise", () {
          var capturer = new EventCapturer();
          var b = new EventBus();

          b.stream("event1").listen(capturer.callback);
          b.sink("event2").add("some data");

          expect(capturer.event, isNull);
        });
      });

      group("[fire/listen]", (){
        test("notifies registered listeners when the event type matches", () {
          var capturer = new EventCapturer();
          var b = new EventBus();

          b.listen("event1", capturer.callback);
          b.fire("event1", "some data");

          expect(capturer.event, equals("some data"));
        });

        test("doesn't notify otherwise", () {
          var capturer = new EventCapturer();
          var b = new EventBus();


          b.listen("event1", capturer.callback);
          b.fire("event2", "some data");

          expect(capturer.event, isNull);
        });
      });
    });
  });
}
