library tag_master.compiler;
import "dart:io";
import "dart:async";
import "dart:convert";

part "tags.dart";
part "validation.dart";

void main(){
  readRawFile().then(execute);
}

Future<List> readRawFile(){
  Completer<List> completer=new Completer<List>();
  List<Tag> tags=[];
  Map<int,Tag> tagMap={};
  new File("./data/repo2_new.json").readAsString().then((String jsonString){
    Map<String,dynamic> json=JSON.decode(jsonString);
    List<Map> jTags=json["tags"];
    for(Map<String,dynamic> jTag in jTags){
      Tag tag=new Tag(jTag);
      tags.add(tag);
      tagMap[tag.id]=tag;
    }
    List<Map> jRelations=json["relas"];
    for(Map<String,dynamic> rela in jRelations){
      Tag source=tagMap[rela["from"]];
      if(source==null){continue;}
      source.relations[rela["to"]]=rela["str"];
    }
    completer.complete(tags);
  });

  return completer.future;
}

void execute(List tags){
  List<Map> out=[];
  tags = validate(tags);
  for(Tag tag in tags){
    out.add(tag.toJson());
  }
//  print(out);
  new File("./data/compiled_new.json").writeAsString(JSON.encode(out));
}