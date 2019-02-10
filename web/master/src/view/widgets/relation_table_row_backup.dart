part of tag_master_view;

class RelationTableRowWidget extends Widget {
  Map json;
  int count;

  String get name=>"RelationTableRow";
  dynamic parent;

  RelationTableRowWidget(Map incomingJson,dynamic parentx) {
    template = parse(resources.templates.relation_table_row1);
    json = incomingJson;
    count = json["count"];
    parent=parentx;
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    return merge({"lang":lang.relationTableRow.toJson()},json);
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    ElementList removeButtons = target.querySelectorAll(".remove");
    removeButtons.forEach((Element e) {
      e.onClick.listen((Event ee) {
        _bindRemove(e);
      });
    });
    ElementList restoreButtons = target.querySelectorAll(".restore");
    restoreButtons.forEach((Element e) {
      e.onClick.listen((Event ee) {
        _bindRestore(e);
      });
    });
    ElementList selects = target.querySelectorAll(".selectTag");
    selects.forEach((SelectElement select) {
      select.onChange.listen((_) {
        EditTagWidget parentEdit = (parent as EditTagWidget);
        parentEdit.saveFormStateToTagToView();
        parentEdit.repaintRequested = true;
        print("fuck you");
      });
    });
  }

  void _bindRemove(Element e) {

    String countString = e.id.replaceFirst("remove", "");
//print(model.tagToView.toJsonPrint());
    int currentRelationKey = model.tagToView.getRelationKeyByCount(int.parse(countString));
    model.tagToView.relations[currentRelationKey].disabledToBeRemoved = true;
    model.tagToView.relations[currentRelationKey].notDisabledToBeRemoved = false;
    EditTagWidget parentEdit = (parent as EditTagWidget);
    parentEdit.saveFormStateToTagToView();
    parentEdit.repaintRequested = true;
  }

  void _bindRestore(Element e) {
    String countString = e.id.replaceFirst("restore", "");
    int currentRelationKey = model.tagToView.getRelationKeyByCount(int.parse(countString));
    model.tagToView.relations[currentRelationKey].disabledToBeRemoved = false;
    model.tagToView.relations[currentRelationKey].notDisabledToBeRemoved = true;
    EditTagWidget parentEdit = (parent as EditTagWidget);
    parentEdit.saveFormStateToTagToView();
    parentEdit.repaintRequested = true;
  }
}