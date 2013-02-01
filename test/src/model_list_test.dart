part of vint_test;

testModelLists() {

  group("model_list_test", () {
    var capturer = new EventCapturer();
    var list;
    var model;

    group("add", () {
      setUp(() {
        list = new TestModelList();
        model = new TestModel({});
      });

      test("adds the element to the collection", () {
        list.add(model);
        expect(list.models, equals([model]));
      });

      test("raises an event", () {
        list.events.onInsert.listen(capturer.callback);
        list.add(model);

        expect(capturer.event.model, equals(model));
      });
    });

    group("remove", () {
      setUp(() {
        list = new TestModelList();
        model = new TestModel({});
        list.add(model);
      });

      test("removes the element from the collection", () {
        list.remove(model);
        expect(list.models, equals([]));
      });

      test("does nothing when cannot find the element", () {
        list.remove(model);
        list.remove(model);
      });

      test("raises an event", () {
        list.events.onInsert.listen(capturer.callback);
        list.add(model);

        expect(capturer.event.model, equals(model));
      });
    });
  });
}