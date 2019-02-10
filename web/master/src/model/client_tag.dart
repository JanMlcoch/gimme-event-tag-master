part of tag_master_model;


class ClientTag {

  int id;
  String name;
  List<Function> onTagChanged = [];
  int type;



  List<SimpleTag> sourceTags = [];
  List<SimpleTag> targetTags = [];
  Map<int, ClientRelation> relations = {};

  Map toMustacheJson() {
    Map out = {};
    out["id"] = id;
    out["name"] = name;
    out["type"] = tagTypeText();
    out["isType1"] = type==1;
    out["isType2"] = type==2;
    out["isType3"] = type==3;
    out["isType4"] = type==4;
    out["isType5"] = type==5;
    out["relas"] = new List();
    out["message"] = "";
    out["invalidState"] = false;
//    for (ClientRelation rel in relations)
    int count = 0;
    int validTargetCount = 0;
    relations.forEach((k, rel) {
      Map relJson = rel.toMustacheJson(this, count,model.overviewTags);
      if(relJson["noOptions"]){
        out["message"] = lang.editTag.noValidTarget;
      }else{
        out["relas"].add(relJson);
        count++;
      }
      if((!relJson["validationOk"])&&relJson["notToRemove"]){
        out["invalidState"] = true;
      }
      if(relJson["notToRemove"]&&relJson["from"]){
        validTargetCount++;
      }
    });
    if(type==1&&(validTargetCount!=1)){
      out["invalidState"] = true;
      if(validTargetCount>1){
        out["message"]=out["message"]+"\n"+lang.editTag.tooManySynTargets;
      }else{
        out["message"]=out["message"]+"<br />"+lang.editTag.notEnoughSynTargets;
      }
    }
    return out;
  }

  void fireEvent() {
    onTagChanged.forEach((e) {
      e();
    });
  }

  List<ClientRelation> get relationsFrom {
    List out = [];
    relations.forEach((k, v) {
      if (v.toId != this.id) {
        out.add(v);
      }
    });
    return out;
  }

  List<ClientRelation> get relationsTo {
    List out = [];
    relations.forEach((k, v) {
      if (v.toId == this.id) {
        out.add(v);
      }
    });
    return out;
  }

  ClientTag(int tagId) {
    id = tagId;
    model.overviewTags.onTagsChanged.add(_onChanged);
    model.gateway
    .sendGet(TAG_API, {"user": "central", "id": id})
    .then((Map json) {
      fromJson(json);
      model.waitPlease = false;
//      fillRelations(json["relations_sourceId"],json["relations_targetId"]);
    }).catchError((e) {
      model.gateway.handleError(e);
    });
  }

  static bool isAllowedTypes(int sourceTagType, int targetTagType) {
    if (sourceTagType == 1) {
      return true;
    }
    if (sourceTagType == 2) {
      return false;
    }
    if (sourceTagType == 3) {
      return targetTagType > 2;
    }
    if (sourceTagType == 4) {
      return targetTagType > 3;
    }
    if (sourceTagType == 5) {
      return targetTagType > 4;
    }
    return null;
  }


  static void submitChangesToTagToView() {
    if (model.tagToView.id != null) {
      Map out = {};
      Tag tag = new Tag();
      tag.name = model.tagToView.name;
      out["tags"] = [{"name":model.tagToView.name, "type":model.tagToView.type, "id":model.tagToView.id}];
      out["relations"] = [];
      model.tagToView.relations.forEach((key, rel) {
        print(rel.fromId.toString()+";"+rel.toId.toString()+";"+rel.strength.toString());
        if(rel.notDisabledToBeRemoved)out["relations"].add({"id":Relation.mountsToId(rel.fromId,rel.toId),"str":rel.strength});
        rel.id = key;
        if(rel.fromServer&&rel.disabledToBeRemoved){
          model.gateway.sendDelete(RELATION_API,{"id":rel.id}).then((_){}).catchError((e){model.gateway.handleError(e);});
        }
      });
      model.gateway.sendPut(REL_TAGS_API, out).then((Object e) {
        model.refreshOverviewTags();
        model.waitPlease = false;
      }).catchError((e) {
        model.gateway.handleError(e);
      });
    }
    else {
      List relasSrc = [];
      List relasTrg = [];
      model.tagToView.relations.forEach((key, rel) {
        if (rel.toId == model.tagToView.id) {
          relasTrg.add({"str":rel.strength, "from":rel.fromId});
        }
        if (rel.fromId == model.tagToView.id) {
          relasSrc.add({"str":rel.strength, "to":rel.toId});
        }
      });
      Map out = {"name": model.tagToView.name, "type":model.tagToView.type, "relas_src":relasSrc, "relas_trg":relasTrg};
      model.gateway.sendPost(TAG_API, out).then((e) {
        model.refreshOverviewTags();
        model.waitPlease = false;
      }).catchError((e) {
        model.gateway.handleError(e);
      });
    }
  }

