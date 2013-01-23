part of vint;

/**
* An implementaion of the Storage interface for a restful backend.
*/
class RestfulStorage implements Storage {
  final _urls;

  RestfulStorage(this._urls);

  Future<List> find(filters) => _submit("GET", _urls["find"], body: filters);

  Future<Map> read(id) => _submit("GET", _urls["read"], id: id);

  Future<Map> save(Map attrs){
    if(attrs.containsKey("id")){
      return _submit("PUT", _urls["update"], id: attrs["id"], body: attrs);
    } else {
      return _submit("POST", _urls["create"], body: attrs);
    }
  }

  Future destroy(id) => _submit("DELETE", _urls["destroy"], id: id);

  _submit(method, url, {id, body}){
    var c = new Completer();
    url = id != null ? "$url/$id" : url;
    var req = _createRequest(method, url, (res) => c.complete(res));
    req.send(json.stringify(body));
    return c.future;
  }

  _createRequest(method, url, callback){
    var req = new html.HttpRequest();

    req.on.load.add((e){
      String response = req.response;
      var parsedResponse = response.isEmpty ? {} : json.parse(response);
      callback(parsedResponse);
    });

    req.open(method, url, true);
    return req;
  }
}