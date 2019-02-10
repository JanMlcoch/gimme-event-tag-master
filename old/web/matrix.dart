//import 'dart:html';
//import 'dart:convert';
//import 'dart:async';
//import 'package:mustache4dart/mustache4dart.dart' as mustache;
////import "../server_libs/server/library.dart";
//import 'package:tag_master/tag_master_common/library.dart';
//final String url = "/api/tag";
//
//DivElement errorLog;
//InputElement submit;
//InputElement hide;
//InputElement refresh;
//DivElement blocks;
//DivElement matrix;
//
//Tags dataTags ;
//List dataMatrix;
//List dataBlocks;
//
//void main() {
//
//  WebSocket socket = new WebSocket('ws://${window.location.host}$SOCKET_CONTROLLER');
//  socket.onOpen.listen((_){
//    socket.send(JSON.encode({"action": "my", "data": "pure"}));
//  });
//  socket.onMessage.listen((MessageEvent message){
//    Map json = JSON.decode(message.data.toString());
//
//    window.alert(json.toString());
//
//  });
//
//
//
//
//  errorLog = querySelector("#erLog");
//  submit = querySelector("#submit");
//  blocks = querySelector("#blocks");
//  matrix = querySelector("#matrix");
//  hide = querySelector("#hide");
//  refresh = querySelector("#refresh");
//
//  redraw();
//}
//
//void redraw(){
//
//  getData().then(handleData).catchError((String e) {
//    querySelector("#erLog").innerHtml = e.toString();
//  });
//}
//
//Future<Map<String, int>> getData() {
//  Completer<Map<String, int>> completer = new Completer<Map<String, int>>();
//  HttpRequest
//  .request(url, method: "POST", sendData: null)
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
//
//void createBlockTable(dataBlocks){
//  String innerHTML = "<table>";
//  for(int i=0;i<dataBlocks.length;i++){
//      innerHTML += "<tr>";
//      for(int j=0;j<dataBlocks.length;j++){
//            innerHTML += "<td>";
//            innerHTML += "<div id='block_${i}_$j'></div>";
//            innerHTML += "</td>";
//        }
//      innerHTML += "</tr>";
//  }
//
//  innerHTML += "</table>";
//  blocks.innerHtml = innerHTML;
//  for(int i=0;i<dataBlocks.length;i++){
//        for(int j=0;j<dataBlocks.length;j++){
//              DivElement curDiv = querySelector("#block_${i}_$j");
//              curDiv.onClick.listen((_){
//                select_block(i,j);
//               });
//              if(dataBlocks[i][j].isBeingEdited){
//                curDiv.style.backgroundColor = "red";
//              }
//              else if(dataBlocks[i][j].isDone){
//
//              }
//          }
//    }
//
//}
//
//void handleData(data){
//  dataTags = data.tags;
// dataMatrix = data.matrix;
//  dataBlocks = data.blocks;
//
//  refresh.onClick.listen((_){
//       redraw();
//      });
//
//  hide.onClick.listen((_){
//    if(blocks.style.visibility=="hidden"){
//      blocks.style.visibility="visible";
//      matrix.style.visibility="hidden";
//    }else{
//      blocks.style.visibility="hidden";
//      matrix.style.visibility="visible";
//    }
//       });
//
//  createBlockTable(){
//
//  }
//
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
////
////Future<Map<String, int>> getTags() {
////  Completer<Map<String, int>> completer = new Completer<Map<String, int>>();
////  HttpRequest
////      .request(url, method: "GET", sendData: null)
////      .then((HttpRequest req) {
////    String res = req.response;
////    try {
////      Map<String, dynamic> json = JSON.decode(res);
////      if (json.containsKey("resp") &&
////          json.containsKey("suc") &&
////          json["resp"] is String &&
////          !json["suc"]) {
////        completer.completeError(json["resp"]);
////      }
////      completer.complete(json);
////    } on FormatException {
////      completer.completeError("Not valid JSON");
////    }
////  });
////  return completer.future;
////}
////
////Future<String> addTag(String tag, [bool add = true]) {
////  Completer<String> completer = new Completer<String>();
////
////  Map out = {};
////  out["tag"] = tag;
////  out["add"] = add;
////
////  HttpRequest
////      .request(url, method: "POST", sendData: JSON.encode(out))
////      .then((HttpRequest req) {
////    String res = req.response;
////    try {
////      Map<String, dynamic> json = JSON.decode(res);
////      if (!json.containsKey("resp") || !json.containsKey("suc")) {
////        completer.completeError("Missing valid response from server");
////      }
////      if (json["suc"]) {
////        completer.complete(json);
////      } else {
////        completer.completeError(json["resp"]);
////      }
////    } on FormatException {
////      completer.completeError("Not valid JSON");
////    }
////  });
////  return completer.future;
////}
////
////
////String showList(String tag, int likes) {
////  Map out = {};
////  out["tag"] = tag;
////  out["likes"] = likes;
////
////  String template = """
////      <tr><td>{{tag}}</td><td>{{likes}}</td><td>
////<input type='button' id='like_{{tag}}' class='like' value='like' />
////<input type='button' class='dislike' id='dislike_{{tag}}' value='dislike' />
////      </td></tr>
////  """;
////  return mustache.render(template, out);
////}
////
////void handleTags(Map<String, int> tags) {
////
////  String newTable = "<table>";
////  tags.forEach((String str, int c) {
////    newTable += showList(str, c);
////  });
////  newTable += "</table>";
////  tagList.innerHtml = newTable;
////
////  ElementList likes = querySelectorAll(".like");
////  ElementList dislikes = querySelectorAll(".dislike");
////
////  for(Element like in likes){
////    like.onClick.listen((_){
////      String tag = like.id.replaceAll("like_", "");
////      addTag(tag);
////      redraw();
////    });
////  }
////
////  for(Element like in dislikes){
////      like.onClick.listen((_){
////        String tag = like.id.replaceAll("dislike_", "");
////        addTag(tag, false);
////        redraw();
////      });
////    }
////}
