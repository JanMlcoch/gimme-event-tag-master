part of tag_master.server;

void loadTagMaster(Repo repo, Users users) {
  route(TAGS_API, routeHandler(tagsGet),
      method: "GET", logged: true, dataItems: ["extend"]);
  route(TAGS_API, routeHandler(tagsPost), method: "PUT", logged: true);
  route(TAGS_API, routeHandler(tagsPost), method: "POST", logged: true);
  route(TAGS_API, routeHandler(tagsPost), method: "DELETE", logged: true);
  route(REL_TAGS_API, routeHandler(relTagsPost), method: "POST", logged: true);
  route(REL_TAGS_API, routeHandler(relTagsPost), method: "PUT", logged: true);
  route(REL_TAGS_API, routeHandler(relTagsPost), method: "DELETE", logged: true);
  route(TAG_API, routeHandler(tagGet),
      method: "GET", logged: true, dataItems: ["id"]);
  route(TAG_API, routeHandler(tagPost),
      method: "PUT", logged: true, dataItems: ["id"]);
  route(TAG_API, routeHandler(tagPost),
      method: "POST", logged: true, dataItems: ["name", "type"]);
  route(TAG_API, routeHandler(tagPost),
      method: "DELETE", logged: true, dataItems: ["id"]);
  route(RELATION_API, routeHandler(relaGet),
      method: "GET", logged: true, dataItems: ["id"]);
  route(RELATION_API, routeHandler(relaPost),
      method: "PUT", logged: true, dataItems: ["id"]);
  route(RELATION_API, routeHandler(relaPost),
      method: "POST", logged: true, dataItems: ["from", "to", "str"]);
  route(RELATION_API, routeHandler(relaPost),
      method: "DELETE", logged: true, dataItems: ["id"]);
}
Map<String, dynamic> tagsGet(RequestContext context) {
  Map<String, dynamic> data = context.data;
  if (data["extend"] == "overview") {
    //return users.overview(repo);  // no USER BRANCHES
    return repo.overview();
  }
  User logged = context.logged;
  if (logged == null) {
    return resOut("User have to be logged", false);
  }
  if (!logged.checkPermission(SEE_REPO)) {
    return resOut("Logged user cannot see tags", false);
  }
  if (data["extend"] == "full") {
    Map fullMap = {};
    fullMap /*["repo"]*/ = repo.toJson(); // no USER BRANCHES
    /*for (User user in users.values) {
      fullMap[user.login] = user.repo.toJson(); // no USER BRANCHES
    }*/
    return fullMap;
  }
  /*if (data["extend"] == "query") {
      context.write(tags.toJson());
      context.close();
      return;
    }*/
  return resOut("Unknown extend value", false);
}

