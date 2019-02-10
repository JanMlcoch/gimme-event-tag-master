part of tag_master.compiler;

class Tag {
  int id;
  String name;
  int type;
  Map<int,double> relations={};

  Tag(Map<String,dynamic> json){
    id=json["id"];
    name=json["name"];
    type=json["type"];
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> out={"id":id,"name":name,"type":type};
    Map<String,double> relas={};
    relations.forEach((int key,double value){
      relas[key.toString()]=value;
    });
    out["relas"]=relas;
    return out;
  }
}