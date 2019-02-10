import "dart:convert";
import "dart:io";

void main() {
  print(Directory.current);
  String loadedString = new File("./bin/fill_db/tag_list.json").readAsStringSync();
  List<Map<String, dynamic>> json = JSON.decode(loadedString);

  int tagId = 0, parentId;
  List<Map<String, dynamic>> tags = [], relas = [], childs;
  Map<String, dynamic> child;
  for (Map<String, dynamic> parentTag in json) {
    tags.add({"id":tagId,"name":parentTag["name"],"type":2});
    tagId++;
    if (parentTag.containsKey("childs")) {
      parentId = tagId-1;
      childs = parentTag["childs"];
      for (child in childs) {
        tags.add({"id":tagId,"name":child["name"],"type":1});
        relas.add({"from":tagId,"to":parentId,"str":1});
        tagId++;
      }
    }
  }
  print(tags);
  print(relas);
  Map<String, dynamic> outJson = {"tags":tags,"relas":relas};
  String outString = JSON.encode(outJson);
  new File("./bin/fill_db/new_db.json").writeAsStringSync(outString);
}