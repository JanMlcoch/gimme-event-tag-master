part of tag_master_view;

class LoginWidget extends Widget {
  Element submitButton;
  InputElement loginElement;
  InputElement password;
  String get name=>"Login";


  LoginWidget() {
    template = parse(resources.templates.login);
  }


  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = lang.login.toJson();
    out["errorSS"] = true;
//    print(out);
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void tideFunctionality() {
    void submit(_){
      if(loginElement.value.length==0)return;
      if(password.value.length==0)return;
      model.user.submitCredentials(loginElement.value, password.value);
    }

    void onEnter (KeyboardEvent e){
      if(e.keyCode == KeyCode.ENTER){
        submit(null);
      }
    }

    password = target.querySelector(".password");
    submitButton = target.querySelector(".submitCredentials");
    loginElement = target.querySelector(".login");
    submitButton.onClick.listen(submit);
    loginElement.onKeyDown.listen(onEnter);
    password.onKeyDown.listen(onEnter);

  }
}