part of vint;

abstract class Repository<T extends Model> {
  Storage storage;

  Repository(this.storage);

  T makeInstance(Map attrs);

  Future<List<T>> find([filters = const {}])
    => storage.find(filters).then((a) => _makeInstances(a));

  Future<T> read(id)
    => storage.read(id).then((a) => makeInstance(a));

  Future<T> save(T t){
    var future = storage.save(t.attributes.asJSON());

    return future.then((attrs){
      t.attributes.reset(attrs);
      return t;
    });
  }

  Future destroy(T t)
    => storage.destroy(t.id);

  _makeInstances(list) => list.map((a) => makeInstance(a));
}