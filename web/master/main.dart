library tag_master;

import "dart:html";
import "dart:convert";
import 'package:tag_master/tag_master_common/library.dart';
import "src/view/view.dart";


GeneratedResources resources;
Xr0lang_cz lang;
View view;


void main() {

  HttpRequest.getString("../resources/module.json").then((String jsonString){
    resources = new GeneratedResources();
    resources.fromJson(JSON.decode(jsonString));
    lang = resources.lang_cz;
    setLangInView(lang);
    setResourcesInView(resources);
    view = new View(querySelector("#content"));
    setViewFromLoader(view);
  });
}
