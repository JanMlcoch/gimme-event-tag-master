part of tag_master_view;

class EditTagWidget extends Widget {
  String get name => "EditTag";

  Map mustacheJson;
  List options = [];
  TableElement fromTable;
  TableElement toTable;
  InputElement addFrom;
  InputElement addTo;
  InputElement submit;

  InputElement toEditTag;

  EditTagWidget(/*this.tag*/) {
    model.tagToView.onTagChanged.add(() {
      repaintRequested = true;
    });
    template = parse(resources.templates.edit_tag, lenient:true);
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = {};
    mustacheJson = model.tagToView.toMustacheJson();
    out = mustacheJson;
    out["lang"] = lang.editTag.toJson();
//    print(out);
    return out;
  }

  @override
  void setChildrenTargets() {
    children.forEach((RelationTableRowWidget child) {
      child.target = target.querySelector("#tr" + child.count.toString());
    });
  }

  @override
  void tideFunctionality() {
    addTo = target.querySelector("#addRelationTo");
    addFrom = target.querySelector("#addRelationFrom");
    toTable = target.querySelector("#relTableTo");
    fromTable = target.querySelector("#relTableFrom");
    submit = target.querySelector(".submitTag");

    addTo.onClick.listen((e) {
      saveFormStateToTagToView();
      model.tagToView.addNewRelation("to");
      repaintRequested = true;
    });
    addFrom.onClick.listen((e) {
      saveFormStateToTagToView();
      model.tagToView.addNewRelation("from");
      repaintRequested = true;
    });

    for (Map rel in mustacheJson["relas"]) {
      children.add(new RelationTableRowWidget(rel, this));
    }

    submit.onClick.listen((e) {
      saveFormStateToTagToView();
      ClientTag.submitChangesToTagToView();
      model.waitPlease = true;
      view.platformWidget.setMenuPath(PlatformWidget.PATH_OVERVIEW);
    });
    for (int i = 1;i < 6;i++) {
      (target.querySelector("#changeType" + i.toString()) as ButtonInputElement).onClick.listen((_) {
        model.tagToView.type = i;
        repaintRequested = true;
      });
    }
  }


  void saveFormStateToTagToView() {
//    model.tagToView.relations.clear();
    List<int> checkedRelasList = [];
    ElementList trs = target.querySelectorAll(".relFromTableRow");
    trs.forEach((Element ee) {
      int count = int.parse(ee.id.replaceFirst("tr", ""));
      int currentRelationKey = model.tagToView.getRelationKeyByCount(count);

      int idToTag = int.parse((ee.querySelectorAll(".targetTagId").first as TextInputElement).value);
      double strength = double.parse((ee.querySelectorAll(".strInput").first as InputElement).value);
//      model.tagToView.relations[currentRelationKey] = new ClientRelation();
      model.tagToView.relations[currentRelationKey].strength = strength;
      model.tagToView.relations[currentRelationKey].toId = idToTag;
      checkedRelasList.add(currentRelationKey);
    });
    ElementList trss = target.querySelectorAll(".relToTableRow");
    trss.forEach((Element ee) {
      int count = int.parse(ee.id.replaceFirst("tr", ""));
      int currentRelationKey = model.tagToView.getRelationKeyByCount(count);

      int idFromTag = int.parse((ee.querySelectorAll(".targetTagId").first as TextInputElement).value);
      double strength = double.parse((ee.querySelectorAll(".strInput").first as InputElement).value);
//      model.tagToView.relations[currentRelationKey] = new ClientRelation();
      model.tagToView.relations[currentRelationKey].strength = strength;
      model.tagToView.relations[currentRelationKey].fromId = idFromTag;
      checkedRelasList.add(currentRelationKey);
    });
    List keysToRemove = [];
    //zbaví se parazitních relací
    model.tagToView.relations.forEach((key, rel) {
      if (!checkedRelasList.contains(key)) {
        keysToRemove.add(key);
      }
    });
    for (dynamic key in keysToRemove) {
      model.tagToView.relations.remove(key);
    }

    InputElement nameNameName = target.querySelector("#inputTagName");
    model.tagToView.name = nameNameName.value;

//    ClientTag.submitChangesToTagToView();
  }
}

