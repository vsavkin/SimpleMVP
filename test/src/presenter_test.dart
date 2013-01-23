part of vint_test;

class TestPresenter extends Presenter {
  get ui => {
    "someDiv" : "#some-div"
  };

  TestPresenter(el) : super(null, el, null);
}

testPresenters() {
  group("ui hash", () {

    var presenter;

    setUp(() {
      var el = new html.Element.html("<div><div id='some-div'>expected text</div></div>");
      presenter = new TestPresenter(el);
    });


    test("returns an element using specified selector", (){
      expect(presenter.someDiv.text, equals("expected text"));
    });

    test("throws NoSuchMethodError otherwise", (){
      expect(() => presenter.random, throws);
    });
  });
}