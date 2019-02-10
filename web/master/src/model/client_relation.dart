part of tag_master_model;

class ClientRelation {
  int id;
  double strength;
  int fromId;
  int toId;
  bool fromServer;
  static int counter = 0;
  bool from;
  bool to;
  bool disabledToBeRemoved;
  bool notDisabledToBeRemoved;
  int count;
  bool isAppropriateSSTagActive = false;

  Map toMustacheJson(ClientTag encapsulatingTag, int countx, OverviewTags overviewTags) {
    Map out = {};
    out["validationOk"] = true;
    out["id"] = id;
    out["strength"] = strength;
    out["fromId"] = fromId;
    out["toId"] = toId;
    out["fromServer"] = fromServer;
    out["original"] = fromServer;
    out["new"] = !fromServer;
    out["count"] = countx;
    out["isAppropriateSSTagActive"] = isAppropriateSSTagActive;
    this.count = countx;
    out["from"] = from;
    out["to"] = to;
    out["isSynLink"] = (encapsulatingTag.type == 1 && from);
    List<Map> optionsJson = createOptionsMustacheJson(model.overviewTags.tags, encapsulatingTag, this);
    out["options"] = optionsJson;
    out["toRemove"] = disabledToBeRemoved;
    out["notToRemove"] = notDisabledToBeRemoved;
    out["noOptions"] = optionsJson.last["noOptions"];//
    bool isOfAllowedTypes;
    if (from) {
      if (!out["noOptions"]) {
        isOfAllowedTypes = ClientTag.isAllowedTypes(encapsulatingTag.type, overviewTags.getTagById(toId).type);
      } else {
        isOfAllowedTypes = true;
        //aby se navypisovali sekundární zprávy k vymazané relai
      };
    } else {
      if (!out["noOptions"]) {
        isOfAllowedTypes = ClientTag.isAllowedTypes(overviewTags.getTagById(fromId).type, encapsulatingTag.type);
      } else {
        isOfAllowedTypes = true;
        //aby se navypisovali sekundární zprávy k vymazané relai
      };
    }
    if (isOfAllowedTypes||disabledToBeRemoved) {
      out["message"] = "";
    } else {
      out["message"] = lang.invalidRelation;
      out["validationOk"] = false;
    }
    if (from || fromServer)out["fromText"] = SimpleTag.getTagNameById(fromId, model.overviewTags.tags);
    if (to || fromServer)out["toText"] = SimpleTag.getTagNameById(toId, model.overviewTags.tags);
    return out;
  }

  List<Map> createOptionsMustacheJson(List<SimpleTag> overviewTags, ClientTag encapsulatingTag, ClientRelation rel) {
    int targetId;
    if (rel.from) {
      targetId = rel.toId;
    } else {
      targetId = rel.fromId;
    }


    List<Map> out = [];
    bool hasSelectedOption = false;
    for (SimpleTag oTag in overviewTags) {
      Map opt = {};
      opt["typ5"] = oTag.type == 5;
      opt["typ4"] = oTag.type == 4;
      opt["typ3"] = oTag.type == 3;
      opt["typ2"] = oTag.type == 2;
      opt["typ1"] = oTag.type == 1;
      opt["label"] = oTag.name + " (" + ClientTag.tagTypeTextStatic(oTag.type) + ")";
      opt["id"] = oTag.id;
      opt["selected"] = oTag.id == targetId;
      if (opt["selected"]) {
        if (rel.from) {
          rel.toId = oTag.id;
        } else {
          rel.fromId = oTag.id;
        }
        hasSelectedOption = true;
      }
      bool isOfAllowedType;
      if (rel.from) {
        isOfAllowedType = ClientTag.isAllowedTypes(encapsulatingTag.type, oTag.type);
      } else {
        isOfAllowedType = ClientTag.isAllowedTypes(oTag.type, encapsulatingTag.type);
      }
      bool isUniqueRelation = true;
      encapsulatingTag.relations.forEach((key, cRel) {
        if (rel.from) {
          if (cRel.toId == oTag.id)isUniqueRelation = false;
        } else {
          if (cRel.fromId == oTag.id)isUniqueRelation = false;
        }
      });

      opt["disabled"] = !((isOfAllowedType && isUniqueRelation) && oTag.id != encapsulatingTag.id);
      out.add(opt);
    }
    if (!hasSelectedOption) {
      bool hasUnDisabledOption = false;
      for (Map opt in out) {
        if (!opt["disabled"]) {
          if (!hasUnDisabledOption) {
            if (rel.from) {
              rel.toId = opt["id"];
            } else {
              rel.fromId = opt["id"];
            }
            opt["selected"] = true;
          }
          hasUnDisabledOption = true;
        }
      }
      if (!hasUnDisabledOption) {
        out.last["noOptions"] = true;
      } else {
        out.last["noOptions"] = false;
      };
    }
    else {
      out.last["noOptions"] = false;
    }
    return out;
  }

  int generateId() {
    if (model.tagToView.id == null) {
      return ClientRelation.counter++;
    } else {
      return Relation.mountsToId(fromId, toId);
    }
  }

  void fromJson(Map json, int encapsulatingTagId) {
    fromId = json["from"];
    toId = json["to"];
    strength = json["str"];
    fromServer = true;
    disabledToBeRemoved = false;
    notDisabledToBeRemoved = true;
    if (fromId == encapsulatingTagId) {
      from = true;
      to = false;
    }
    else {
      from = false;
      to = true;
    }
  }

  Map toJsonPrint() {
    return {"id":id, "strength":strength, "fromId":fromId, "toId":toId, "fromServer":fromServer, "from":from, "to":to, "disabledToBeRemoved":disabledToBeRemoved, "count":count};
  }
}
