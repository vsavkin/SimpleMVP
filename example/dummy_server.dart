import 'dart:io';
import 'dart:json';
import 'dart:math';

final HOST = "127.0.0.1";
final PORT = 8080;

void main() {
  var server = new HttpServer();

  var static = new StaticHandler("example");
  server.defaultRequestHandler = static.onRequest;

  var api = new ApiHandler();
  server.addRequestHandler(api.match, api.onRequest);

  server.listen(HOST, PORT); 
}

class ApiHandler {
  bool match(request) => request.uri.startsWith("/api");
  
  void onRequest(request, response) {
    var uri = request.uri;
    var method = request.method;

    print("REQUEST: ${method} ${uri}");
      
    if (uri.startsWith("/api/tasks") && method == "GET"){
      _render("text/json", _items(), response);

    } else if (uri.startsWith("/api/tasks") && method == "POST"){
      _renderNewRecord(request, response);

    } else if (uri.startsWith("/api/task")){
      _renderUpdatedRecord(request, response);
    }
  }
  
  _renderNewRecord(request, response){
    var s = new StringInputStream(request.inputStream);
    s.onData = (){
      var data = s.read();
      print("body: ${data}");
      
      var map = JSON.parse(data);
      map["id"] = new Random().nextInt(10000);
      _render("text/json", JSON.stringify(map), response);
    };    
  }

  _renderUpdatedRecord(request, response){
    var s = new StringInputStream(request.inputStream);
    s.onData = (){
      var data = s.read();
      print("BODY: ${data}");
      _render("text/json", data, response);
    };
  }

  _render(contentType, body, response){
    response.headers.set(HttpHeaders.CONTENT_TYPE, "$contentType; charset=UTF-8");
    response.outputStream.writeString(body);
    response.outputStream.close();
  }

  _items() {
    var r = [
        {"id": 1, "text": "Task 1", "status" : "inProgress"},
        {"id": 2, "text": "Task 2", "status" : "inProgress"}
    ];
    return JSON.stringify(r);
  }
}

class StaticHandler {
  String folder;

  StaticHandler(this.folder);

  onRequest(request, response) {
    var file = new File('${folder}${request.path}');
    file.exists().then((exists){
      if(exists)file.openInputStream().pipe(response.outputStream);
    });
  }
}