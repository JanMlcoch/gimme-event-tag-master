//import "dart:html";
//import "dart:math";
////import "dart:async";
//import "dart:convert";
//import 'package:dart_ext/collection_ext.dart';
//import 'package:tag_master/tag_master_common/library.dart';
//import 'mustache_templates.dart' as template;
//import 'package:mustache4dart/mustache4dart.dart';
//import 'main.dart';
//
//Element subContent;
//
//int requestOut = 0;
//int requestOk = 0;
//int requestFailed = 0;
//
//void initBlocks() {
//  template.tetrisBlocks();
//}
//
//void drawDefaultMenu() {
//  content.setInnerHtml("");
//  template.defaultMenu.json["cannotGoBack"] = !pageModel.attr("canGoBack");
//  content.setInnerHtml(template.defaultMenu.renderBlock());
//  subContent = querySelector("#sub_content");
//  SpanElement loginName = querySelector(".loginName");
//  if (!(null == loginName)) loginName.setInnerHtml(getLoginName());
//  InputElement logout = querySelector(".logout");
//  if (!(null == logout)) logout.onClick.listen((MouseEvent e) {
//    logOut();
//  });
//  InputElement toOverview = querySelector("#toOverview");
//  if (!(null == toOverview)) toOverview.onClick.listen((MouseEvent e) {
//    navigate("overview");
//  });
//  InputElement toHome = querySelector("#toHome");
//  if (!(null == toHome)) toHome.onClick.listen((MouseEvent e) {
//    navigate("home");
//  });
//  InputElement back = querySelector("#backButton");
//  if (!(null == back)) back.onClick.listen((MouseEvent e) {
//    navigate("",back: true);
//  });
//  InputElement relog = querySelector("#relog");
//  if (!(null == relog)) relog.onClick.listen((MouseEvent e) {
//    navigate("login");
//  });
//
//  InputElement add = querySelector("#addTag");
//  //print(!(null == add));
//    if (!(null == add)) add.onClick.listen((MouseEvent e) {
//      navigate("addTag");
//      print("pushed");
//    });
//}
//
//void welcome() {
//  subContent.setInnerHtml("<h1>" + template.texts["welcomeSauce"] + "</h1>");
//}
//
//void viewTagId(int id){
//  attributes["tagIdToView"]=id;
//  navigate("viewTag");
//}
//
//void overview(Object json) {
//  List jsonL = json;
//  for(int i = 0;i<jsonL.length;i++){
//    int yourDiff = 0;
//    int totalDiff = 0;
//    for(int j=0;j<jsonL[i]["users"].length;j++){
//      totalDiff = totalDiff + 3-jsonL[i]["users"][j]["cmp"];
//      if(jsonL[i]["users"][j]["user"]==pageModel.attr("downloadedUser")["id"]){
//        yourDiff = yourDiff + 3-jsonL[i]["users"][j]["cmp"];
//      };
//    }
//    totalDiff = totalDiff - yourDiff;
//
//    int red = max(0,255-90*yourDiff-23*totalDiff);
//    int green = max(0,255-23*totalDiff);
//    int blue = max(0,255-90*yourDiff);
//
//
//    jsonL[i]["color"] = "rgb("+red.toString()+","+green.toString()+","+blue.toString()+")";
//
//  }
//  NodeValidatorBuilder nodeValidator = new NodeValidatorBuilder.common();
//  nodeValidator.allowInlineStyles();
//  //NodeTreeSanitizer sanitizer = new NodeTreeSanitizer(nodeValidator);
//
//
//  String toInclude = template.overview.renderWithJson({"tags":jsonL});
//  /*Element toSubContent = new Element();
//  toSubContent.setInnerHtmt();
//
//  subContent.children.clear();*/
//  subContent.setInnerHtml(toInclude,validator:nodeValidator);
//
//  for(Map i in json){
//    InputElement viewTag = querySelector("#viewtag"+i["tag"]["id"].toString());
//    //print("#viewTag"+i["tag"]["id"].toString());
//    viewTag.onClick.listen((MouseEvent e) {
//      viewTagId(i["tag"]["id"]);
//    });
//  }
//}
//
//void addRelationRowInputs({int from:0}){
//  int newRels = 0;
//  while(!(querySelector("#newRel"+newRels.toString())==null)){newRels++;}
//  querySelector("#relTable").appendHtml(template.relRow.renderWithJson({"relRowId":"#newRel"+newRels.toString(),"from":from}));
//}
//
//void notImplemented(){
//  subContent.setInnerHtml(template.texts["notReadySauce"]);
//}
//
//
//void viewTag(Object json){
//  //subContent.setInnerHtml(template.viewTag.renderWithJson(json));
//  String toHtml = template.viewTag.renderWithJson(json);
//  toHtml += template.buttonToEditTag.renderBlock();
//  Map jsonM = json;
//  for(Map i in jsonM["users"]){//TODO: will be different after API change
//    toHtml+="<h3>dalsi uzivatelska verze (mozna tvoje)</h3>";
//    toHtml+=template.viewTag.renderWithJson({"tag":i});
//  }
//  subContent.setInnerHtml(toHtml);
//
//  Element tagType = querySelector("#tagType");
//
//  if(tagType.innerHtml == 5.toString()){tagType.setInnerHtml(template.texts["coreSauce"]);}
//  if(tagType.innerHtml == 4.toString()){tagType.setInnerHtml(template.texts["concreteSauce"]);}
//  if(tagType.innerHtml == 3.toString()){tagType.setInnerHtml(template.texts["compositeSauce"]);}
//  if(tagType.innerHtml == 2.toString()){tagType.setInnerHtml(template.texts["commonSauce"]);}
//  if(tagType.innerHtml == 1.toString()){tagType.setInnerHtml(template.texts["comparableSauce"]);}
//
//  sendGet(TAGS_API, {
//          "user": pageModel.attr("currentUser"),
//          "extend": "overview"
//          }).then((Object json) {
//             // bool changed = false;
//              Map jsonM = json;
//              List tagIds = querySelectorAll(".tagId");
//              for (int i=0;i<tagIds.length;i++){
//                for (int j=0;j<jsonM.length;j++){
//                  if (jsonM[j]["tag"]["id"].toString() == tagIds[i].innerHtml){
//                    tagIds[i].setInnerHtml(jsonM[j]["tag"]["name"]);
//                  }
//                }
//              }
//          }).catchError((e) {
//          attributes["lastErrorMessage"] = e;
//          pageModel.changeParameter(attributes);
//        });
//
//  Element edit = querySelector("#edittag"/*+jsonM["tag"]["id"].toString()*/);
//  edit.onClick.listen((MouseEvent e) {
//    editTag(json);
//  });
//
//}
//
//void editTag(Object json){
//  Map jsonM = json;
//  sendGet(TAGS_API, {"user": pageModel.attr("currentUser"), "extend": "query"})
//  .then((Object json2) {
//    for(Map i in json2){
//      if(i["type"]==1)i["Typ1"]=true;
//      if(i["type"]==2)i["Typ2"]=true;
//      if(i["type"]==3)i["Typ3"]=true;
//      if(i["type"]==4)i["Typ4"]=true;
//      if(i["type"]==5)i["Typ5"]=true;
//    }
//    {
//      Map i = jsonM["tag"];
//      if(i["type"]==1)i["Typ1"]=true;
//      if(i["type"]==2)i["Typ2"]=true;
//      if(i["type"]==3)i["Typ3"]=true;
//      if(i["type"]==4)i["Typ4"]=true;
//      if(i["type"]==5)i["Typ5"]=true;
//    }
//    List relas = jsonM["tag"]["relas"];
//    for(int i=0;i<relas.length;i++){
//      relas[i]["count"] = i;
//    }
//    bool isNotSyn = true;
//    bool isCore = false;
//    bool isCustom =false;
//    if(jsonM["tag"]["type"]==1){isNotSyn = false;}
//    if(jsonM["tag"]["type"]==5){isCore = true;}
//    if(jsonM["tag"]["type"]==2){isCore = true;}
//
//    subContent.setInnerHtml(template.editTag.renderWithJson({"taggs":json2,"tag":jsonM["tag"],"core":isCore,"custom": isCustom, "notSyn": isNotSyn}));
//    for(int i=0;i<relas.length;i++){
//      OptionElement toSelect = querySelector("#o"+i.toString()+"_"+relas[i]["to"].toString());
//      toSelect.selected = true;
//    }
//    InputElement add = querySelector("#addRelation");
//    add.onClick.listen((MouseEvent e) {
//
//      Element table = querySelector("#relTable");
//      int rels = 0;
//      while(!(querySelector("#selectTarget"+rels.toString())==null)){rels++;}
//      //String htmlToAppend = template.targetedRelationInTr2.renderWithJson({"count":rels,"tags":json}).replaceAll("<tr>",render("<tr><td></td><td>{{tName}}</td>",{"tName": pageModel.attr("tagToView")}));
//      table.appendHtml(template.targetedRelationInTr2.renderWithJson({"count":rels,"taggs":json2,"str":0,"id":template.texts["willBe"],"name":jsonM["tag"]["name"]}));/*htmlToAppend);*/
//      //print(template.targetedRelationInTr2.template);
//      //print({"count":rels,"taggs":json2,"str":0,"id":template.texts["willBe"],"name":pageModel.attr("tagToView")});
//    });
//    InputElement submit = querySelector("#submitTag");
//    submit.onClick.listen((MouseEvent e){
//      List relas = [];
//      int rels=0;
//      while(!(querySelector("#selectTarget"+rels.toString())==null)){
//        InputElement toEl = querySelector("#selectTarget"+rels.toString());
//        InputElement strEl =querySelector("#str"+rels.toString());
//        int to = int.parse(toEl.value);
//        double str = double.parse(strEl.value);
//        relas.add({"to":to,"str":str});
//        rels++;
//      }
//      InputElement name = querySelector("#inputTagName");
//      Map jsonToUpload = {
//        "id": jsonM["tag"]["id"],
//        "name":name.value,
//        "type":jsonM["tag"]["type"],
//        "relas":relas
//      };
//
//
//      sendPut(TAGS_API, [jsonToUpload]).then((Object json){navigate("viewTag");}).catchError((e){handleError(e);});
//    });
//  }).catchError((e){handleError(e);});
//}
//
//void submitChangesToTag(){//TODO: write function
//
//}
//
//void error() {
//  subContent
//    ..setInnerHtml(pageModel.attr("lastErrorMessage").toString())
//    ..appendHtml(template.acceptError.renderBlock());
//  InputElement acceptError = querySelector("#acceptError");
//  attributes["lastErrorMessage"] = "";
//  if (!(null == acceptError)) {
//    acceptError.onClick.listen((MouseEvent e) {
//      attributes["lastErrorMessage"] = "";
//      pageModel.changeParameter(attributes);
//    });
//  }
//}
//
//void login() {
//  drawDefaultMenu();
//  String htmlToDraw = template.login.renderBlock();
//  subContent.setInnerHtml(htmlToDraw);
//  InputElement sub = querySelector("#submitCredentials");
//  if (!(null == sub)) sub.onClick.listen((MouseEvent e) {
//    InputElement loginElement = querySelector("#login");
//    String login = loginElement.value;
//    InputElement password = querySelector("#password");
//    String pass = password.value;
//    submitCredentials(login, pass);
//  });
//}
//
//void pleaseWait() {
//  drawDefaultMenu();
//  subContent.setInnerHtml(template.waitPlease.renderBlock());
//}
//
//void chooseNewTagType(){
//  subContent.setInnerHtml(template.chooseNewTagType.renderBlock());
//  InputElement submit = querySelector("#submit");
//      submit.onClick.listen((MouseEvent e) {
//        SelectElement typSelect = querySelector("#tagTypeSelect");
//        navigate(typSelect.value,i: 1);
//      });
//
//}
//
//void setUpTag(int type){
//  print(type);
//  if(type == 1){
//    sendGet(TAGS_API, {"user": pageModel.attr("currentUser"), "extend": "query"})
//    .then((Object json) {
//      for(Map i in json){
//        if(i["type"]==1)i["Typ1"]=true;
//        if(i["type"]==2)i["Typ2"]=true;
//        if(i["type"]==3)i["Typ3"]=true;
//        if(i["type"]==4)i["Typ4"]=true;
//        if(i["type"]==5)i["Typ5"]=true;
//      }
//      subContent.setInnerHtml(template.setupSynonym.renderWithJson({"tags":json}));
//      InputElement sub = querySelector("#submit");
//      sub..onClick.listen((MouseEvent e) {
//        SelectElement target = querySelector("#selectTarget");
//        SelectElement name = querySelector("#name");
//        submitSynonym(name.value,target.value);
//        navigate("overview");
//      });
//    }).catchError((e) {
//      attributes["isLogged"] = !(e == "You have to be logged");
//      attributes["lastErrorMessage"] = e;
//      pageModel.changeParameter(attributes, tryLogged: false);
//    });
//    return;
//  }
//  if(type == 2){
//    subContent.setInnerHtml(template.setupCustom.renderBlock());
//    InputElement sub = querySelector("#submit");
//    sub..onClick.listen((MouseEvent e) {
//      SelectElement name = querySelector("#name");
//      submitCustom(name.value);
//      navigate("overview");
//    });
//    return;
//  }
//  if(type == 3 || type==4){
//
//    sendGet(TAGS_API, {"user": pageModel.attr("downloadedUser")["id"], "extend": "query"})
//    .then((Object json) {
//      for(Map i in json){
//        if(i["type"]==1)i["Typ1"]=true;
//        if(i["type"]==2)i["Typ2"]=true;
//        if(i["type"]==3)i["Typ3"]=true;
//        if(i["type"]==4)i["Typ4"]=true;
//        if(i["type"]==5)i["Typ5"]=true;
//      }
//      subContent.setInnerHtml(template.setupComposite.renderWithJson({"tags":json,"count":1}));
//      InputElement sub = querySelector("#submit");
//      sub.onClick.listen((MouseEvent e) {
//        //SelectElement target = querySelector("#selectTarget");
//        SelectElement name = querySelector("#name");
//        List relas = [];
//        int rels=1;
//        while(!(querySelector("#selectTarget"+rels.toString())==null)){
//          InputElement toEl = querySelector("#selectTarget"+rels.toString());
//          InputElement strEl =querySelector("#str"+rels.toString());
//          int to = int.parse(toEl.value);
//          double str = double.parse(strEl.value);
//          relas.add({"to":to,"str":str});
//          rels++;
//        }
//        Map jsonUp = {
//          "type": type,
//          "name": name.value,
//          "relas": relas
//        };
//        print(jsonUp);
//        sendPost(TAGS_API, [jsonUp]).then((Object json){navigate("overview");}).catchError((e){handleError(e);});
//
//      });
//      InputElement add = querySelector("#add");
//      add.onClick.listen((MouseEvent e) {
//        Element table = querySelector("#tableOfTargetedRelations");
//        int rels = 1;
//        while(!(querySelector("#selectTarget"+rels.toString())==null)){rels++;}
//        table.appendHtml(template.targetedRelationInTr.renderWithJson({"count":rels,"tags":json}));
//      });
//    }).catchError((e) {
//      attributes["isLogged"] = !(e == "You have to be logged");
//      attributes["lastErrorMessage"] = e;
//      pageModel.changeParameter(attributes, tryLogged: false);
//    });
//    return;
//  }
//  if(type == 5){
//
//    sendGet(TAGS_API, {"user": pageModel.attr("downloadedUser")["id"], "extend": "query"})
//    .then((Object json) {
//      for(Map i in json){
//        if(i["type"]==1)i["Typ1"]=true;
//        if(i["type"]==2)i["Typ2"]=true;
//        if(i["type"]==3)i["Typ3"]=true;
//        if(i["type"]==4)i["Typ4"]=true;
//        if(i["type"]==5)i["Typ5"]=true;
//      }
//      subContent.setInnerHtml(template.setupComposite.renderWithJson({"tags":json,"count":1,"core":true}));
//      InputElement sub = querySelector("#submit");
//      sub.onClick.listen((MouseEvent e) {
//        //SelectElement target = querySelector("#selectTarget");
//        SelectElement name = querySelector("#name");
//        List relas = [];
//        int rels=1;
//        while(!(querySelector("#selectTarget"+rels.toString())==null)){
//          InputElement toEl = querySelector("#selectTarget"+rels.toString());
//          InputElement strEl =querySelector("#str"+rels.toString());
//          int to = int.parse(toEl.value);
//          double str = double.parse(strEl.value);
//          relas.add({"to":to,"str":str});
//          rels++;
//        }
//        Map jsonUp = {
//          "type": type,
//          "name": name.value,
//          "relas": relas
//        };
//        print(jsonUp);
//        sendPost(TAGS_API, [jsonUp]).then((Object json){navigate("overview");}).catchError((e){handleError(e);});
//
//      });
//      InputElement add = querySelector("#add");
//      add.onClick.listen((MouseEvent e) {
//        Element table = querySelector("#tableOfTargetedRelations");
//        int rels = 1;
//        while(!(querySelector("#selectTarget"+rels.toString())==null)){rels++;}
//        table.appendHtml(template.targetedRelationInTr.renderWithJson({"count":rels,"tags":json,"core":true}));
//      });
//    }).catchError((e) {
//      attributes["isLogged"] = !(e == "You have to be logged");
//      attributes["lastErrorMessage"] = e;
//      pageModel.changeParameter(attributes, tryLogged: false);
//    });
//    return;
//  };
//}
//
//void handleError(String error){
//  attributes["lastErrorMessage"] = error;
//  pageModel.changeParameter(attributes);
//}
//
//void navigate(String where, {int i: 0, bool back:false}) {
//  if(back){
//    attributes["menuPath"]=attributes["lastMenuPath"];
//    attributes["canGoBack"] = false;
//    pageModel.changeParameter(attributes);
//    return;
//  }
//  attributes["lastMenuPath"] = JSON.decode(JSON.encode(attributes["menuPath"]));
//  attributes["canGoBack"] = true;
//  if (pageModel.attr("menuPath").length > i) {
//    if (pageModel.attr("menuPath")[i] == where) {
//      pageModel.changeParameter(attributes);
//      return;
//    }
//    attributes["menuPath"][i] = where;
//    /*for (int j = i + 1; j < pageModel.attr("menuPath").length; j++) {
//      attributes["menuPath"][i] = Null;
//    }*/
//    attributes["menuPath"].length = i+1;
//  } else {
//    if (pageModel.attr("menuPath").length == i) {
//      attributes["menuPath"].add(where);
//    } else {
//      attributes["lastErrorMessage"] = template.texts["lostInNavigation"];
//    }
//  }
//  print(attributes["menuPath"].toString());
//  pageModel.changeParameter(attributes);
//  //redraw();
//}
//
////TODO: implement pointerChecker
//
//void checkForPointers(){
//  List toSubstituteUsernames = querySelectorAll(".userId");
//}
//
