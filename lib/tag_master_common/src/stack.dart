part of tag_master_common;

abstract class Stack {
  final Map<int, Entity> _stack = new Map<int, Entity>();
  Iterable<Entity> get values => _stack.values;
  void fromJson(List json) {
    if (json == null) {
      return;
    }
    _stack.clear();
    for (Map<String, dynamic> jelem in json) {
      Entity elem = creator()..fromJson(jelem);
      _stack[elem.id] = elem;
    }
  }
  List<Map> toJson() {
    List<Map> out = [];
    for (Entity elem in _stack.values) {
      out.add(elem.toJson());
    }
    return out;
  }
  Entity operator [](int i) {
    return _stack[i];
  }
  void operator []=(int i, Entity el) {
    _stack[i] = el;
  }
  bool delete(Entity elem) {
    if(elem==null){return false;}
    return _stack.remove(elem.id) != null;
  }
  int get length {
    return _stack.length;
  }
  void add(Entity elem) {
    _stack[elem.id] = elem;
  }
  Entity creator([Entity el]);
  void copy(Stack source) {
    for (Entity elem in source._stack.values) {
      _stack[elem.id] = creator(elem);
    }
  }
  List<int> toIdList() {
    return _stack.keys.toList();
  }
}
class Tags extends Stack {
  Tag creator([Entity el]) {
    if (el != null) {
      return new Tag.copy(el);
    }
    return new Tag();
  }
  Tag getTag(int tagid) {
    return _stack[tagid];
    /*for(Tag tag in _stack){
      if(tag.name==tagname){
        return tag;
      }
    }
    return null;*/
  }
  /*Tag addTag(Map<String,dynamic> json){
    
  }*/
}
class Relations extends Stack {
  Relation creator([Entity el]) {
    if (el != null) {
      return new Relation.copy(el);
    }
    return new Relation();
  }
  /*void reduceRelations() {
    for (Relation rel in _stack.values.toList()) {
      if (rel.strength < 0.05) {
        _stack.remove(rel.id);
      }
    }
  }*/
  /*void bindTags(Tags tags) {
    for (Relation rel in _stack.values) {
      rel.bindTags(tags);
    }
  }*/
  int compare(Relations relations) {
    if (length != relations.length) {
      return DIFFERENT;
    }
    int minimal = SAME;
    for (Relation relation in _stack.values) {
      int res = relation.compare(relations[relation.id]);
      //print("relation ${relation.toJson()} compares to ${relations[relation.id].toJson()} with similarity $res");
      if (res < minimal) {
        minimal = res;
      }
    }
    return minimal;
  }
}
class Users extends Stack {
  User creator([Entity el]) {
    return new User();
  }
  User getUserByLogin(String login) {
    for (User user in _stack.values) {
      if (user.login == login) {
        return user;
      }
    }
    return null;
  }
  /*List<Tag> getTag(int tagid) {
    List<Tag> tags = [];
    for (User user in _stack.values) {
      Tag tag = user.getTag(tagid);
      if (tag != null) {
        tags.add(tag);
      }
    }
    return tags;
  }*/
  Map overview(Repo repo) {
    List<Map> out = [];
    for (Tag tag in repo._tags.values) {
      List<Map> userOut = [];
      Map<String, dynamic> tagOut = {
        "tag": tag.toShortJson(),
        "users": userOut
      };
      for (User user in _stack.values) {
        Tag userTag = user.repository.getTag(tag.id);
        if (userTag != null) {
          userOut.add({"user": user.login, "cmp": userTag.compare(tag)});
        }
      }
      out.add(tagOut);
    }
    return {"tags": out};
  }
}
class Repos extends Stack{
  Repo creator([Entity el]) {
    return new Repo();
  }
}
