part of tag_master_view;

class OverviewWidget extends Widget {
  var tagL;
  OverviewTags tags;
  ButtonInputElement filters;

  String get name => "Overview";

  OverviewWidget() {
//    print("overview generated");
    template = parse(resources.templates.overview);
    tags = model.overviewTags;
    tags.onTagsChanged.add(() {
      repaintRequested = true;
    });
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.overview.toJson();
    out["tags"] = tags.toJson();
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    filters = target.querySelector("#addFilters");
    filters.onClick.listen((_) {
      view.platformWidget.setMenuPath(PlatformWidget.PATH_FILTER_TAGS);
    });


    ElementList buttonsToViewTag = target.querySelectorAll(".buttonToEditTag");
    buttonsToViewTag.forEach((Element e) {
      e.onClick.listen((ee) {
        model.waitPlease = true;
        model.setClientTagId(int.parse(e.id.replaceAll("viewtag", "")));
        view.platformWidget.setMenuPath(PlatformWidget.PATH_VIEW_TAG);
      });
    });
  }
}