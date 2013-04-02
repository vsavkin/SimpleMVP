part of vint_test;

testModels() {
  group("[model]", () {
    var model;

    group("[attributes]", () {
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
