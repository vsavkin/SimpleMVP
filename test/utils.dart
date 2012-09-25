class EventCapturer {
  var event;

  callback(e){
    event = e;
  }
}

class MockStorage extends Mock implements Storage {}

class TestModel extends Model {
  TestModel(attrs, [list]): super(attrs, list) {
    storage = new MockStorage();
  }
  final rootUrl = "url";
}

class TestModelList extends ModelList<TestModel> {
  TestModelList(){
    storage = new MockStorage();
  }

  final rootUrl = "url";

  makeInstance(attrs, list) => new TestModel(attrs, list);
}