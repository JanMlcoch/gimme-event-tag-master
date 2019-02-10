//import "dart:html";
//import "dart:async";
//import "dart:convert";
//import 'package:tag_master/tag_master_common/library.dart';
//import 'draw.dart' as draw;
//import 'package:tag_master/ui.dart';
////import 'mustache_templates.dart';
//
//GeneratedResources resources;
//
//Map /*<String,Map>*/ attributes = {
//  "loggedUser": "",
//  //"loggedUser": "",
//  "currentUser": "",
//  "isLogged": false,
////  "downloadedUser": {},
//  "recievedData": {},
////  "menuPath": [],
////  "lastMenuPath": [],
////  "lastErrorMessage": "",
////  "waitPlease": false,
//  "tagIdToView": 0,
////  "canGoBack": false
//};
//
////PageModel pageModel = new PageModel(attributes);
//
//DivElement content = querySelector("#content");
//
//void main() {
//  draw.initBlocks();
//  redraw();
//  HttpRequest.getString("../resources/module.json").then((String jsonString){
//    print(jsonString);
//    resources = new GeneratedResources();
//    resources.fromJson(JSON.decode(jsonString));
//    print(resources.handle_login);
//    print(resources.lang_cz.acceptErrorSauce);
//    print(resources.lang_cz.dalsi_hlaska);
//
//  });
//  ///
//  ///
//  /*sendPost(LOGIN_API, {"login": "ringael", "pass": "aaa"}).then((Object json) {
//    print(JSON.encode(json));
//    sendPost(USER_API, {"name": "Cesťák"}, method: "PUT")
//    .then((Object json) {
//      print(JSON.encode(json));
//      sendGet(USER_API, {}).then((Object json) {
//        print(JSON.encode(json));
//      });
//    });
//    sendGet(TAGS_API, {"extend": "overview"}).then((Object json) {
//      print(JSON.encode(json));
//    });
//    sendPut(TAGS_API, [{"type": COMPOSITE, "id": 1}]).then((Object json) {
//      print(JSON.encode(json));
//      sendGet(TAG_API, {"user": "all", "tag": 1}).then((Object json) {
//        print(JSON.encode(json));
//      });
//    });
//  });*/
//  ///
//  ///
//}
///*Future sendGet(String url, Map<String, dynamic> data) {
//
//  Completer<Object> completer = new Completer<Object>();
//  if (data != null) {
//    data.forEach((String key, dynamic val) {
//      if (val is! String) {
//        data[key] = val.toString();
//      }
//    });
//  }
//  Uri uri = new Uri(path: url, queryParameters: data);
//  HttpRequest.request(uri.toString(), method: "GET").then((HttpRequest req) {
//    handleResponse(req.response, completer);
//  });
//  return completer.future;
//}
//Future sendPut(String url, Object data) {
//  return sendPost(url, data, method: "PUT");
//}
//Future sendPost(String url, Object data, {String method: "POST"}) {
//
//  Completer<Object> completer = new Completer<Object>();
//  HttpRequest
//  .request(url, method: method, sendData: JSON.encode(data))
//  .then((HttpRequest req) {
//    handleResponse(req.response, completer);
//  });
//  return completer.future;
//}
//void handleResponse(String response, Completer completer) {
//  try {
//    if (response.startsWith("{")) {
//      Map<String, dynamic> json = JSON.decode(response);
//      if (json.containsKey("suc")) {
//        if (json["suc"]) {
//          completer.complete(json["resp"]);
//        } else {
//          completer.completeError(json["resp"]);
//
//        }
//        return;
//      }
//      completer.complete(json);
//    } else {
//      List<Map> json = JSON.decode(response);
//      completer.complete(json);
//    }
//  } on FormatException {
//    completer.completeError("Not valid JSON");
//
//  }
//
//}
//
//void isLoggedIn() {
//  //otestuje je-li user na serveru přihlášen a změní příslušnou proměnnou
//  sendGet(TAGS_API, {"user": pageModel.attr("currentUser"), "extend": "query"})
//      .then((Object json) {
//    attributes["isLogged"] = true;
//    sendGet(USER_API, {}).then((Object json) {
//      attributes["downloadedUser"] = json;
//      pageModel.changeParameter(attributes, tryLogged: false);
//    }).catchError((e) {
//      print(e);
//      pageModel.changeParameter(attributes, tryLogged: false);
//    });
//    //pageModel.changeParameter(attributes, tryLogged: false);
//  }).catchError((e) {
//    attributes["isLogged"] = !(e == "You have to be logged");
//    pageModel.changeParameter(attributes, tryLogged: false);
//  });
//  attributes["waitPlease"];
//  pageModel.changeParameter(attributes, tryLogged: false);
//}
//*/
//void submitSynonym(String name, String stringIdOfTarget){
//  int target = int.parse(stringIdOfTarget);
//      print({"type": COMPARABLE, "name": name, "relas":[{"to":target, "str":1}]});
//    sendPost(TAGS_API, [{"type": COMPARABLE, "name": name, "relas":[{"to":target, "str":1}]}]).
//    catchError((e){
//      attributes["lastErrorMessage"] = e;
//      pageModel.changeParameter(attributes);
//    });
//
//
//}
//
//void submitCustom(String name){
//  sendPost(TAGS_API, [{"type": COMMON, "name": name, "relas":[]}]).
//  catchError((e){
//    attributes["lastErrorMessage"] = e;
//    pageModel.changeParameter(attributes);
//  });
//}
//
///*void submitCredentials(login, pass) {
//  sendPost(LOGIN_API, {"login": login, "pass": pass}).then((Object json) {
//    isLoggedIn();
//  }) /**/
//      .catchError((e) {
//    print(e);
//  });
//
//  attributes["currentUser"] = login;
//  attributes["menuPath"] = [];
//  pageModel.changeParameter(attributes);
//  //redraw();
//}
//*/
//void viewTag(int TagId) {
//  //vybere a zobrazí tag k editaci/prohlížení
//  //menuPath[0] = "editTag";
//}
//
//void redraw({tryLogged: true}) {
//  //if(!tryLogged)print(attributes["menuPath"]);
//  //vykresluje stránku
//  if (pageModel.attr("lastErrorMessage") != "") {
//    draw.error();
//    return;
//  }
//  if (tryLogged) {
//    isLoggedIn();
//    draw.pleaseWait();
//    return;
//  }
//  if (pageModel.attr("waitPlease") == true) {
//    draw.pleaseWait(); //vykreslí waitplease stránku
//    attributes["waitPlease"] = false;
//  } else {
//    if (!(pageModel.attr("isLogged") == true)) {
//      draw.login();
//    } else {
//      drawMenu();
//    }
//  }
//  draw.checkForPointers();
//}
//String getLoginName() {
//  if ({} == pageModel.attr("downloadedUser")) {
//    return "";
//  } else {
//    return pageModel.attr("downloadedUser")["name"].toString();
//  }
//}
//
//void logOut() {
//  sendPost(LOGIN_API, {"login": "taliesin", "pass": ""}).catchError((e){attributes["lastErrorMessage"] = e;pageModel.changeParameter(attributes);});
//  //print("Logout is not supported right now.");
//}
//
//void drawMenu({int viewedTag: 0}) {
//  //vykreslí menu (stránky)
//  draw.drawDefaultMenu();
//  if (pageModel.attr("menuPath").length < 1) {
//    draw.welcome();
//  } else {
//    if (pageModel.attr("menuPath")[0] == "overview") {
//      //print("tried ot draw overview");
//      //getOverviewData();
//      sendGet(TAGS_API, {
//        "user": pageModel.attr("currentUser"),
//        "extend": "overview"
//      }).then((Object json) {
//        attributes["recievedData"] = json;
//        attributes["waitPlease"] = false;
//        draw.overview(json);
//      }).catchError((e) {
//        attributes["lastErrorMessage"] = e;
//        pageModel.changeParameter(attributes);
//      });
//    } else if (pageModel.attr("menuPath")[0] == "home") {
//      //print("tried ot draw home");
//      draw.welcome();
//    } else if (pageModel.attr("menuPath")[0] == "viewTag") {
//      sendGet(TAG_API, {"user": "all", "tag": pageModel.attr("tagIdToView")})
//          .then((Object json) {
//        //attributes["recievedData"] = json;
//        attributes["waitPlease"] = false;
//        draw.viewTag(json);
//      }).catchError((e) {
//        attributes["lastErrorMessage"] = e;
//        pageModel.changeParameter(attributes);
//      });
//    } else if (pageModel.attr("menuPath")[0] == "changeType") {
//      draw.notImplemented();
//    } else if (pageModel.attr("menuPath")[0] == "addTag") {
//      if (pageModel.attr("menuPath").length > 1) {
//        int type = int.parse(pageModel.attr("menuPath")[1]);
//        bool cond = (0 < type && type < 6);
//        //print(cond);
//        if (cond) {
//          draw.setUpTag(type);
//        } else {
//          draw.chooseNewTagType();
//        }
//      } else {
//        draw.chooseNewTagType();
//      }
//    }
//    else if(pageModel.attr("menuPath")[0] == "login"){
//      draw.login();
//    }
//  }
//}
