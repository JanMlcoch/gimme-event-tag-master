part of tag_master_view;

class SSTagWidget extends Widget {
  Map json;
  int count;
  Filters filters;
  SSTagState ssTagState;
  TextInputElement smartInput;
  bool isDisabled;
  bool dontBlur = true;
  int selectionStart = 0;
  int selectionEnd = 0;

  String get name => "SSTag";

  dynamic parent;

  SSTagWidget(SSTagState ssTagStatex, dynamic parentx, Filters filtersx, int countx, bool isDisabledx) {
    template = parse(resources.templates.smart_select_tag);
    isDisabled = isDisabledx;
    parent = parentx;
    filters = filtersx;
    filters.filters.add(new SubstringFilter(""));
    count = countx;
    ssTagState = ssTagStatex;
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    ssTagState.count = count;
    ssTagState.isDisabled = isDisabled;
    filters.filters[filters.filters.length - 1] = (new SubstringFilter(ssTagState.inputText));
    json = ssTagState.toMustacheJson(filters);
    return merge({"lang":lang.SSTag.toJson()}, json);
  }

  @override
  void setChildrenTargets() {
//    if(ssTagState.isActive){
//      DivElement smartList = querySelectorAll(".smartList").first;
//      children.first.target = smartList;
//    }
  }

  @override
  void tideFunctionality() {
    smartInput = target.querySelectorAll(".smartInput").first;


    if (ssTagState.isActive) {
//      children.clear();
//      children.add(new SmartOptionListWidget(json,this));
      smartInput.focus();
      smartInput.setSelectionRange(selectionStart, selectionEnd);
      dontBlur = false;
//      print("created focus");
    }
    smartInput.onFocus.listen((_) {
      ssTagState.isActive = true;
      ssTagState.inputText = "";
      dontBlur = true;
      repaintRequested = true;
//      print("focused");
    });
    smartInput.onBlur.listen((_) {
      if (!dontBlur) {
        if(ssTagState.chosenTagId==null){
          onChooseTag(target.querySelectorAll(".smartOpt").first);
        }
        ssTagState.isActive = false;
        repaintRequested = true;
      }
    });
    smartInput.onInput.listen((_) {
      ssTagState.inputText = smartInput.value;
      dontBlur = true;
      selectionStart = smartInput.selectionStart;
      selectionEnd = smartInput.selectionEnd;
      /*filters.filters[filters.filters.length-1] = (new SubstringFilter(ssTagState.inputText));
      children.clear();
      children.add(new SmartOptionListWidget(json,this));
      setChildrenTargets();
      children.first.*/
      repaintRequested = true;
    });
    target.querySelectorAll(".smartOpt").forEach((Element e) {
      e.onMouseOver.listen((_) {
        e.classes.toggle("hoverSmartOpt");
      });
      e.onMouseOut.listen((_) {
        e.classes.toggle("hoverSmartOpt");
      });
      e.onMouseDown.listen((_) {
        onChooseTag(e);
      });
    });
  }

  void onChooseTag(Element e){
        int id = int.parse(e.id.replaceFirst("smartOpt",""));
        ssTagState.chosenTagId = id;
        ssTagState.isActive = false;
        repaintRequested = true;

  }
}


