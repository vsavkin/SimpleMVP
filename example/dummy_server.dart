import 'dart:io';
import 'dart:json' as json;
import 'dart:math';

final HOST = "127.0.0.1";
final PORT = 8080;

void main() {
  var apiHandler = new ApiHandler();
  var staticHandler = new StaticHandler("example");

  HttpServer.bind(HOST, PORT).then((server){
    server.listen((req){
      var handler = apiHandler.match(req) ? apiHandler : staticHandler;
      handler.onRequest(req, req.response);
    });
  });
}

class ApiHandler {
  bool match(request) => request.uri.toString().startsWith("/api");
  
  void onRequest(request, response) {
    var uri = request.uri.toString();
    var method = request.method;

    print("REQUEST: ${method} ${uri}");
      
    if (uri.startsWith("/api/tasks") && method == "GET"){
      _renderItems(response);

    } else if (uri.startsWith("/api/tasks") && method == "POST"){
      _renderNewRecord(request, response);

    } else if (uri.startsWith("/api/task")){
      _renderUpdatedRecord(request, response);
    }
  }

  _renderItems(response) {
    var r = [
        {"id": 1, "text": "Task 1", "status" : "inProgress"},
        {"id": 2, "text": "Task 2", "status" : "inProgress"}
    ];
    _render("text/json", json.stringify(r), response);
  }

  _renderNewRecord(request, response){
    request.transform(new StringDecoder()).listen((data){
      print("body: ${data}");

      var map = json.parse(data);
      map["id"] = new Random().nextInt(10000);
      _render("text/json", json.stringify(map), response);
    });
  }

  _renderUpdatedRecord(request, response){
    request.transform(new StringDecoder()).listen((data){
      print("BODY: ${data}");
      _render("text/json", data, response);
    });
  }

  _render(contentType, body, response){
    response.headers.set(HttpHeaders.CONTENT_TYPE, "$contentType; charset=UTF-8");
    response.addString(body);
    response.close();
  }
}

class StaticHandler {
  String folder;

  StaticHandler(this.folder);

  onRequest(request, response) {
    var path = request.uri.toString();
    var file = new File('${folder}${path}');
    print('${folder}${path}');

    file.exists().then((exists){
      if(exists){
        file.openRead().pipe(response);
      } else {
        response.close();
      }
    });
  }
}