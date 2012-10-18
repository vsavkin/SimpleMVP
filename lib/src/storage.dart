part of simple_mvp;

/**
* Utility class to read/update/delete models on the server.
*/
class Storage {
  final _urls;

  Storage(this._urls);

  Future<List> readAll() => _submit("GET", _urls["readAll"], body: {});

  Future<Map> read(id) => _submit("GET", _urls["read"], id: id);

  Future<Map> create(ModelAttributes attrs) => _submit("POST", _urls["create"], body: attrs.asJSON());

  Future<Map> update(id, ModelAttributes attrs) => _submit("PUT", _urls["update"], id: id, body: attrs.asJSON());

  Future<Map> destroy(id) => _submit("DELETE", _urls["destroy"], id: id);

  _submit(method, url, {id, body}){
    var c = new Completer();
    url = id != null ? "$url/$id" : url;
    var req = _createRequest(method, url, (res) => c.complete(res));
    req.send(json.JSON.stringify(body));
    return c.future;
  }

  _createRequest(method, url, callback){
    var req = new html.HttpRequest();

    req.on.load.add((e){
      String response = req.response;
      var parsedResponse = response.isEmpty() ? {} : json.JSON.parse(response);
      callback(parsedResponse);
    });

    req.open(method, url, true);
    return req;
  }
}