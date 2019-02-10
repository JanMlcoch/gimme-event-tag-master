part of tag_master_common;

class User extends Entity {
  String login;
  String name;
  String _password;
  final Set<int> _permissions = new Set<int>()
    ..addAll([MANAGE_OWN_REPO, SEE_REPO]);
  final Repo repository = new Repo();
  User() {
    //id=_lastId++;
  }
  User.create(Map<String, dynamic> json) : super.create(json) {
    fromJson(json);
  }
  void fromJson(Map<String, dynamic> userData) {
    super.fromJson(userData);
    if (userData.containsKey("name")) {
      name = userData["name"];
    }
    if (userData.containsKey("login")) {
      login = userData["login"];
    }
    if (userData.containsKey("password")) {
      _password = userData["password"];
    }
    if (userData.containsKey("repository")) {
      repository.fromJson(userData["repository"]);
    }
    if (userData.containsKey("permissions")) {
      _permissions
        ..clear()
        ..addAll(userData["permissions"]);
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = super.toJson();
    out["repository"] = repository.toJson();
    out["name"] = name;
    out["login"] = login;
    out["password"] = _password;
    out["permissions"] = _permissions.toList(growable: false);
    return out;
  }
  checkPassword(String pass) {
    return _password == pass;
  }
  checkPermission(int permission) {
    /*bool res=_permissions.contains(permission);
    print(login+(res?"":" don't")+" have permission "+permission.toString());
    return res;*/
    return _permissions.contains(permission);
  }
}
