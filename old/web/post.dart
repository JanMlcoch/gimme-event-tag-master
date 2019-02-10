//import 'dart:html';
//import 'dart:convert';
//import 'dart:async';
//
//
//void main() {
//
//  HttpRequest
//  .request("/api/tags", method: "POST", sendData: "moje data")
//  .then((HttpRequest req) {
//    String res = req.response;
//    try {
//      print(res);
//
//
//    } on FormatException {
//
//    }
//  });
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//Future<Map<String, int>> getTags() {
//  Completer<Map<String, int>> completer = new Completer<Map<String, int>>();
//  HttpRequest
//  .request(url, method: "GET", sendData: null)
//  .then((HttpRequest req) {
//    String res = req.response;
//    try {
//      Map<String, dynamic> json = JSON.decode(res);
//      if (json.containsKey("resp") &&
//      json.containsKey("suc") &&
//      json["resp"] is String &&
//      !json["suc"]) {
//        completer.completeError(json["resp"]);
//      }
//      completer.complete(json);
//    } on FormatException {
//      completer.completeError("Not valid JSON");
//    }
//  });
//  return completer.future;
//}
//
//Future<String> addTag(String tag, [bool add = true]) {
//  Completer<String> completer = new Completer<String>();
//
//  Map out = {};
//  out["tag"] = tag;
//  out["add"] = add;
//
//  HttpRequest
//  .request(url, method: "POST", sendData: JSON.encode(out))
//  .then((HttpRequest req) {
//    String res = req.response;
//    try {
//      Map<String, dynamic> json = JSON.decode(res);
//      if (!json.containsKey("resp") || !json.containsKey("suc")) {
//        completer.completeError("Missing valid response from server");
//      }
//      if (json["suc"]) {
//        completer.complete(json);
//      } else {
//        completer.completeError(json["resp"]);
//      }
//    } on FormatException {
//      completer.completeError("Not valid JSON");
//    }
//  });
//  return completer.future;
//}
//
//
//String showList(String tag, int likes) {
//  Map out = {};
//  out["tag"] = tag;
//  out["likes"] = likes;
//
//  String template = """
//      <tr><td>{{tag}}</td><td>{{likes}}</td><td>
//<input type='button' id='like_{{tag}}' class='like' value='like' />
//<input type='button' class='dislike' id='dislike_{{tag}}' value='dislike' />
//      </td></tr>
//  """;
//  return mustache.render(template, out);
//}
//
//void handleTags(Map<String, int> tags) {
//
//  String newTable = "<table>";
//  tags.forEach((String str, int c) {
//    newTable += showList(str, c);
//  });
//  newTable += "</table>";
//  tagList.innerHtml = newTable;
//
//  ElementList likes = querySelectorAll(".like");
//  ElementList dislikes = querySelectorAll(".dislike");
//
//  for(Element like in likes){
//    like.onClick.listen((_){
//      String tag = like.id.replaceAll("like_", "");
//      addTag(tag);
//      redraw();
//    });
//  }
//
//  for(Element like in dislikes){
//    like.onClick.listen((_){
//      String tag = like.id.replaceAll("dislike_", "");
//      addTag(tag, false);
//      redraw();
//    });
//  }
//}
