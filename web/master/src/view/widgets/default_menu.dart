part of tag_master_view;

class DefaultMenuWidget extends Widget {
  InputElement logout;
  InputElement toOverview;
  InputElement toHome;
  InputElement back;
  InputElement logAsAnotherUser;
  InputElement add;
  InputElement exportJson;

  String get name => "DefaultMenu";
  DefaultMenuWidget() {
    template = parse(resources.templates.default_menu_tetrised);
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.defaultMenu.toJson();
    out["cannotGoBack"] = !model.canGoBack;
    if (model.user == null) {
      out["user"] = {"name": ""};
    } else {
      out["user"] = model.user.toJson();
    }
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    logout = target.querySelector(".logout");
    toOverview = target.querySelector("#toOverview");
    toHome = target.querySelector("#toHome");
    back = target.querySelector("#backButton");
    add = target.querySelector("#addTag");
    exportJson = target.querySelector("#exportJson");

    logout.onClick.listen((MouseEvent e) {
      model.waitPlease = true;
      model.user.logout().then((e) {
        window.location.reload();
      });
    });

    toOverview.onClick.listen((MouseEvent e) {
      view.platformWidget.setMenuPath(PlatformWidget.PATH_OVERVIEW);
    });
    toHome.onClick.listen((MouseEvent e) {
      view.platformWidget.setMenuPath(PlatformWidget.PATH_HOME);
    });
    back.onClick.listen((MouseEvent e) {
      view.platformWidget.setMenuPath(PlatformWidget.PATH_BACK);
    });
    add.onClick.listen((MouseEvent e) {
      view.platformWidget.setMenuPath(PlatformWidget.PATH_ADD_TAG);
    });
    exportJson.onClick.listen((MouseEvent e){

    });
  }
}
