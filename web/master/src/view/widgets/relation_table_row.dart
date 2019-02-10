part of tag_master_view;

class RelationTableRowWidget extends Widget {
  Map json;
  int count;
  DivElement smartContainer;

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

    smartContainer = target.querySelectorAll(".smartContainer").first;
    children.first.target = smartContainer;
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

    children.clear();
    Filters filters = this.getFilters();
    int targetId;
    if(json["from"]){
      targetId = json["toId"];
    }
    else{
      targetId = json["fromId"];
    }
    children.add(new SSTagWidget(new SSTagState(targetId,"",json["isAppropriateSSTagActive"],count,json["toRemove"],isNew:false),this,filters,count,json["toRemove"]));
//    children.add(new SSTagWidget(new SSTagState(-1,"",false,count,false,isNew:true),this,filters,count,false));

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

  Filters getFilters(){

    List<Filter> filterList = [];
    bool from = json["from"];
    if(from){
      for(int i = 1;i<6;i++){
        if(!ClientTag.isAllowedTypes(model.tagToView.type,i)){
          filterList.add(new NotTypFilter(i));
        }
      }
      model.tagToView.relations.forEach((_,rel){
        if(rel.from){
          filterList.add(new NotIdFilter(rel.fromId));
        }
      });
    }
    else{
      for(int i = 1;i<6;i++){
        if(!ClientTag.isAllowedTypes(i,model.tagToView.type)){
          filterList.add(new NotTypFilter(i));
        }
      }
      model.tagToView.relations.forEach((_,rel){
        if(rel.to){
          filterList.add(new NotIdFilter(rel.toId));
        }
      });
    }
    Filters filters = new Filters(filterList);
    return filters;
  }
}