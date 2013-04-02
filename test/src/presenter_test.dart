part of vint_test;

class TestPresenter extends TemplateBasedPresenter {
  var counter = 0;

  get template => (model) => model;

  get ui => {
    "someDiv" : "#some-div",
    "button" : "button"
  };

  get events => {
    "click button" : (e){}
  };

  TestPresenter(model, el) : super(model, el);
  TestPresenter.fromEl(el) : this(null, el);
}

class TestCollectionPresenter extends CollectionPresenter {
  makeItemPresenter(item) => new TestPresenter(item, new html.LIElement());

  TestCollectionPresenter(list, el) : super(list, el);
}


testPresenters() {
  group("[presenter]", () {
    group("[ui hash]", () {

      var presenter;

      setUp(() {
        var el = new html.Element.html("<div><div id='some-div'>expected text</div></div>");
        presenter = new TestPresenter.fromEl(el);
      });

      test("returns an element using specified selector", () {
        expect(presenter.someDiv.text, equals("expected text"));
      });

      test("throws NoSuchMethodError otherwise", () {
        expect(() => presenter.random, throws);
      });
    });

    group("[dispose]", () {
      var presenter;

      setUp(() {
        var el = new html.Element.html("<div><button></div>");
        presenter = new TestPresenter.fromEl(el);
      });

      test("removes event handlers registered via the events hash", (){
        presenter.dispose();

        expect(presenter.streamSubscriptions.length, equals(0));
      });
    });

    group("[template based render]", () {
      var presenter, el;

      setUp(() {
        el = new html.DivElement();
        presenter = new TestPresenter("my model", el);
      });

      test("renders the template", (){
        presenter.render();

        expect(el.innerHtml, equals("my model"));
      });

      test("returns itself", (){
        expect(presenter.render(), equals(presenter));
      });
    });

    group("[collection presenter]", (){
      var presenter, el;

      setUp(() {
        el = new html.DivElement();
        presenter = new TestCollectionPresenter(["one", "two"], el);
      });

      test("renders the template", (){
        presenter.render();

        expect(el.innerHtml, equals("<li>one</li><li>two</li>"));
      });

      test("returns itself", (){
        expect(presenter.render(), equals(presenter));
      });
    });
  });
}