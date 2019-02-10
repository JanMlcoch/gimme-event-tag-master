part of tag_master_view;

class WelcomeWidget extends Widget {
  String get name=>"Welcome";


  WelcomeWidget() {
    template = parse(resources.templates.welcome);
  }


  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = lang.welcome.toJson();
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    //do nothing
  }
}