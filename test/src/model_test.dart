part of simple_mvp_test;

testModels() {
  group("model_test", () {
    var capturer;
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

    group("save", () {
      var dummyFuture = new Future.immediate({"key": "newValue"});

      test("creates the element in the storage", () {
        model = new TestModel({"key": "value"});
        model.storage.when(callsTo('create', model.attributes)).alwaysReturn(dummyFuture);
        model.save();
      });

      test("updates the element in the storage", () {
        model = new TestModel({"id": 1, "key": "value"});
        model.storage.when(callsTo('update', 1, model.attributes)).alwaysReturn(dummyFuture);
        model.save();
      });

      test("resets the model's attributes after receiving a response from the server", () {
        model = new TestModel({"key": "value"});
        model.storage.when(callsTo('create')).alwaysReturn(dummyFuture);
        model.save();
        expect(model.key, equals("newValue"));
      });

      test("returns a future", () {
        model = new TestModel({"key": "value"});
        model.storage.when(callsTo('create')).alwaysReturn(dummyFuture);
        var future = model.save();
        expect(future, equals(dummyFuture));
      });
    });

    group("destroy", () {
      var list;
      var dummyFuture = new Future.immediate("dummy");

      setUp(() {
        model = new TestModel({"id": 1});
        list = new TestModelList();
      });

      test("removes the element from the storage", () {
        model.destroy();
        model.storage.getLogs(callsTo('destroy', 1)).verify(happenedExactly(1));
      });

      test("returns a future", () {
        model.storage.when(callsTo('destroy')).alwaysReturn(dummyFuture);
        var future = model.destroy();
        expect(future, equals(dummyFuture));
      });

      test("removes itself from the model list", () {
        list.add(model);
        model.destroy();
        expect(list.models, equals([]));
      });
    });
  });
}
