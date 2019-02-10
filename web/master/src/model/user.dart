part of tag_master_model;

class ClientUser extends User{
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool val){
    _isLoggedIn = val;
    model.waitPlease = false;
  }


  void requestUserData(){
    model.gateway.sendGet(USER_API, {}).then((Object userJson) {
      try{
        fromJson(userJson);
        isLoggedIn=true;
      }catch (e){
        model.gateway.handleError(e);
      }

    }).catchError((e) {

    });
  }

  void submitCredentials(login, pass) {
    model.waitPlease = true;
    model.gateway.sendPost(LOGIN_API, {"login": login, "password": pass}).then((Object loggedJson) {
      model.user.requestUserData();
    })
    .catchError((e) {
      model.gateway.handleError(e);
    });
  }

  Future logout() {
    return model.gateway.sendDelete(LOGIN_API, {});
  }
}