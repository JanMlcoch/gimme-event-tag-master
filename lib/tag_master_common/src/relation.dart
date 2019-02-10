part of tag_master_common;

class Relation extends Entity {
  int _fromTagId;
  int _toTagId;
  Tag fromTag;
  Tag toTag;
  double strength = 0.0;
  static const int idSeparator = 100000;

  Relation() {}
  Relation.create(Map json) : super.create(json) {
    fromJson(json);
  }
  Relation.copy(Relation source) : super.copy(source) {
    _fromTagId = source._fromTagId;
    _toTagId = source._toTagId;
    strength = source.strength;
  }
  //Relation.create(Tag from,Tag to,this.strength){}
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    if (json.containsKey("from") && _fromTagId == null) {
      _fromTagId = json["from"];
    }
    if (json.containsKey("to") && _toTagId == null) {
      _toTagId = json["to"];
    }
    if (json.containsKey("str")) {
      strength = (json["str"] as num).toDouble();
    }
    setMounts();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = super.toJson();
    out.remove("id");
    out["from"] = _fromTagId;
    out["to"] = _toTagId;
    out["str"] = strength;
    return out;
  }
  void setMounts({Tag source: null, Tag target: null}) {
    if (source != null) {
      _fromTagId = source.id;
    }
    if (target != null) {
      _toTagId = target.id;
    }
    if (_fromTagId != null && _toTagId != null) {
      id = mountsToId(_fromTagId, _toTagId);
    }
  }
  static int mountsToId(int from, int to) {
    return from * idSeparator + to;
  }
  static int idToSource(int idd) {
    return (idd / idSeparator).floor();
  }
  static int idToTarget(int idd) {
    return idd % idSeparator;
  }
  bool validate(Repo repo) {
    // Vazba nesmi vest z tagu na ten samy tag - vazby na sebe se resi jinak
    if (_fromTagId == _toTagId) {
      //print("Cyklicka vazba z tagu $_toTagId");
      return false;
    }
    // Nema cenu mit vazby s takto nizkou silou
    if (strength < 0.01 && strength > -0.01) {
      //print("Slaba vazba z tagu $_fromTagId na tag $_toTagId");
      return false;
    }
    // Potreba vyradit vazby, ktere vedou na neexistujici tagy
    fromTag = repo.getTag(_fromTagId);
    if (fromTag == null) {
      //print("Nelze nalezt source pro vazbu z tagu $_fromTagId na tag $_toTagId");
      return false;
    }
    toTag = repo.getTag(_toTagId);
    if (toTag == null) {
      //print("Nelze nalezt target pro vazbu z tagu $_fromTagId na tag $_toTagId");
      return false;
    }
    // Nelze vest vazbu na COMPARABLE a COMPOSITE
//    if (toTag.type == COMPOSITE || toTag.type == COMPARABLE) {
//      //print("Nelze vest vazbu z tagu $_fromTagId na COMPARABLE nebo COMPOSITE tag $_toTagId ");
//      return false;
//    }
    // Smazat odkazy na tagy v jine repozitori
    if (!repo.hasTag(_fromTagId)) {
      fromTag = null;
    }
    if (!repo.hasTag(_toTagId)) {
      toTag = null;
    }
    // Relation je v poradku
    if (fromTag != null) {
      fromTag.relations_source.add(this);
    }
    if (toTag != null) {
      toTag.relations_target.add(this);
    }
    return true;
  }
  bool deleteItself() {
    if (fromTag != null) {
      fromTag.relations_source.delete(this);
    }
    if (toTag != null) {
      toTag.relations_target.delete(this);
    }
    return true;
  }
  int compare(Relation other) {
    if (other == null) {
      return DIFFERENT;
    }
    if (_fromTagId != other._fromTagId) {
      return DIFFERENT;
    }
    if (_toTagId != other._toTagId) {
      return DIFFERENT;
    }
    if (strength != other.strength) {
      return SIMILAR;
    } else {
      return SAME;
    }
  }
  bool merge(List<Repo> repos) {
    List<Relation> relas = [];
    for (Repo repo in repos) {
      Relation rela = repo.getRelation(id);
      if (rela != null) {
        relas.add(rela);
      }
    }
    double sum = 0.0;
    for (Relation rela in relas) {
      sum += rela.strength;
    }
    strength = sum / relas.length;
    return true;
  }
}
