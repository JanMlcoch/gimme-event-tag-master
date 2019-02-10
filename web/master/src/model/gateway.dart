part of tag_master_model;

class Gateway{
  ///koncovky funkci GET - get, POST - vytvor, PUT - update, Delete - odstran

  void send(String url, Map data, _DataIncoming receiver){
    HttpRequest
    .request(url, method: "POST", sendData: JSON.encode(data))
    .then((HttpRequest req) {
      try {
        String response = req.responseText;
        if (response.startsWith("{")) {
          Map<String, dynamic> json = JSON.decode(response);
          if (json.containsKey("suc")) {
            if (json["suc"]) {
              receiver.dataIncoming(json["resp"]);
            } else {
             receiver.dataError(json["resp"]);
            }
            return;
          }
          receiver.dataIncoming(json);
        } else {
          List<Map> json = JSON.decode(response);
          receiver.dataIncoming({"data":json});
        }
      } on FormatException {
        receiver.dataError("Not valid JSON");
      }
    });
  }

  Future sendGet(String url, Map<String, dynamic> data) {
    Completer<Object> completer = new Completer<Object>();
    if (data != null) {
      data.forEach((String key, dynamic val) {
        if (val is! String) {
          data[key] = val.toString();
        }
      });
    }
    Uri uri = new Uri(path: url, queryParameters: data);
    HttpRequest.request(uri.toString(), method: "GET").then((HttpRequest req) {
      handleResponse(req.response, completer);
    });
    return completer.future;
  }


  Future sendPut(String url, Object data) {
    return sendPost(url, data, method: "PUT");
  }


  Future sendDelete(String url, Object data)  {
    return sendPost(url, data, method: "DELETE");
  }


  Future sendPost(String url, Object data, {String method: "POST"}) {
    Completer<Object> completer = new Completer<Object>();
    HttpRequest
    .request(url, method: method, sendData: JSON.encode(data))
    .then((HttpRequest req) {
      handleResponse(req.response, completer);
    });
    return completer.future;
  }
  void handleResponse(String response, Completer completer) {
    try {
      if (response.startsWith("{")) {
        Map<String, dynamic> json = JSON.decode(response);
        if (json.containsKey("suc")) {
          if (json["suc"]) {
            completer.complete(json["resp"]);
          } else {
            //completer.complete(json["resp"]);
            completer.completeError(json["resp"]);
          }
//          print(json["resp"]);
          return;
        }
        completer.complete(json);
      } else {
        List<Map> json = JSON.decode(response);
        completer.complete(json);
      }
    } on FormatException {
      completer.completeError("Not valid JSON");
    }
  }

  void handleError(Object error){//takes care of writing error messages particularly from future errors
//    throw error;
    print("errorbeingprinted");
    print(error);
    model.currentErrorMessage = error.toString();
    model.waitPlease = false;
  }
}
