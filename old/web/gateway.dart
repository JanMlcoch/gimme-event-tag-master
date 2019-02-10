part of tag_master.web;

Future<List<Map>> getTags() {
  Completer<List<Map>> completer = new Completer<List<Map>>();
  HttpRequest
      .request(TAG_CONTROLLER, method: "GET", sendData: null)
      .then((HttpRequest req) {
    String res = req.response;
    try {
      if (res.startsWith("{")) {
        Map<String, dynamic> jsonErr = JSON.decode(res);
        completer.completeError(jsonErr["resp"]);
      } else {
        List<Map> json = JSON.decode(res);
        completer.complete(json);
      }
    } on FormatException {
      completer.completeError("Not valid JSON");
    }
  });
  return completer.future;
}

Future<String> addTag(Tag tag, [bool add = true]) {
  Map out = {};
  out["tag"] = tag.name;
  out["oper"] = add ? "add" : "subtract";
  return sendPost(out);
}
Future<String> moveTag(Tag tag, Tag target) {
  Map out = {};
  out["tag"] = tag.name;
  out["oper"] = "move";
  if (target == null) {
    out["target"] = null;
  } else {
    out["target"] = target.name;
  }
  return sendPost(out);
}
Future<String> superTag(Tag tag, [bool add = true]) {
  Map out = {};
  out["tag"] = tag.name;
  out["oper"] = "super";
  return sendPost(out);
}
Future<String> sendPost(Map data) {
  Completer<String> completer = new Completer<String>();

  HttpRequest
      .request(TAG_CONTROLLER, method: "POST", sendData: JSON.encode(data))
      .then((HttpRequest req) {
    String res = req.response;
    try {
      Map<String, dynamic> json = JSON.decode(res);
      if (!json.containsKey("resp") || !json.containsKey("suc")) {
        completer.completeError("Missing valid response from server");
      }
      if (json["suc"]) {
        completer.complete(json["resp"]);
      } else {
        completer.completeError(json["resp"]);
      }
    } on FormatException {
      completer.completeError("Not valid JSON");
    }
  });
  return completer.future;
}
