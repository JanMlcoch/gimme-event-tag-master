part of tag_master_common;

class Repo extends Entity {
  final Tags _tags = new Tags();
  final Relations _relations = new Relations();
  Repo _prototype;
  //static final Repo _central = new Repo();

  Repo() : super.create(null) {}
  void fromJson(Map<String, dynamic> repositoryData) {
    super.fromJson(repositoryData);
    if (repositoryData.containsKey("tags")) {
      _tags.fromJson(repositoryData["tags"]);
    }
    if (repositoryData.containsKey("relas")) {
      _relations.fromJson(repositoryData["relas"]);
    }
    for (Relation relation in _relations.values.toList(growable: false)) {
      _validateRelation(relation);
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = super.toJson();
    out["tags"] = _tags.toJson();
    out["relas"] = _relations.toJson();
    return out;
    //return {"name":name,"id":id,"tags":_tags.toJson()};
  }
  Map<String, dynamic> tagToJson(int tagId) {
    Tag tag = getTag(tagId);
    if (tag == null) {
      return null;
    }
    List<int> relas = tag.getOwnRelations();
    List<Map> jrelas = [];
    for (int relaId in relas) {
      Relation relation = getRelation(relaId);
      if (relation != null) {
        jrelas.add(relation.toJson());
      }
    }
    Map<String, dynamic> json = {"tag": tag.toJson(), "relas": jrelas};
    return json;
  }
  Map<String, dynamic> tagsToJson(List<int> tagIds) {
    List<Map> jtags = [];
    Set<int> relas = new Set<int>();
    for (int tagId in tagIds) {
      Tag tag = getTag(tagId);
      if (tag == null) {
        continue;
      }
      relas.addAll(tag.relations_source.toIdList());
      relas.addAll(tag.relations_target.toIdList());
      tag = _tags[tagId];
      if (tag == null) {
        continue;
      }
      jtags.add(tag.toJson());
    }
    List<Map> jrelas = [];
    for (int relaId in relas) {
      Relation relation = _relations[relaId];
      if (relation != null) {
        jrelas.add(relation.toJson());
      }
    }
    Map<String, dynamic> json = {"tags": jtags, "relas": jrelas};
    return json;
  }
  Tag getTag(int tagId) {
    Tag tag = _tags.getTag(tagId);
    if (tag == null && _prototype != null) {
      tag = _prototype.getTag(tagId);
    }
    return tag;
  }
  Relation getRelation(int relaId) {
    Relation relation = _relations[relaId];
    if (relation == null && _prototype != null) {
      relation = _prototype.getRelation(relaId);
    }
    return relation;
  }
  bool hasTag(int tagId) {
    return _tags[tagId] != null;
  }
  bool hasRelation(int relaId) {
    return _relations[relaId] != null;
  }
  Iterable<Entity> getTags() {
    return _tags.values;
  }
  Iterable<Entity> getRelations() {
    return _relations.values;
  }
  void set prototype(Repo proto) {
    _prototype = proto;
  }
  String preUpdateTag(json) {
    String preCheck = preCheckAny(json,
        can: {"name": "String", "type": "int"},
        should: {"id": "int"} ,shouldNot:["relas_src","relas_trg"]);
    if (preCheck != null) {
      return preCheck;
    }
    Map<String, dynamic> map = json;
    int tagId = map["id"];
    Tag tag = getTag(tagId);
    if (tag == null) {
      return "Tag with ID=$tagId is not found";
    }
    if (map.containsKey("type") &&
        (json["type"] < Tag.COMPARABLE || json["type"] > Tag.CORE)) {
      return tag.name + " has unknown Tag type";
    }
    return null;
  }
  Tag updateTag(Map<String, dynamic> json) {
    Tag source = getTag(json["id"]);
    Tag tag = _tags[source.id];
    if (tag == null) {
      tag = new Tag.copy(source);
      _tags.add(tag);
    }
    tag.fromJson(json);
    for (Relation relation in _relations.values.toList(growable: false)) {
      _validateRelation(relation);
    }
    return tag;
  }
  String preUpdateRelation(json) {
    String preCheck = preCheckAny(json,
        should: {"id": "int","str": "num"}, shouldNot: ["from", "to"]);
    if (preCheck != null) {
      return preCheck;
    }
    Map<String, dynamic> map = json;
    int relationId = map["id"];
    Relation relation = getRelation(relationId);
    if (relation == null) {
      int fromId = Relation.idToSource(relationId);
      int toId = Relation.idToTarget(relationId);
      if (fromId == toId) {
        return "Relation $relationId cannot be cyclic";
      }
      if (json["str"]==0) {
        return "Relation $relationId strength cannot be zero";
      }
      if (getTag(fromId) == null) {
        return "Relation $relationId should lead from valid Tag";
      }
      if (getTag(toId) == null) {
        return "Relation $relationId should lead to valid Tag";
      }
      //return "Relation with ID=${relationId} is not found";
    }
    return null;
  }
  Relation updateRelation(Map<String, dynamic> json) {
    //TODO
    int relationId=json["id"];
    Relation template = getRelation(relationId);
    if(template==null){
      Tag source=getTag(Relation.idToSource(relationId));
      Tag target=getTag(Relation.idToTarget(relationId));
      return addRelation(json,source:source,target:target);
    }
    Relation relation = _relations[template.id];
    if (relation == null) {
      relation = new Relation.copy(template);
      _relations.add(relation);
    }
    relation.fromJson(json);
    return _validateRelation(relation) ? relation : null;
  }
  String preDeleteTag(json) {
    String preCheck = preCheckAny(json, should: {"id": "int"});
    if (preCheck != null) {
      return preCheck;
    }
    if (!hasTag(json["id"])) {
      return "Tag specified by " + json.toString() + " not found";
    }
    return null;
  }
  Tag deleteTag(int tagId) {
    if (!hasTag(tagId)) {
      return null;
    }
    Tag tag = _tags.getTag(tagId);
    _tags.delete(tag);
    for (Relation relation in _relations.values.toList()) {
      _validateRelation(relation);
    }
    return tag;
  }
  String preDeleteRelation(json) {
    String preCheck = preCheckAny(json, should: {"id": "int"});
    if (preCheck != null) {
      return preCheck;
    }
    if (!hasRelation(json["id"])) {
      return "Relation specified by " + json.toString() + " is not found";
    }
    return null;
  }
  Relation deleteRelation(int relaId) {
    if (!hasRelation(relaId)) {
      return null;
    }
    Relation relation = _relations[relaId];
    relation.deleteItself();
    _relations.delete(relation);
    return relation;
  }
  String preAddTag(json) {
    String preCheck = preCheckAny(json,
        should: {"name": "String", "type": "int"}, shouldNot: ["id"]);
    if (preCheck != null) {
      return preCheck;
    }
    Map<String, dynamic> map = json;
    if (map["type"] < Tag.COMPARABLE || map["type"] > Tag.CORE) {
      return map["name"] + " has unknown Tag type";
    }
    return null;
  }
  Tag addTag(Map<String, dynamic> json) {
    if (_prototype != null) {
      return _prototype.addTag(json);
    }
    Tag tag = new Tag.create(json);
    _tags.add(tag);
    //_digUpRelations(json, tag);
    return tag;
  }
  String preAddRelation(json, {List ignoreMounts: const []}) {
    Map should = {"from": "int", "to": "int", "str": "num"};
    List shouldNot = ["id"];
    //List checkMounts=["from","to"];
    int from = -1,
        to = -1;
    for (String key in ignoreMounts) {
      should.remove(key);
      shouldNot.add(key);
    }
    String preCheck = preCheckAny(json, should: should, shouldNot: shouldNot);
    if (preCheck != null) return preCheck;
    Map<String, dynamic> map = json;
    if (map.containsKey("from")) {
      from = map["from"];
    }
    if (map.containsKey("to")) {
      to = map["to"];
    }
    int relaId = Relation.mountsToId(from, to);
    if (from == to) {
      return "Relation $relaId cannot be cyclic";
    }
    if (json["str"]==0) {
      return "Relation $relaId strength cannot be zero";
    }
    if (hasRelation(relaId)) {
      return "Relation $relaId already exists";
    }
    if (from >= 0 && getTag(from) == null) {
      return "Relation $relaId should lead from valid Tag";
    }
    if (to >= 0 && getTag(to) == null) {
      return "Relation $relaId should lead to valid Tag";
    }
    return null;
  }
  String preAddRelationWithMount(json, {Tag source: null, Tag target: null}) {
    int from;
    int to;
    if (source != null) {
      from = source.id;
      String preCheck =
          preCheckAny(json, should: {"to": "int"}, shouldNot: ["from"]);
      if (preCheck != null) return preCheck;
    }
    if (target != null) {
      from = target.id;
      String preCheck =
          preCheckAny(json, should: {"from": "int"}, shouldNot: ["to"]);
      if (preCheck != null) return preCheck;
    }

    String preCheck =
        preCheckAny(json, should: {"str": "num"}, shouldNot: ["id"]);
    if (preCheck != null) return preCheck;
    Map<String, dynamic> map = json;
    if (source == null) {
      from = map["from"];
    }
    if (target == null) {
      to = map["to"];
    }
    int relaId = Relation.mountsToId(from, to);
    if (from == to) {
      return "Relation $relaId cannot be cyclic";
    }
    if (json["str"]==0) {
      return "Relation $relaId strength cannot be zero";
    }
    if (hasRelation(relaId)) {
      return "Relation $relaId already exists";
    }
    if (source == null && getTag(from) == null) {
      return "Relation $relaId should lead from valid Tag";
    }
    if (target == null && getTag(to) == null) {
      return "Relation $relaId should lead to valid Tag";
    }
    return null;
  }
  Relation addRelation(Map<String, dynamic> json,
      {Tag source: null, Tag target: null}) {
    Relation relation = new Relation.create(json);
    relation.setMounts(source: source, target: target);
    if (!_validateRelation(relation)) {
      return null;
    }
    _relations.add(relation);
    return relation;
  }
  bool _validateRelation(Relation relation) {
    if (!relation.validate(this)) {
      relation.deleteItself();
      _relations.delete(relation);
      //print (relation.toJson());
      //print ("failed");
      return false;
    }
    return true;
  }
  Map<String, dynamic> overview() {
    List<Map> tags = [];
    for (Tag tag in _tags.values) {
      tags.add(tag.toOverview());
    }
    return {"tags": tags};
  }
  String preCheckAny(json, {Map<String, String> should: const {},
      List<String> shouldNot: const [], Map<String, String> can: const {}}) {
    if (json is! Map<String, dynamic>) {
      return json.toString() + " is not valid Map";
    }
    Map<String, dynamic> map = json;
    List<String> message = [];
    for (String key in should.keys) {
      if (!map.containsKey(key) || map[key] == null) {
        message.add(" should contain \"$key\"");
      }
    }
    for (String key in shouldNot) {
      if (map.containsKey(key)) {
        message.add(" should not contain \"$key\"");
      }
    }
    if (message.isNotEmpty) {
      return map.toString() + message.join(" and");
    }
    Function typeCheckerBuilder(bool isCan) {
      return (String key, String type) {
        if (isCan && !map.containsKey(key)) {
          return;
        }
        if (type == "String" && (map[key] is! String || map[key].length == 0)) {
          message.add(" \"$key\" parameter should be $type");
        }
        if (type == "int" && (map[key] is! int)) {
          message.add(" \"$key\" parameter should be $type");
        }
        if (type == "num" && (map[key] is! num)) {
          message.add(" \"$key\" parameter should be $type");
        }
      };
    }
    ;
    should.forEach(typeCheckerBuilder(false));
    can.forEach(typeCheckerBuilder(true));
    if (message.isNotEmpty) {
      return map.toString() + message.join(" and");
    }
    return null;
  }
}