Map<String, dynamic> tagGet(RequestContext context) {
  if (!context.logged.checkPermission(SEE_REPO)) {
    return resOut("Logged user cannot see tags", false);
  }
  Map<String, String> data = context.data;
  int tagId = int.parse(data["id"], onError: (_) {
    return null;
  });
  if (tagId == null) {
    return resOut("TagID have to be parsable integer", false);
  }
  Tag tag = repo.getTag(tagId);
  if (tag == null) {
    return resOut("Tag does not exist", false);
  }

  // no USER BRANCHES
  if (data is! Map || data["user"] != "central") {
    return resOut(
        "For this version of Tag_master, Request should contain \"user\":\"central\"",
        false);
  }
  // no USER BRANCHES
  Map<String, dynamic> result = repo.tagToJson(tag.id);
  if (data.containsKey("user")) {
    String strUser = data["user"];
    if (strUser == "all") {
      Map<String, Map> userTags = {};
      for (User user in users.values) {
        Map<String, dynamic> jtag = user.repository.tagToJson(tag.id);
        if (jtag != null) {
          userTags[user.login] = jtag;
        }
      }
      result["users"] = userTags;
    } else if (strUser == "me") {
      User me = context.logged;
      if (!me.repository.hasTag(tagId)) {
        return resOut("I have not modified this tag", true);
      }
      tag = me.repository.getTag(tagId);
      result["users"] = {me.login: me.repository.tagToJson(tag.id)};
    } else if (strUser == "central") {} else {
      User user = getUserFromString(strUser);
      if (user == null) {
        return resOut("User not found", false);
      }
      if (!user.repository.hasTag(tagId)) {
        return resOut("Selected user has not modified this tag", true);
      }
      tag = user.repository.getTag(tagId);
      result["users"] = {user.login: user.repository.tagToJson(tag.id)};
    }
  }
  return result;
}
Map<String, dynamic> tagPost(RequestContext context) {
  TagMasterContainer container=context.container;
  container..wrapTag()..validate()..execute();
  return null;
//  Map<String, dynamic> data = context.data;
//  User logged = context.logged;
//  Repo userRepo;
//  if (data is! Map || data["user"] != "central") {
//    return resOut(
//        "For this version of Tag_master, Request should contain \"user\":\"central\"",
//        false);
//  }
//  if (data.containsKey("user")) {
//    if (data["user"] == "central") {
//      if (!logged.checkPermission(MANAGE_REPO)) {
//        return resOut("Logged user cannot change default tags", false);
//      }
//      userRepo = repo;
//    } else if (data["user"] is int) {
//      if (!logged.checkPermission(MANAGE_OTHER_REPO)) {
//        return resOut("Logged user cannot change tags of other users", false);
//      }
//      User user = users[data["user"]];
//      if (user == null) {
//        return resOut("Selected user not found", false);
//      }
//      userRepo = user.repo;
//    } else if (data["user"] == "me") {} else {
//      return resOut(
//          "User selector is not valid (use \"default\",\"me\" or user ID)",
//          false);
//    }
//  }
//  if (userRepo == null) {
//    if (!logged.checkPermission(MANAGE_OWN_REPO)) {
//      return resOut("Logged user cannot change its own tags", false);
//    }
//    userRepo = logged.repo;
//  }
//  return updateTag(data, methodToCommand(context.method), userRepo, logged);
}
Map<String, dynamic> tagsPost(RequestContext context) {
  TagMasterContainer container=context.container;
  container..wrapTags()..validate()..execute();
  return null;
//  if (context.data is! Map) {
//    return resOut("Expecting Map as a data format", false);
//  }
//  Map<String, dynamic> data = context.data;
//  if (data["tags"] != null && data["tags"] is! List) {
//    return resOut("Expecting List of tags in \"tags\" parameter", false);
//  }
//  if (data is! Map || data["user"] != "central") {
//    return resOut(
//        "For this version of Tag_master, Request should contain \"user\":\"central\"",
//        false);
//  }
//  List jtags = data["tags"];
//  User logged = context.logged;
//  Repo userRepo;
//  if (data.containsKey("user")) {
//    if (data["user"] == "central") {
//      if (!logged.checkPermission(MANAGE_REPO)) {
//        return resOut("Logged user cannot change default tags", false);
//      }
//      userRepo = repo;
//    } else if (data["user"] is int) {
//      if (!logged.checkPermission(MANAGE_OTHER_REPO)) {
//        return resOut("Logged user cannot change tags of other users", false);
//      }
//      User user = users[data["user"]];
//      if (user == null) {
//        return resOut("Selected user not found", false);
//      }
//      userRepo = user.repo;
//    } else if (data["user"] == "me") {} else {
//      return resOut(
//          "User selector is not valid (use \"central\",\"me\" or user ID)",
//          false);
//    }
//  }
//  if (userRepo == null) {
//    if (!logged.checkPermission(MANAGE_OWN_REPO)) {
//      return resOut("Logged user cannot change its own tags", false);
//    }
//    userRepo = logged.repo;
//  }
//  Map<String, dynamic> res;
//  /*int success = 0;
//  int failed = 0;*/
//  Map tres = resOut("Nothing to do, empty List", true);
//  for (Map jtag in jtags) {
//    tres = updateTag(jtag, methodToCommand(context.method), userRepo, logged);
//    if (tres["suc"] == false) {
//      //failed++;
//      res = tres;
//    } else {
//      //success++;
//    }
//  }
//  if (res == null) {
//    return tres;
//  }
//  return res;
}
//Map<String, dynamic> validatePost() {}
//Map<String, dynamic> updateTag(
//    Map<String, dynamic> json, String command, Repo userRepo, User logged) {
//  Tag tag = null;
//  if (json.containsKey("id")) {
//    if (json["id"] is! int) {
//      return resOut("Tag ID have to be integer", false);
//    }
//    tag = userRepo.getTag(json["id"]);
//  }
//  if (command == "create") {
//    if (tag != null) {
//      return resOut("Cannot create tag because it already exists", false);
//    }
//    tag = userRepo.addTag(json);
//    if (tag!=null) {
//      return resOut("New default tag created", true);
//    } else {
//      return resOut("New default tag cannot be created", false);
//    }
//  } else if (command == "update") {
//    if (tag == null) {
//      return resOut("Tag ordered for modification does not exists", false);
//    }
//    json["id"]=tag.id;
//    tag = userRepo.updateTag(json);
//    if (tag!=null) {
//      return resOut("Update of tag successful", true);
//    } else {
//      return resOut("Update of tag failed", false);
//    }
//  } else if (command == "delete") {
//    if (tag == null) {
//      return resOut("Tag ordered for delete does not exists", false);
//    }
//    bool res = userRepo.deleteTag(tag);
//    if (res) {
//      return resOut("Tag successfully deleted", true);
//    } else {
//      return resOut("Tag cannot be deleted", false);
//    }
//  } else {
//    return resOut("Unknown command $command", false);
//  }
//}
User getUserFromString(strUser) {
  try {
    int userId = int.parse(strUser, onError: (_) {
      return null;
    });
    if (userId == null) {
      return null;
    }
    if (users[userId] == null) {
      return null;
    }
    return users[userId];
  } on FormatException {
    return null;
  }
}
Map<String, dynamic> relaGet(RequestContext context) {
  User logged = context.logged;
  if (!logged.checkPermission(SEE_REPO)) {
    return resOut("Logged user cannot see relations", false);
  }
  Map<String, String> data = context.data;
  if (data is! Map || data["user"] != "central") {
    return resOut(
        "For this version of Tag_master, Request should contain \"user\":\"central\"",
        false);
  }
  int relationId = int.parse(data["id"], onError: (_) {
    return null;
  });
  if (relationId == null) {
    return resOut("RelationID have to be parsable integer", false);
  }
  Relation relation = repo.getRelation(relationId);
  ;
  if (relation == null) {
    return resOut("Requested relation does not exists", false);
  }
  if (data.containsKey("user")) {
    String strUser = data["user"];
    if (strUser == "me") {} else if (strUser == "central") {
      relation = repo.getRelation(relationId);
    } else {
      User user = getUserFromString(strUser);
      if (user == null) {
        return resOut("Selected user does not exists", false);
      }
      if (!user.repository.hasRelation(relationId)) {
        return resOut("Selected user has not modified the relation", true);
      }
      relation = user.repository.getRelation(relationId);
    }
  }
  if (relation == null) {
    if (!logged.repository.hasRelation(relationId)) {
      return resOut("You have not modified this relation", true);
    }
    relation = logged.repository.getRelation(relationId);
  }
  return relation.toJson();
}
Map<String, dynamic> relaPost(RequestContext context) {
  TagMasterContainer container=context.container;
  container..wrapRelation()..validate()..execute();
  return null;
//  Map<String, dynamic> data = context.data;
//  User logged = context.logged;
//  Repo userRepo;
//  if (data is! Map || data["user"] != "central") {
//    return resOut(
//        "For this version of Tag_master, Request should contain \"user\":\"central\"",
//        false);
//  }
//  if (data.containsKey("user")) {
//    if (data["user"] == "central") {
//      if (!logged.checkPermission(MANAGE_REPO)) {
//        return resOut("Logged user cannot change central relations", false);
//      }
//      userRepo = repo;
//    } else if (data["user"] is int) {
//      if (!logged.checkPermission(MANAGE_OTHER_REPO)) {
//        return resOut(
//            "Logged user cannot change relations of other users", false);
//      }
//      User user = users[data["user"]];
//      if (user == null) {
//        return resOut("Selected user not found", false);
//      }
//      userRepo = user.repo;
//    } else if (data["user"] == "me") {} else {
//      return resOut(
//          "User selector is not valid (use \"central\",\"me\" or user ID)",
//          false);
//    }
//  }
//  if (userRepo == null) {
//    if (!logged.checkPermission(MANAGE_OWN_REPO)) {
//      return resOut("Logged user cannot change its own relations", false);
//    }
//    userRepo = logged.repo;
//  }
//  return updateRelation(
//      data, methodToCommand(context.method), userRepo, logged);
}
//Map<String, dynamic> updateRelation(
//    Map<String, dynamic> json, String command, Repo userRepo, User logged) {
//  Relation relation = null;
//  if (json.containsKey("id")) {
//    if (json["id"] is! int) {
//      return resOut("Relation ID have to be integer", false);
//    }
//    relation = userRepo.getRelation(json["id"]);
//  }
//  if (command == "create") {
//    if (relation != null) {
//      return resOut("Cannot create relation because it already exists", false);
//    }
//    bool res = userRepo.addRelation(json);
//    if (res) {
//      return resOut("New default relation created", true);
//    } else {
//      return resOut("New default relation cannot be created", false);
//    }
//  } else if (command == "update") {
//    if (relation == null) {
//      return resOut("Relation ordered for modification does not exists", false);
//    }
//    bool ret = userRepo.updateRelation(relation, json);
//    if (ret) {
//      return resOut("Update of relation successful", true);
//    } else {
//      return resOut("Update of relation failed", false);
//    }
//  } else if (command == "delete") {
//    if (relation == null) {
//      return resOut("Relation ordered for delete does not exists", false);
//    }
//    bool res = userRepo.deleteRelation(relation);
//    if (res) {
//      return resOut("Relation successfully deleted", true);
//    } else {
//      return resOut("Relation cannot be deleted", false);
//    }
//  } else {
//    return resOut("Unknown command $command", false);
//  }
//}
Map<String, dynamic> relTagsPost(RequestContext context){
  TagMasterContainer container = context.container;
  container
    ..wrap()
    ..validate()
    ..execute();
  return null;
}
