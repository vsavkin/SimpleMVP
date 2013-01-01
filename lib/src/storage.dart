part of simple_mvp;

abstract class Storage {
  final _urls;

  Future<List> find(filters);

  Future<Map> read(id);

  Future<Map> save(Map attrs);

  Future destroy(id);
}