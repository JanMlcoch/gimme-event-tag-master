part of tag_master_view;

class ViewTagWidget extends Widget {
  String get name=>"ViewTag";
  List relasFrom = [];
  List relasTo = [];
  ClientTag tagToView;
  InputElement toEditTag;

  ViewTagWidget() {
    model.tagToView.onTagChanged.add((){
      repaintRequested = true;
    });
    template = parse(resources.templates.view_tag);
  }


  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = {};
    out = model.tagToView.toMustacheJson();
    out["lang"] = lang.viewTag.toJson();
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    toEditTag = target.querySelector("#edittag");
    toEditTag.onClick.listen((MouseEvent e){
      //při volání z jiného místa je třeba setClientTagId
      view.platformWidget.setMenuPath(PlatformWidget.PATH_EDIT_TAG);
    });
  }
}