  ClientTag.newTag(String name, int type) {
    this.name = name;
    this.type = type;
  }


  void fromJson(Map json) {

    id = json["tag"]["id"];
    name = json["tag"]["name"];
    type = json["tag"]["type"];

    for (Map rel in json["relas"]) {
      ClientRelation relation = new ClientRelation()
        ..fromJson(rel, id);
      relations[relation.generateId()] = relation;
    }
  }

  void fillRelations(relations_sourceId, relations_targetId) {
    for (int sourceId in relations_sourceId) {
      sourceTags.add(
          model.overviewTags.getTagById(relations[sourceId].toId)
      );
    }

    for (int targetId in relations_targetId) {
      targetTags.add(model.overviewTags.getTagById(relations[targetId].fromId));
    }
    fireEvent();
  }

  String tagTypeText() {
    int tagType = type;
    if (tagType == 1) return lang.typ1;
    if (tagType == 2) return lang.typ2;
    if (tagType == 3) return lang.typ3;
    if (tagType == 4) return lang.typ4;
    if (tagType == 5) return lang.typ5;
    return null;
  }

  static String tagTypeTextStatic(int tagType) {
    if (tagType == 1) return lang.typ1;
    if (tagType == 2) return lang.typ2;
    if (tagType == 3) return lang.typ3;
    if (tagType == 4) return lang.typ4;
    if (tagType == 5) return lang.typ5;
    return null;
  }

  _onChanged() {
//    throw "blbý co";
//    fillRelations(relations_targetId,relations_sourceId);
  }

  void addFromRelation(int idFromTag, double strength) {
    ClientRelation relation = new ClientRelation()
      ..toId = idFromTag
      ..fromId = id
      ..strength = strength;
    relations[relation.generateId()] = relation;
  }

  int generateUniqueRelationsId() {
    bool isUnique = false;
    int id;
    while (!isUnique) {
      id = (1 / (new Random()).nextDouble()).floor();
      isUnique = true;
      relations.forEach((idx, value) {
        if (id == idx) {
          isUnique = false;
        }
      });
    }
    return id;
  }

  void addNewRelation(String orientation) {
    ClientRelation relation = new ClientRelation();
    if (orientation == "from") {
      relation.fromId = id;
      relation.from = true;
      relation.to = false;
    }
    else {
      relation.toId = id;
      relation.from = false;
      relation.to = true;
    }
    relation.isAppropriateSSTagActive = true;
    relation.fromServer = false;
    relation.strength = 0.5;
    if(type==1){relation.strength = 1.0;}
    relation.disabledToBeRemoved = false;
    relation.notDisabledToBeRemoved = true;
    relations[generateUniqueRelationsId()] = relation;
  }

  ClientRelation getRelationByCount(int count) {
    ClientRelation cRel = null;
    relations.forEach((key, rel) {
//      print(count);
//      print(rel.count);
      if (rel.count == count) {
//        print("returned");
        cRel = rel;
      }
    });
    return cRel;
  }

  int getRelationKeyByCount(int count) {
    int keyx;
    relations.forEach((key, rel) {
//      print(count);
//      print(rel.count);
      if (rel.count == count) {
//        print("returned");
        keyx = key;
      }
    });
    return keyx;
  }

  void addToRelation(int idToTag, double strength) {
    ClientRelation relation = new ClientRelation()
      ..toId = id
      ..fromId = idToTag
      ..strength = strength;
    relations[relation.generateId()] = relation;
  }

  Map toJsonPrint() {
    Map out = {"id":id, "name":name, "type":type, "relas":{}};
    relations.forEach((key, rel) {
      out["relas"][key] = rel.toJsonPrint();
    });
    return out;
  }
}

class SimpleTag {
  int id;
  String name;
  int type;
  List<int> relationsCount = [];

  void fromJson(Map json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    relationsCount = json["rel_num"];
  }

  toJson() {
    Map out = {};
    out["id"] = id;
    out["name"] = name;
    out["type"] = type;
    out["typeText"] = ClientTag.tagTypeTextStatic(type);
    out["rel_num"] = relationsCount;
    return out;
  }

  static String getTagNameById(int idx, List<SimpleTag> overviewTags) {
    for (SimpleTag tag in overviewTags) {
      if (tag.id == idx) {
        return tag.name;
      }
    }
    return null;
  }
}