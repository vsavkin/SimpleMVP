part of vint_test;

testRepositories() {
  group("[repository]", () {

    var repo, storage;

    group("[read]", () {
      setUp((){
        repo = new TestDoubleRepo();
        storage = repo.storage;
      });

      tearDown((){
        currentTestRun.verify();
      });

      test("wraps that hash returned by the storage", () {
        storage.stub("read").args(1).andReturn(new Future.value({"key" : "value"}));

        repo.read(1).then((model){
          expect(model.key, equals("value"));
        });
      });
    });

    group("[find]", () {
      setUp((){
        repo = new TestDoubleRepo();
        storage = repo.storage;
      });

      test("wraps that hash returned by the storage", () {
        storage.stub("find").args({"filter" : 1}).andReturn(new Future.value([{"key" : "value"}]));

        repo.find({"filter" : 1}).then((listOfModels){
          expect(listOfModels.first.key, equals("value"));
        });
      });
    });

    group("[save]", () {
      setUp((){
        repo = new TestDoubleRepo();
        storage = repo.storage;
      });

      tearDown((){
        currentTestRun.verify();
      });


      test("passes the list of attributes to storage", () {
        var model = new TestModel({"key" : "value"});

        storage.shouldReceive("save").args({"key" : "value"}).andReturn(new Future.value({}));

        repo.save(model);
      });

      test("returns an updated model", () {
        var model = new TestModel({"key" : "value"});

        storage.stub("save").andReturn(new Future.value({"key" : "value2"}));

        repo.save(model).then((updatedModel){
          expect(updatedModel.key, equals("value2"));
        });
      });

      test("updates the model", () {
        var model = new TestModel({"key" : "value"});

        storage.stub("save").andReturn(new Future.value({"key" : "value2"}));

        repo.save(model).then((updatedModel){
          expect(model.key, equals("value2"));
        });
      });
    });

    group("[destroy]", () {
      setUp((){
        repo = new TestDoubleRepo();
        storage = repo.storage;
      });

      tearDown((){
        currentTestRun.verify();
      });

      test("calls destroy on storage", () {
        var model = new TestModel({"id" : 1});

        storage.shouldReceive("destroy").args(1).andReturn(new Future.value(true));

        repo.destroy(model);
      });
    });

    group("[error handling]", () {
      setUp((){
        repo = new TestDoubleRepo();
        storage = repo.storage;
      });

      test("calls the default error handler when it is set", () {
        var capturer = new EventCapturer();
        repo.onError = capturer.callback;

        storage.stub("read").andReturn(new Future.error(stub({"get error": "ERROR"})));

        repo.read(1).then((_){
          expect(capturer.event.error, equals("ERROR"));
        });
      });

      test("returns failing future when no default error handler", () {
        storage.stub("read").andReturn(new Future.error(stub({"get error": "ERROR"})));

        repo.read(1).catchError((e){
          expect(e.error, equals("ERROR"));
        });
      });
    });
  });
}