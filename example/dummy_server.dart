#import("dart:io");
#import("dart:json");
#import("dart:math");

final HOST = "127.0.0.1";
final PORT = 8080;

void main() {
  var server = new HttpServer();
  server.addRequestHandler((request) => true, (request, response){
    new RequestHandler(request,response).process();
    }
  );
  server.listen(HOST, PORT); 
}

class RequestHandler {
  HttpRequest request;
  HttpResponse response;
 
  RequestHandler(this.request, this.response);
  
  void process() {
    var uri = request.uri;
    print("${request.method} ${uri}");
      
    if (uri.startsWith("/api/tasks") && request.method == "GET"){
      _render("text/json", _items());

    } else if (uri.startsWith("/api/tasks") && request.method == "POST"){
      _renderNewRecord();

    } else if (uri.startsWith("/api/task")){
      _renderUpdatedRecord();

    } else if (uri.endsWith(".dart")) {
      _renderDartFile();
        
    } else if (uri.endsWith(".css")){
      var file = new File("example/${_filename(uri)}");
      _render("text/css", file.readAsTextSync());
  
    } else if (uri.endsWith(".html")){
      var file = new File("example/${_filename(uri)}");
      _render("text/html", file.readAsTextSync());
    }
  }
  
  _renderNewRecord(){
    var s = new StringInputStream(request.inputStream);
    s.onData = (){
      var data = s.read();
      print("body: ${data}");
      
      var map = JSON.parse(data);
      map["id"] = new Random().nextInt(10000);
      _render("text/json", JSON.stringify(map));
    };    
  }

  _renderUpdatedRecord(){
    var s = new StringInputStream(request.inputStream);
    s.onData = (){
      var data = s.read();
      print("body: ${data}");
      _render("text/json", data);
    };
  }
  
  _renderDartFile(){
    var uri = request.uri;

    var libFile = new File(_filename(uri));
    var exampleFile =  new File("example/${_filename(uri)}");
    
    if(libFile.existsSync()){
      _render("application/dart", libFile.readAsTextSync());
    } else {
      _render("application/dart", exampleFile.readAsTextSync());
    }
  }
  
  _filename(uri) => uri.substring(uri.indexOf("/") + 1);
  
  _render(contentType, body){
    response.headers.set(HttpHeaders.CONTENT_TYPE, "$contentType; charset=UTF-8");
    response.outputStream.writeString(body);
    response.outputStream.close();
  }

  _items() {
    var r = [{"id": 1, "text": "Task 1", "status" : "inProgress"}, {"id": 2, "text": "Task 2", "status" : "inProgress"}];
    return JSON.stringify(r);
  }
}