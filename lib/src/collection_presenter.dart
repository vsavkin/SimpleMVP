part of vint;

abstract class CollectionPresenter<T> extends Presenter<T> {
  Presenter makeItemPresenter(obj);
  String get collectionElement => null;

  CollectionPresenter(list, el, template) : super(list, el, template);

  render() {
    super.render();
    _collectionEl.children.addAll(_buildItemElements());
    return this;
  }

  _buildItemElements() => modelList.
                          map((model) => makeItemPresenter(model)).
                          map((presenter) => presenter.render().el);

  get _collectionEl => (collectionElement != null) ? el.query(collectionElement) : el;
}