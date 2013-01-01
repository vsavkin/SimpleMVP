part of simple_mvp_test;

testModels() {
  group("model_test", () {
    var model;

    setUp(() {
      capturer = new EventCapturer();
    });

    group("saved", () {
      test("is true when id is set", () {
        model = new TestModel({"id": 1});
        expect(model.saved, isTrue);
      });

      test("is false otherwise", () {
        model = new TestModel({});
        expect(model.saved, isFalse);
      });
    });

    group("attributes", () {
      setUp(() {
        model = new TestModel({"key": "value"});
      });

      test("returns the attribute's value", () {
        expect(model.key, equals("value"));
      });

      test("updates the attribute's value", () {
        model.key = "newValue";
        expect(model.key, equals("newValue"));
      });

      test("supports map syntax", () {
        model["key"] = "newValue";
        expect(model["key"], equals("newValue"));
      });
    });
  });
}
