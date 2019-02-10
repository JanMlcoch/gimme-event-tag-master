part of tag_master_common;

// (full name required)
abstract class Entity {
  int id;
  static int _lastId = 0;

  Entity();

  Entity.copy(Entity source){
    id = source.id;
  }

  Entity.create(Map json){
    id = getFreeId();
  }

  static int getFreeId(){
    return _lastId++;
  }
  static void seed(int newSeed) {
    _lastId = newSeed;
  }
  void fromJson(Map json){
    if (id != null) {
      //print("Elem already have ID $id, new value $jid rejected");
      return;
    }
    int jid = json["id"];
    if(jid is! int || jid == null){
      id = getFreeId();
      return;
    }
    id = jid;
    // unnecessary condition jid must be int by type checking conventions
    // if no error arise, turn on checked model by system flag
//    if(jid is int){
    if(jid >= _lastId){
      _lastId = jid + 1;
    }
//    }
  }
  static List<int> collectionToJson(Iterable<Entity> collection) {
    List<int> result = [];
    for (Entity entity in collection) {
      result.add(entity.id);
    }
    return result;
  }
  Map toJson(){
    return {"id":id};
  }
}