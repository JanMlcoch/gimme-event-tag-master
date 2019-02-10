part of tag_master_model;

class SSTagState {
  SSTagState(this.chosenTagId, this.inputText, this.isActive, this.count, this.isDisabled, {bool this.isNew: false});

  bool isDisabled;
  int count;
  int chosenTagId;
  bool isNew;
  String inputText;
  bool isActive;

  Map toMustacheJson(Filters filters) {
    Map out = {};
    out["inputId"] = "smartInput" + count.toString();
    out["listId"] = "smartList" + count.toString();
    out["options"] = [];
    out["disabled"] = isDisabled;
//    if (isNew) {
//      List<SimpleTag> potencialOpts = filters.filtrate(model.overviewTags).tags;
//      if (potencialOpts.length == 0) {
//        //TODO: exception
//      }
//      else {
//        chosenTagId = potencialOpts.first.id;
//        isNew = false;
//      }
//    }
    out["chosenTagId"] = chosenTagId.toString();
    if (!isActive) {
      print(chosenTagId);
      out["inputValue"] = model.overviewTags.getTagById(chosenTagId).name;
    } else {
      out["inputValue"] = inputText;
      List<SimpleTag> potencialOpts = filters.filtrate(model.overviewTags).tags;
      for (int i = 0;i < min(model.numberOfShowedSmartOptions,potencialOpts.length);i++) {
        (out["options"] as List).add({"id":"smartOpt" + potencialOpts[i].id.toString(), "label":potencialOpts[i].name+" ("+ClientTag.tagTypeTextStatic(potencialOpts[i].type)+")"});
      }
    }
//    print(inputText);
    return out;
  }
}
