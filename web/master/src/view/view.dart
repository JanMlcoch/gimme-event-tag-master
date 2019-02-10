library tag_master_view;

import 'package:dart_ext/collection_ext.dart';
import "dart:html";
//import "dart:convert";
import 'package:tag_master/tag_master_common/library.dart';
import 'package:tag_master/ui.dart';
import '../model/model.dart';
//import '../view.dart';

part "widgets/login.dart";
part "widgets/platform.dart";
part "widgets/wait.dart";
part "widgets/accept_error.dart";
part "widgets/default_menu.dart";
part "widgets/welcome.dart";
part "widgets/overview.dart";
part "widgets/view_tag.dart";
part "widgets/edit_tag.dart";
part "widgets/add_tag.dart";
part "widgets/relation_table_row.dart";
part "widgets/filtered_overview.dart";
part "widgets/smart_select_tag.dart";
part "widgets/smart_option_list.dart";

Xr0lang_cz lang;

void setResourcesInView(val) {
  resources = val;
}
void setLangInView(val) {
  lang = val;
  setLangInModel(val);
}

GeneratedResources resources;

View view;

void setViewFromLoader(var loaderView){
  view = loaderView;
}

class View {
  Element root;
  PlatformWidget platformWidget;
  List<Widget> widgets = [];
  View(this.root) {
    init();
  }

  void init() {
    platformWidget = new PlatformWidget();
    platformWidget.target = root;
    widgets.add(platformWidget);

    repaint(null);
  }

  void repaint(_) {
    for (Widget w in widgets) {
      w.repaint();
    }
    window.requestAnimationFrame(repaint);
  }
}
