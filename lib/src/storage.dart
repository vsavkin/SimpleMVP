part of vint;

abstract class Storage {
  Future<List> find(filters);

  Future<Map> read(id);

  Future<Map> save(Map attrs);

  Future destroy(id);
}