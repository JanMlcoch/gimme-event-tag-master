import "dart:html";
import "dart:async";
import "dart:convert";
import '../../lib/tag_master_common/library.dart';

int requestOut = 0;
int requestOk = 0;
int requestFailed = 0;

void main() {
  sendPost("/api/reset", {})
      .then((_) => sendPost("/api/tests", {}))
      .then((_) => sendPost(LOGIN_API, {"login": "ringael", "pass": "aaa"}))
      .then((_) => sendPost(USER_API, {"name": "Cesťák"}, method: "PUT"))
      .then((_) => sendGet(USER_API, {}))
      .then((_) => sendGet(TAGS_API, {"extend": "overview"}))
      .then((_) => sendPut(TAGS_API, [{"type": Tag.COMPOSITE, "id": 1}]))
      .then((_) => sendGet(TAG_API, {"user": "central", "id": 1}))
      .then((_) => sendPost(TAG_API, {"name": "zlo", "type": Tag.COMMON}))
      .then((_) => sendGet(TAGS_API, {"extend": "full"}))
      .then((Map<String,dynamic> json2) {
    for (Map<String, dynamic> jtag in json2["tags"]) {
      if (jtag["name"] == "Thilisar") {
        return sendDelete(TAG_API, {"id": jtag["id"]});
      }
    }
  });

  new Timer(new Duration(seconds: 2), () {
    DivElement evalDiv = querySelector("#evaluation");
    if (requestOut != requestOk + requestFailed) {
      evalDiv.innerHtml =
          "Tests do not finished with $requestFailed fails and ${requestOut} missing requests";
      evalDiv.className = "eval-fail";
    } else if (0 == requestFailed) {
      evalDiv.innerHtml = "All $requestOk tests successfully finished";
      evalDiv.className = "eval-ok";
    } else {
      evalDiv.innerHtml =
          "Tests failed with $requestFailed error${requestFailed==1?"":"s"}";
      evalDiv.className = "eval-fail";
    }
    if (requestOut == requestOk + requestFailed) {}
  });
}
Future sendGet(String url, Map<String, dynamic> data) {
  requestOut++;
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
Future sendDelete(String url, Object data) {
  return sendPost(url, data, method: "DELETE");
}
Future sendPost(String url, Object data, {String method: "POST"}) {
  requestOut++;
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
          requestOk++;
        } else {
          //completer.complete(json["resp"]);
          completer.completeError(json["resp"]);
          requestFailed++;
        }
        print(json["resp"]);
        return;
      }
      completer.complete(json);
    } else {
      List<Map> json = JSON.decode(response);
      completer.complete(json);
    }
    requestOk++;
  } on FormatException {
    completer.completeError("Not valid JSON");
    requestFailed++;
  }
}
