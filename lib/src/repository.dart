part of vint;

abstract class Repository<T extends Model> {
  Storage storage;
  var onError;

  Repository(this.storage, {this.onError}){
    if(onError == null)
      onError = (e){throw e;};
  }

  T makeInstance(Map attrs);

  Future<List<T>> find([filters = const {}]) =>
    storage.
    find(filters).
    then(_makeInstances).
    catchError(onError);

  Future<T> read(id) =>
    storage.
    read(id).
    then(makeInstance).
    catchError(onError);

  Future<T> save(T t) =>
    storage.
    save(t.attributes.asJSON()).
    then((attrs){
      t.attributes.reset(attrs);
      return t;
    }).
    catchError(onError);

  Future destroy(T t) =>
    storage.
    destroy(t.id).
    catchError(onError);

  _makeInstances(list) => list.map((a) => makeInstance(a)).toList();
}