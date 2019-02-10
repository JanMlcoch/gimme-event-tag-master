part of tag_master_view;

class FilteredOverviewWidget extends Widget {
  var tagL;
  OverviewTags tags;
  List<Filter> filters;
  ButtonInputElement submit;
  TextInputElement substring;
  List<CheckboxInputElement> type;

  String get name => "FilteredOverview";

  FilteredOverviewWidget() {
    template = parse(resources.templates.filtered_overview);
    tags = model.overviewTags;
    filters = model.activeFilterList;
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
    out["lang"] = merge(lang.overview.toJson(), lang.filters.toJson());
    out["tags"] = (new QueryTags(tags, filters)).toJson();
    if (model.formState == null) {
      out["form"] = {"substring":"", "type1":true, "type2":true, "type3":true, "type4":true, "type5":true};
    } else {
      out["form"] = model.formState;
    }
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    submit = target.querySelector("#submit");
    substring = target.querySelector("#substring");
    type = [new CheckboxInputElement(),target.querySelector("#isType1"), target.querySelector("#isType2"), target.querySelector("#isType3"), target.querySelector("#isType4"), target.querySelector("#isType5")];

    submit.onClick.listen((_) {
      model.formState = {"substring":substring.value, "type1":type[1].checked, "type2":type[2].checked, "type3":type[3].checked, "type4":type[4].checked, "type5":type[5].checked};
      model.activeFilterList.clear();
      model.activeFilterList.add(new SubstringFilter(substring.value));
      if(!type[1].checked){model.activeFilterList.add(new NotTypFilter(1));}
      if(!type[2].checked){model.activeFilterList.add(new NotTypFilter(2));}
      if(!type[3].checked){model.activeFilterList.add(new NotTypFilter(3));}
      if(!type[4].checked){model.activeFilterList.add(new NotTypFilter(4));}
      if(!type[5].checked){model.activeFilterList.add(new NotTypFilter(5));}
      repaintRequested = true;
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