part of tag_master.server;

loadUserMaster(Users users) {
  route(LOGIN_API, loginHandler, dataItems: ["login", "password"], method: "POST");
  route(LOGIN_API, loginHandler, logged: true, method: "GET");
  route(LOGIN_API, loginHandler, logged: true, method: "DELETE");
  route(USER_API, routeHandler(userGet), method: "GET", logged: true);
  route(USER_API, routeHandler(userPost), method: "PUT", logged: true);
  route(USER_API, routeHandler(userPost),
      method: "POST", logged: true, dataItems: ["login", "pass", "name"]);
}

Map userGet(RequestContext context) {
  User user = context.logged;
  Map<String, dynamic> json = user.toJson();
  json.remove("pass");
  return json;
}
Map userPost(RequestContext context) {
  User logged = context.logged;
  User user = logged;
  if (context.data is! Map) {
    return resOut("Expecting Map, not a " + context.data.toString(), false);
  }
  Map<String, dynamic> json = context.data;
  if (json.containsKey("repo")) {
    return resOut("Its forbidden to change tags through this API", false);
  }
  if (json.containsKey("user")) {
    if (json["user"] is! int) {
      return resOut("Used ID is not integer", false);
    }
    user = users[json["user"]];
    if (user != logged && !logged.checkPermission(MANAGE_USERS)) {
      return resOut("Logged user cannot modify other users", false);
    }
  }
  return updateUser(json, methodToCommand(context.method), user, logged);
}
Map updateUser(
    Map<String, dynamic> json, String command, User user, User logged) {
  if (command == "create") {
    String login = json["login"];
    for (User otherUser in users.values) {
      if (otherUser.login == login) {
        return resOut("Selected login have already been used", false);
      }
    }
    json.remove("id");
    User nUser = new User.create(json);
    users.add(nUser);
    return resOut("New user succesfully created", true);
  } else if (command == "update") {
    if (user == null) {
      return resOut("Updated user does not exists", false);
    }
    if (json.containsKey("login") && json["login"] != user.login) {
      return resOut("Cannot change login - it is forbidden", false);
    }
    if (json.containsKey("pass")) {
      return resOut(
          "Selected password is too weak, new STRONG password \"aaa\" have be randomly generated for you",
          false);
    }
    json["id"] = user.id;
    user.fromJson(json);
    return resOut("User updated successfully", true);
  } else if (command == "delete") {
    bool res = users.delete(user);
    return resOut(
        res ? "User successfully deleted" : "User could not be deleted", res);
  }
  return resOut("Unknown command $command", false);
}

void loginHandler(RequestContext context) {
  Map<String, dynamic> data = context.data;
  if (context.method == "GET") {
    context.write(resOut("User is successfully logged", true));
    context.close();
    return;
  }
  if (context.method == "DELETE") {
    saveToSession(context, "loggedUser", null);
    context.write(resOut("Logout successful", true));
    context.close();
    return;
  }
  String login = data["login"];
  String pass = data["password"];
  for (User user in users.values) {
    if (login == user.login) {
      //print("User "+login+" found");
      if (user.checkPassword(pass)) {
        saveToSession(context, "loggedUser", user.id);
        context.write(resOut("Login successful", true));
        context.close();
        return;
      } else {
        break;
      }
    }
  }
  context.write(resOut("Login failed", false));
  context.close();
}
