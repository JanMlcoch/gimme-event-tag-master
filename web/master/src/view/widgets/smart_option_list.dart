part of tag_master_view;

class SmartOptionListWidget extends Widget {
  Map json;
  dynamic parent;

  String get name => "SmartOptionList";

  SmartOptionListWidget(Map incomingJson, dynamic parentx) {
    template = parse(resources.templates.smart_option_list);
    parent = parentx;
    json = incomingJson;
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    return merge({"lang":lang.SmartOptionList.toJson()}, json);
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    //TODO: onclicks and onhovers
  }
}
