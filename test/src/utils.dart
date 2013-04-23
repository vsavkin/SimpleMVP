part of vint_test;

class EventCapturer {
  var event;

  callback(e){
    event = e;
  }
}

class TestDoubleStorage extends TestDouble implements Storage {}

class TestModel extends Model {
  TestModel(attrs): super(attrs);
}

class TestModelList extends ModelList<TestModel> {
  TestModelList([models]) : super(models);
}

class TestDoubleRepo extends Repository<TestModel> {
  TestDoubleRepo() : super(new TestDoubleStorage());
  makeInstance(attrs) => new TestModel(attrs);
}