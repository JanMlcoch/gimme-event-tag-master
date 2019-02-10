part of tag_master_view;

class AcceptErrorWidget extends Widget {
  String get name=>"AcceptError";
  InputElement acceptError;

  AcceptErrorWidget() {
    template = parse(resources.templates.accept_error);
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out;
    out = lang.acceptError.toJson();
    out["errorMsg"] = model.currentErrorMessage;
    return out;

  }

  @override
  void setChildrenTargets() {
    //childless
  }

  @override
  void tideFunctionality() {
    acceptError = target.querySelector("#acceptError");
    acceptError.onClick.listen((MouseEvent e) {
      model.currentErrorMessage = "";
    });
  }
}