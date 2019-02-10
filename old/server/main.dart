library tag_master.server;

import 'dart:convert';
import '../../server_libs/server/library.dart';
import '../lib/library.dart';
import 'dart:async';
import 'dart:io';
part "tags.dart";

typedef void DHandler(RequestContext context);
TagDep dep = new TagDep();
TagDep flatdep = new TagDep();

void main() {
  
  /*readFile("data/data.json").then((String str) {
    Map<String, dynamic> json = JSON.decode(str);
    loadData(json);
  });*/
  
  loadServer();

  route(TAG_CONTROLLER, (RequestContext context) {
    context.write(dep.printout());
    context.close();
  },method:"GET");

  route(TAG_CONTROLLER, (RequestContext context) {
    context.write(handlePost(context.data));
    context.close();
  },method:"POST");
  route("/api/load", (RequestContext context) {
    context.write(loadData(context.data));
    context.close();
  },method:"POST");

  serve(9999);
// Potřeba, když se bude načítat ze zálohy v data.json
  
  // Potřeba, když se bude načítat ze zálohy v repo.json
  readFile("old/data/tags.json").then((String str) {
    List<dynamic> json = JSON.decode(str);
    loadTags(json);
  });
  new Timer.periodic(new Duration(seconds:2),save);
}
void save(_){
  //print("data.saved");
  new File("old/data/repo.json").writeAsString(JSON.encode(dep.printout()));
}
String handlePost(Map map) {
  if (!map.containsKey("tag")) {
    return prepareOut("Missing tag key", false);
  }
  if (!map.containsKey("oper")) {
    return prepareOut("Missing add key", false);
  }
  String tagname = map["tag"];
  String oper = map["oper"];
  if (oper == "add") {
    if (dep.add(tagname)) {
      flatdep.addTag(dep[tagname]);
      return prepareOut("New tag created", true);
    } else {
      return prepareOut("Tag liked", true);
    }
  } else if (oper == "subtract") {
    if (dep.subtract(tagname)) {
      return prepareOut("Tag disliked", true);
    } else {
      return prepareOut("Tag missing", false);
    }
  } else if (oper == "move") {
    Tag target = flatdep[map["target"]];
    /*if (target == null) {
      return prepareOut("Target missing", false);
    }*/
    Tag tag = flatdep[map["tag"]];
    if (tag == null) {
      return prepareOut("Tag missing", false);
    }
    if (dep.moveTag(tag, target)) {
      return prepareOut("tag moved", true);
    } else {
      return prepareOut("tag cannot be moved", false);
    }
  } else if (oper == "super") {
    Tag tag = flatdep[map["tag"]];
    if (tag == null) {
      return prepareOut("Tag is missing", false);
    }
    if(tag.supertag){
      if(tag.hasChilds()){
        return prepareOut("Tag ${tag.name} have already subtags", true);
      }
      tag.supertag = false;
      return prepareOut("Tag ${tag.name} is no longer supertag", true);
    }else{
      tag.supertag = true;
      return prepareOut("Tag ${tag.name} is now supertag", true);
    }
  }

  return prepareOut("Unknown operation", false);
}
String loadData(Map data) {
  try {
    data.forEach((String tagname, int count) {
      Tag tag = new Tag(tagname)..likes = count;
      dep.addTag(tag);
      flatdep.addTag(tag);
    });
  } on FormatException {
    return prepareOut("Data malformed", false);
  }
  return prepareOut("Data loaded", true);
  
}
String loadTags(List data) {
  try {
    for(Map jtag in data){
      String tagname=jtag["name"];
      Tag tag = new Tag(tagname)..fromJson(jtag);
      dep.addTag(tag);
      flatdep.addTag(tag);
    }
  } on FormatException {
    return prepareOut("Data malformed", false);
  }
  return prepareOut("Data loaded", true);
}
String prepareOut(String resp, bool isSucc) {
  return '{"resp":"${resp}","suc":${isSucc}}';
}
