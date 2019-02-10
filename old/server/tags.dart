part of tag_master.server;

class TagDep {
  Map<String,Tag> _dep = new Map<String, Tag>();
  
  Tag operator [](String tagname){
    if(tagname==null){return null;}
    return _dep[tagname];
  }
  void addTag(Tag tag){
    _dep[tag.name]=tag;
  }
  bool removeTag(Tag tag){
    return null!=_dep.remove(tag.name);
  }
  bool moveTag(Tag tag,Tag target){
    if(tag.parent==null){
      _dep.remove(tag.name);
    }else{
      tag.parent._dep.removeTag(tag);
    }
    if(target==null){
      addTag(tag);
      tag._parent=null;
      return true;
    }else{
      return target.addChild(tag);
      
    }
  }
  bool add(String tag) {
    if (_dep.containsKey(tag)) {
      _dep[tag].add();
      return false;
    } else {
      _dep[tag] = new Tag(tag);
      return true;
    }
  }
  bool subtract(String tag) {
    if (_dep.containsKey(tag)) {
      if(_dep[tag].subtract()){
        _dep.remove(tag);
      }
      return true;
    } else {
      return false;
    }
  }
  List printout() {
    List<Map> out=[];
    for(Tag tag in _dep.values){
      out.add(tag.printout());
    }
    return out;
  }
}

class Tag{
  String name="";
  bool supertag=false;
  int likes=1;
  Tag _parent=null;
  TagDep _dep=null;
  //bool hidden=false;
  
  
  Tag(String nam){
    name=capitalize(nam);
  }
  String capitalize(String str) {
    return str[0].toUpperCase() + str.substring(1).toLowerCase();
  }
  bool add([int count=1]){
    likes+=count;
    return true;
  }
  bool subtract([int count=1]){
    if(count>=likes){
      return true;
    }else{
      likes-=count;
      return false;
    }
  }
  bool setParent(Tag tag){
    if(tag.supertag&&!supertag){
      _parent=tag;
      return true;
    }
    return false;
  }
  bool addChild(Tag tag){
    if(!supertag){return false;}
    if(tag.supertag){return false;}
    if(_dep==null){_dep=new TagDep();}
    _dep.addTag(tag);
    tag.setParent(this);
    return true;
  }
  Tag get parent{
    return _parent;
  }
  Map<String,dynamic> printout(){
    Map<String,dynamic> out={};
    out["name"]=name;
    out["likes"]=likes;
    out["super"]=supertag;
    //out["parent"]=_parent.name;
    if(_dep!=null){
      out["childs"]=_dep.printout();
    }
    return out;
  }
  void fromJson(Map<String,dynamic> jtag){
    name=capitalize(jtag["name"]);
    likes=jtag["likes"];
    supertag=jtag["super"];
    if(!jtag.containsKey("childs")){return;}
    if(jtag["childs"] is !List){return;}
    List<Map> childs=jtag["childs"];
    if(childs.length>0){
      _dep=new TagDep();
      for(Map jchild in childs){
        Tag child=new Tag(jchild["name"]);
        child.fromJson(jchild);
        child._parent=this;
        _dep.addTag(child);
      }
    }
  }
  bool hasChilds(){return _dep!=null&&!_dep._dep.isEmpty;}
  
  
}