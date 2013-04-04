part of vint;

/**
* An implementation of the Storage interface for a restful backend.
*/
class RestfulStorage implements Storage {
  final _urls;

  RestfulStorage(this._urls);

  Future<List> find(filters) => _submit("GET", _urls["find"], body: filters);

  Future<Map> read(id) => _submit("GET", _urls["read"], id: id);

  Future<Map> save(Map attrs) =>
    attrs.containsKey("id") ?
      _submit("PUT", _urls["update"], id: attrs["id"], body: attrs) :
      _submit("POST", _urls["create"], body: attrs);

  Future destroy(id) => _submit("DELETE", _urls["destroy"], id: id);

  _submit(method, baseUrl, {id, body}){
    var c = new Completer();
    var url = id != null ? "$baseUrl/$id" : baseUrl;
    var payload = json.stringify(body);

    _createRequest(method, url, payload, (req){
      var response = req.response;
      var parsedResponse = response.isEmpty ? {} : json.parse(response);
      req.status == 200 ? c.complete(parsedResponse) : c.completeError(parsedResponse);
    });

    return c.future;
  }

  _createRequest(method, url, body, callback){
    var req = new html.HttpRequest();
    req.onLoad.listen((_) => callback(req));
    req.open(method, url, async: true);
    req.send(body);
  }
}