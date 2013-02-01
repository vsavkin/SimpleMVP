part of vint_test;

testModelAttributes() {
  group("[model attributes]", () {
    var capturer;
    var model;
    var attrs;

    group("[operator []]", () {
      setUp(() {
        model = new TestModel({});
        attrs = new ModelAttributes(model, {"key": "value"});
        capturer = new EventCapturer();
      });

      test("returns the attribute's value", () {
        expect(attrs["key"], equals("value"));
      });

      test("raises an exception when invalid attribute name", () {
        expect(() => attrs["invalid"], throws);
      });
    });

    group("[operator[]=]", () {
      setUp(() {
        model = new TestModel({});
        attrs = new ModelAttributes(model, {"key": "value"});
        capturer = new EventCapturer();
      });

      test("updates the attribute's value", () {
        attrs["key"] = "newValue";
        expect(attrs["key"], equals("newValue"));
      });

      test("raises an exception when invalid attribute name", () {
        expect(() => attrs["invalid"] = "value", throws);
      });

      test("fires an event when the value has changed", () {
        model.events.onChange.listen(capturer.callback);
        attrs["key"] = "newValue";

        expect(capturer.event.attrName, equals("key"));
        expect(capturer.event.oldValue, equals("value"));
        expect(capturer.event.newValue, equals("newValue"));
      });

      test("does not fire an event when the new value is the same", () {
        model.events.onChange.listen(capturer.callback);
        attrs["key"] = attrs["key"];

        expect(capturer.event, isNull);
      });
    });

    group("[hasId]", (){
      test("is true when attributes containt id", (){
        attrs = new ModelAttributes(null, {"id": "value"});
        expect(attrs.hasId(), isTrue);
      });

      test("is false otherwise", (){
        attrs = new ModelAttributes(null, {});
        expect(attrs.hasId(), isFalse);
      });
    });

    group("[reset]", (){
      setUp(() {
        model = new TestModel({});
        attrs = new ModelAttributes(model, {"key": "value"});
        capturer = new EventCapturer();
      });

      test("updates existing attribitues", (){
        attrs.reset({"key": "newValue"});
        expect(attrs["key"], equals("newValue"));
      });

      test("creates new attributes", (){
        attrs.reset({"newKey": "newValue"});
        expect(attrs["newKey"], equals("newValue"));
      });

      test("removes attributes", (){
        attrs.reset({});
        expect(() => attrs["key"], throws);
      });
    });
  });
}
