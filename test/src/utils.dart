part of vint_test;

class EventCapturer {
  var event;

  callback(e){
    event = e;
  }
}

class MockStorage extends Mock implements Storage {}

class TestModel extends Model {
  TestModel(attrs): super(attrs);
}

class TestModelList extends ModelList<TestModel> {
}

class TestModelRepo extends Repository<TestModel> {
  TestModelRepo() : super(new MockStorage());
  makeInstance(attrs) => new TestModel(attrs);
}