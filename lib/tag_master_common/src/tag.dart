part of tag_master_common;

class Tag extends Entity {
  String name;
  int type = -1;
  final Relations relations_source = new Relations();
  final Relations relations_target = new Relations();
  List<int> relations_sourceId;
  List<int> relations_targetId;
  static const int CORE = 5;
  static const int CONCRETE = 4;
  static const int COMPOSITE = 3;
  static const int COMMON = 2;
  static const int COMPARABLE = 1;
  Tag() {}
  Tag.copy(Tag source) : super.copy(source) {
    name = source.name;
    type = source.type;
  }
  Tag.create(Map<String, dynamic> json) : super.create(json) {
    fromJson(json);
  }
  void fromJson(Map json) {
    super.fromJson(json);
    if (json.containsKey("name")) {
      name = json["name"];
    }
    if (json.containsKey("type")) {
      type = json["type"];
    }
    if (json.containsKey("relas_src")) {
      relations_sourceId = json["relas_src"];
    }
    if (json.containsKey("relas_trg")) {
      relations_targetId = json["relas_trg"];
    }
  }
  Map toJson() {
    Map out = super.toJson();
    out["name"] = name;
    out["type"] = type;
    out["relas_src"] = relations_source.toIdList();
    out["relas_trg"] = relations_target.toIdList();
    return out;
  }
  Map toShortJson() {
    return {"id": id, "name": name};
  }
  Map toOverview() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "rel_num": [relations_target.length, relations_source.length]
    };
  }
  List<int> getOwnRelations() {
    //return relations_source.toIdList().
    return relations_source.toIdList()..addAll(relations_target.toIdList());
  }
  int compare(Tag tag) {
    int res = 0;
    if (id != tag.id) {
      res += ANOTHER;
    } else if (name != tag.name) {
      res += DIFFERENT;
    } else if (type != tag.type) {
      res += DIFFERENT;
    }
    res *= 10;
    res += relations_target.compare(tag.relations_target);
    res *= 10;
    res += relations_source.compare(tag.relations_source);
    return res;
  }
  bool isValid(){
    return name!=null&&type>0;
  }
  bool merge(List<Repo> repos) {
    List<Tag> tags = [];
    for (Repo repo in repos) {
      Tag tag = repo._tags[id];
      if (tag != null) {
        tags.add(tag);
      }
    }
    //  NAME
    int maxCount = 0;
    Map<String, int> names = {};
    for (Tag tag in tags) {
      String name = tag.name;
      if (!names.containsKey(name)) {
        names[name] = 0;
      }
      if (maxCount <= names[name]) {
        maxCount++;
      }
      names[name] += 1;
    }
    for (String name in names.keys) {
      if (names[name] == maxCount) {
        this.name = name;
      }
    }
    //  TAG TYPE
    List<int> types = [0, 0, 0, 0, 0, 0, 0, 0];
    for (Tag tag in tags) {
      if (maxCount <= types[tag.type]) {
        maxCount++;
      }
      types[tag.type] += 1;
    }
    for (int type in types) {
      if (types[type] == maxCount) {
        this.type = type;
      }
    }
    return true;
  }
}
