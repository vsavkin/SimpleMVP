/**
* Utility class to read/update/delete models on the server.
*/
class Storage {
  final _urls;

  Storage(this._urls);

  Future<List> readAll() => _submit("GET", _urls["readAll"], json: {});

  Future<Map> read(id) => _submit("GET", _urls["read"], id: id);

  Future<Map> create(ModelAttributes attrs) => _submit("POST", _urls["create"], json: attrs.asJSON());

  Future<Map> update(id, ModelAttributes attrs) => _submit("PUT", _urls["update"], id: id, json: attrs.asJSON());

  Future<Map> destroy(id) => _submit("DELETE", _urls["destroy"], id: id);

  _submit(method, url, {id, json}){
    var c = new Completer();
    url = id != null ? "$url/$id" : url;
    var req = _createRequest(method, url, (res) => c.complete(res));
    req.send(JSON.stringify(json));
    return c.future;
  }

  _createRequest(method, url, callback){
    var req = new HttpRequest();

    req.on.load.add((e){
      String response = req.response;
      var parsedResponse = response.isEmpty() ? {} : JSON.parse(response);
      callback(parsedResponse);
    });

    req.open(method, url, true);
    return req;
  }
}