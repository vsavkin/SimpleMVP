part of vint_test;

testRepositories() {
  group("[repository]", () {
    var repo = new TestModelRepo();
    Mock storage = repo.storage as Mock;

    group("[read]", () {
      test("wraps that hash returned by the storage", () {
        storage.
          when(callsTo('read', 1)).
          alwaysReturn(new Future.immediate({"key" : "value"}));

        repo.read(1).then((model){
          expect(model.key, equals("value"));
        });
      });
    });

    group("[find]", () {
      test("wraps that hash returned by the storage", () {
        storage.
          when(callsTo('find', {"filter" : 1})).
          alwaysReturn(new Future.immediate([{"key" : "value"}]));

        repo.find({"filter" : 1}).then((listOfModels){
          expect(listOfModels[0].key, equals("value"));
        });
      });
    });

    group("[save]", () {
      test("passes the list of attributes to storage", () {
        var model = new TestModel({"key" : "value"});

        storage.
          when(callsTo('save', {"key" : "value"})).
          thenReturn(new Future.immediate({}));

        repo.save(model);
      });

      test("returns an updated model", () {
        var model = new TestModel({"key" : "value"});

        storage.
          when(callsTo('save')).
          alwaysReturn(new Future.immediate({"key" : "value2"}));

        repo.save(model).then((updatedModel){
          expect(updatedModel.key, equals("value2"));
        });
      });

      test("updates the model", () {
        var model = new TestModel({"key" : "value"});

        storage.
          when(callsTo('save')).
          alwaysReturn(new Future.immediate({"key" : "value2"}));

        repo.save(model).then((updatedModel){
          expect(model.key, equals("value2"));
        });
      });
    });

    group("[destroy]", () {
      test("calls destroy on storage", () {
        var model = new TestModel({"id" : 1});

        storage.
          when(callsTo('destroy', 1)).
          alwaysReturn(new Future.immediate(true));

        repo.destroy(model);
      });
    });
  });
}