part of vint_test;

testModelLists() {
  group("[model list]", () {
    var capturer = new EventCapturer();
    var list;
    var model;

    group("[initialization]", (){
      test("with items", () {
        var model1 = new TestModel({});
        var model2 = new TestModel({});
        
        var list = new TestModelList([model1]);
        list.add(model2);
        
        expect(list.first, equals(model1));        
        expect(list.last, equals(model2));
      });
    });
    
    group("[add]", () {
      setUp(() {
        list = new TestModelList();
        model = new TestModel({});
      });

      test("adds the element to the collection", () {
        list.add(model);
        expect(list.first, equals(model));
      });

      test("raises an event", () {
        list.events.onInsert.listen(capturer.callback);
        list.add(model);

        expect(capturer.event.model, equals(model));
      });
    });

    group("[remove]", () {
      setUp(() {
        list = new TestModelList();
        model = new TestModel({});
        list.add(model);
      });

      test("removes the element from the collection", () {
        list.remove(model);
        expect(list.isEmpty, equals(true));
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