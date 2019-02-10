part of server_common;

Router _myRouter;
shelf.Middleware _middle;
shelf.Handler _handler;
JsonCodec _codec;

typedef void DHandler(RequestContext context);

void serve(int port) {
  io.serve(_handler, InternetAddress.ANY_IP_V4, port).then((server) {
    // server.autoCompress = true;
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

void loadServer() {
  _myRouter = router();
  _handler = new shelf.Cascade().add(_myRouter.handler).handler;
  _middle = sessionMiddleware(new SimpleSessionStore());
}

/*void serveSocket(String controller, Function handler, Function getSocket) {
  _myRouter.get(controller, web_socket
      .webSocketHandler((socket, protocol, shelf.Request request) {
    getSocket(socket);
    socket.listen((String message) {
      Map json = JSON.decode(message);
      handler(json);
    });
  }), middleware: _middle);
}*/

abstract class DataContainer{
  void validate();
  void wrap();
  void execute();
  Map<String,dynamic> toJson();
}
class RequestContext {
  String method;
  shelf.Request request;
  StreamController out;
  int userId;
  Object data;
  // Secondary (extends already present data)
  DataContainer container;
  User logged;
  // Ternary (after execution)
  String message="";
  bool success = true;

  void write(dynamic data) {
    if (data is! String) {
      data = JSON.encode(data);
    }
    out.add(const Utf8Codec().encode(data));
  }
  void close() {
    out.close();
  }
  bool respond(String resMessage, bool isSuccess) {
    message += resMessage;
    success = success && isSuccess;
    if(out!=null){  // only because of tests
      write({"resp": message, "suc": success});
      close();
    }
    /*message=resMessage;
    success=isSuccess;*/
    return success;
  }
  bool get closed => out.isClosed;
}

void saveToSession(RequestContext context, String key, dynamic value) {
  Session mySession = session(context.request);
  mySession[key] = value;
  //print("session save "+mySession.hashCode.toString());
}

Function createInnerRoute(String method, DHandler controller, bool shouldLogged,
    bool shouldData, List<String> dataItems) {
  var headers = <String, String>{HttpHeaders.CONTENT_TYPE: "text/json"};
  Function dataChecker = checkData(method, shouldData, dataItems);
  if (method == "GET") {
    return (shelf.Request request) {
      StreamController innerController = new StreamController();
      Stream<List<int>> out = innerController.stream;
      Session mySession = session(request);
      //print("session get "+mySession.hashCode.toString());
      int userId = mySession["loggedUser"];
      if (shouldLogged && userId == null) {
        innerController
          ..add(const Utf8Codec().encode(resOutString("Not logged", false)))
          ..close();
        return new shelf.Response.ok(out, headers: headers);
      }
      Map<String, String> dataOut;
      if (request.url.hasQuery) {
        dataOut = request.url.queryParameters;
      }
      dataOut = dataChecker(dataOut);
      if (dataOut != null && dataOut["suc"] == false) {
        innerController
          ..add(const Utf8Codec().encode(JSON.encode(dataOut)))
          ..close();
        return new shelf.Response.ok(out, headers: headers);
      }
      controller(new RequestContext()
        ..method = method
        ..data = dataOut
        ..request = request
        ..userId = userId
        ..out = innerController);
      return new shelf.Response.ok(out, headers: headers);
    };
  } else {
    //if (method == "POST") {
    return (shelf.Request request) {
      StreamController innerController = new StreamController();
      Stream<List<int>> out = innerController.stream;
      Session mySession = session(request);
      //print("session get "+mySession.hashCode.toString());
      int userId = mySession["loggedUser"];
      if (userId == null && shouldLogged) {
        innerController
          ..add(const Utf8Codec().encode(resOutString("Not logged", false)))
          ..close();
        return new shelf.Response.ok(out, headers: headers);
      }
      request.readAsString().then((String data) {
        Object dataOut;
        dataOut = dataChecker(data);
        /*if (shouldData && data.length == 0) {
          print(request.toString());
          innerController
            ..add(const Utf8Codec().encode(resOutString("No data sent", false)))
            ..close();
          return;
        }
        if (data.length != 0 && (data[0] == "{" || data[0] == "[")) {
          dataOut = JSON.decode(data);
        } else {
          dataOut = data;
        }*/
        if (dataOut != null && dataOut is Map && dataOut["suc"] == false) {
          innerController
            ..add(const Utf8Codec().encode(JSON.encode(dataOut)))
            ..close();
          return;
        }
        controller(new RequestContext()
          ..method = method
          ..data = dataOut
          ..request = request
          ..userId = userId
          ..out = innerController);
      });

      //var headers = <String, String>{HttpHeaders.CONTENT_TYPE: "text/json"};
      return new shelf.Response.ok(out, headers: headers);
    };
  }
}
Function checkData(String method, bool shouldData, List<String> dataItems) {
  if (method == "GET") {
    if (!shouldData) {
      return (Map<String, String> data) {
        return data;
      };
    }
    if (dataItems != null && dataItems.length > 0) {
      return (Map<String, String> data) {
        if (data == null || data.length == 0) {
          return resOut("Missing " + dataItems[0] + " parameter", false);
        }
        for (String key in dataItems) {
          if (!data.containsKey(key)) {
            return resOut("Missing " + key + " parameter", false);
          }
          if (data[key] == null) {
            return resOut("Parameter " + key + " must not be null", false);
          }
        }
        return data;
      };
    } else {
      return (Map<String, dynamic> data) {
        if (data == null || data.length == 0) {
          return resOut("Missing some data", false);
        }
        return data;
      };
    }
  } else {
    //if (method == "POST") {
    if (!shouldData) {
      return (String data) {
        if (!data.startsWith("[") && !data.startsWith("{")) {
          return resOut("Post does not contain JSON", false);
        }
        return JSON.decode(data);
      };
    }
    if (dataItems != null && dataItems.length > 0) {
      return (String data) {
        if (!data.startsWith("{")) {
          return resOut("Post does not contain JSON map", false);
        }
        Map<String, dynamic> map = JSON.decode(data);
        for (String key in dataItems) {
          if (!map.containsKey(key)) {
            return resOut("Missing " + key + " parameter", false);
          }
        }
        return map;
      };
    } else {
      return (String data) {
        if (data.length < 7 || !data.startsWith("[") || data.startsWith("{")) {
          return resOut("Post does not contain JSON", false);
        }
        return JSON.decode(data);
      };
    }
  }
  return () {};
}
void route(String path, DHandler controller, {bool logged: false,
    String method: "GET", bool data: false, List<String> dataItems: null}) {
  if (dataItems != null && dataItems.length > 0) {
    data = true;
  }
  if (method == "GET") {
    _myRouter.get(
        path, createInnerRoute(method, controller, logged, data, dataItems),
        middleware: _middle);
  } else if (method == "POST") {
    _myRouter.post(
        path, createInnerRoute(method, controller, logged, data, dataItems),
        middleware: _middle);
  } else if (method == "PUT") {
    _myRouter.put(
        path, createInnerRoute(method, controller, logged, data, dataItems),
        middleware: _middle);
  } else if (method == "DELETE") {
    _myRouter.delete(
        path, createInnerRoute(method, controller, logged, data, dataItems),
        middleware: _middle);
  }
}
/*void routeOLD(String path, DHandler controller,
    {bool data: false, bool logged: false, String method: "GET"}) {
  _myRouter.post(path, (shelf.Request request) {
    StreamController innerController = new StreamController();
    Stream<List<int>> out = innerController.stream;
    request.readAsString().then((String data) {
      dynamic dataOut;
      if (data.length == 0) {
        print(request.toString());
        innerController.add(const Utf8Codec().encode("No data sent"));
        innerController.close();
        return;
      }
      if (data[0] == "{" || data[0] == "[") {
        dataOut = JSON.decode(data);
      } else {
        dataOut = data;
      }
      Map user;
      Map mySession = session(request);
      if (mySession.containsKey("loggedUser")) {
        user = mySession["loggedUser"];
      }
      controller(new RequestContext()
        ..data = dataOut
        ..request = request
        ..user = user
        ..out = innerController);
    });

    var headers = <String, String>{HttpHeaders.CONTENT_TYPE: "text/json"};
    return new shelf.Response.ok(out, headers: headers);
  }, middleware: _middle);
}

void routeGetOLD(String path, DHandler controller) {
  _myRouter.get(path, (shelf.Request request) {
    StreamController innerController = new StreamController();
    Stream<List<int>> out = innerController.stream;

    controller(new RequestContext()
      ..data = null
      ..request = request
      ..user = null
      ..out = innerController);

    var headers = <String, String>{HttpHeaders.CONTENT_TYPE: "text/json"};
    return new shelf.Response.ok(out, headers: headers);
  }, middleware: _middle);
}*/
Future<String> readFile(String url) {
  File dataFile = new File(url);
  return dataFile.readAsString();
}
void saveFile(String url, Object data,{String suffix:null}) {
  String modUrl=url;
  if(suffix!=null){
    int dotPos=modUrl.lastIndexOf(".");
    if(dotPos>=0){
      modUrl=url.substring(0,dotPos)+suffix;
    }
  }
  File dataFile = new File(modUrl);
  dataFile.writeAsString(JSON.encode(data));
}
Map<String, dynamic> resOut(String resp, bool isSucc) {
  return {"resp": resp, "suc": isSucc};
}
String resOutString(String resp, bool isSucc) {
  return JSON.encode(resOut(resp, isSucc));
}
