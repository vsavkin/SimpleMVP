part of simple_mvp;

abstract class Repository<T> {
  Storage storage;

  Repository(this.storage);

  T makeInstance(Map attrs);

  Future<List<T>> find([filters = const {}])
    => storage.find(filters).transform((a) => _makeInstances(a));

  Future<T> read(id)
    => storage.read(id).transform((a) => makeInstance(a));

  Future<T> save(T t){
    var future = storage.save(t.attributes.asJSON());

    return future.transform((attrs){
      t.attributes.reset(attrs);
      return t;
    });
  }

  Future destroy(T t)
    => storage.destroy(t.id);

  _makeInstances(list) => list.map((a) => makeInstance(a));
}