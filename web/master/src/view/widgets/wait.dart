part of tag_master_view;

class WaitWidget extends Widget{
  String get name=>"Wait";
  WaitWidget(){
    template = parse(resources.templates.wait);
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    return lang.wait.toJson();
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    // do nothing
  }
}