part of tag_master_view;

class PlatformWidget extends Widget {
  static const String PATH_HOME = "home";
  static const String PATH_OVERVIEW = "overview";
  static const String PATH_EDIT_TAG = "editTag";
  static const String PATH_ADD_TAG = "addTag";
  static const String PATH_BACK = "back";
  static const String PATH_VIEW_TAG = "viewTag";
  static const String PATH_FILTER_TAGS = "FilterOverview";

  DefaultMenuWidget menuWidget;
  AcceptErrorWidget errorWidget;
  Widget contentWidget;
  LoginWidget loginWidget;
  WaitWidget waitWidget;

  Element login;
  Element subContent;
  Element defaultMenu;
  Element errorInLoginState;

  String get name => "Platform";

  bool get stateLogin => !(model.user.isLoggedIn);

  bool get stateWait => model.waitPlease;

  String get error => model.currentErrorMessage;

  bool get occurredError => !(this.error == "");

  bool repaintRequestedForPaintError = false;
  bool repaintRequestedForDelayedData = false;

  bool get canGoBack => model.canGoBack;

  bool get cannotGoBack => !canGoBack;

  Object get downloadedUser => model.user;

  bool doesntNeedData = false;

  String _lastMenuPath = PATH_HOME;
  String _menuPath = PATH_HOME;

  PlatformWidget() {
    template = parse(resources.templates.platform);

    menuWidget = new DefaultMenuWidget();
    errorWidget = new AcceptErrorWidget();
    loginWidget = new LoginWidget();
    waitWidget = new WaitWidget();

    model.onChange = changed;
  }

  void changed() {
    if (!repaintRequestedForPaintError) {
      repaintRequestedForPaintError = false;
      repaintRequested = true;
    }
  }

  @override
  void destroy() {
    model.onChange = () {};
  }

  @override
  Map out() {
    return {
      "login": stateLogin,
      "logged": !stateLogin,
      "errorSS": occurredError ? error : false,
      "cannotGoBack": cannotGoBack,
      "downloadedUser": downloadedUser
    };
  }

  @override
  void setChildrenTargets() {
    if (stateWait) {
      waitWidget.target = subContent;
    } else {
      if (stateLogin) {
        loginWidget.target = login;
        if (occurredError) {
          errorWidget.target = errorInLoginState;
        }
      } else {

          menuWidget.target = defaultMenu;
          if (!occurredError) {
            contentWidget.target = subContent;
          }else{
            errorWidget.target = subContent;
          }

      }
    }
  }

  @override
  void tideFunctionality() {
    subContent = target.querySelector("#subContent");
    login = target.querySelector("#login");
    errorInLoginState = target.querySelector("#errorInLogin");
    defaultMenu = target.querySelector("#defaultMenu");

    int stateCount = 0;
    if (stateWait) {
      children = [waitWidget];
      stateCount++;
    } else {
      if (stateLogin) {
        implementLoginState(occurredError);
        stateCount++;
      }
      if (!(stateLogin || stateWait)) {
        implementContent(occurredError);
      }
    }
    if (stateCount > 1) {
      children.clear();
      repaintRequestedForPaintError = true;
      model.gateway.handleError(lang.moreStatesError);
    }
  }

  void implementLoginState(bool isInError) {
    children = [loginWidget];
    if (isInError) {
      children.add(errorWidget);
    }
  }

  void implementContent(isError) {
    children = [menuWidget];
    if (isError) {
      children.add(errorWidget);
    } else {
      implementInnerContent();
    }
  }

  void implementInnerContent({int viewedTag: 0}) {
    switch (_menuPath) {
      case PATH_ADD_TAG:
        contentWidget = new AddTagWidget();
        break;
      case PATH_HOME:
        doesntNeedData = true;
        contentWidget = new WelcomeWidget();
        break;
      case PATH_OVERVIEW:
        contentWidget = new OverviewWidget();
        break;
      case PATH_VIEW_TAG:
        contentWidget = new ViewTagWidget();
        break;
      case PATH_EDIT_TAG:
        contentWidget = new EditTagWidget(/*model.tagToView*/);
        break;
      case PATH_ADD_TAG:
        //do nothing so far
        break;
      case PATH_FILTER_TAGS:
        contentWidget = new FilteredOverviewWidget();
        break;
    }

    children.add(contentWidget);
  }

  void setMenuPath(String path) {
    if (path == PATH_BACK) {
      _menuPath = _lastMenuPath;
      model.canGoBack = false;
    } else {
      _lastMenuPath = _menuPath.toString();
      _menuPath = path;
      model.canGoBack = true;
    }
    model.clearTempData();
    repaintRequested = true;
  }
}
