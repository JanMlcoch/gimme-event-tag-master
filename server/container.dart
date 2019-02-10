part of tag_master.server;

class TagMasterContainer extends DataContainer {
  RequestContext _context;
  List<Map> tags = new List<Map>();
  List<Map> relations = new List<Map>();
  List<Map> users = new List<Map>();
  Repo userRepo;
  List<String> messages = [];
  bool success = true;
  List<Tag> addedTags = [];
  List<Relation> addedRelations = [];
  List<User> addedUsers = [];
  static const Map<String, Map> permissionMatrix = const {
    "GET": const {
      "own": SEE_REPO,
      "central": SEE_REPO,
      "other": SEE_REPO,
      "user": MANAGE_USERS,
      "I": 0
    },
    "POST": const {
      "own": MANAGE_OWN_REPO,
      "central": MANAGE_REPO,
      "other": MANAGE_OTHER_REPO,
      "user": MANAGE_USERS,
      "I": MANAGE_USERS
    },
    "PUT": const {
      "own": MANAGE_OWN_REPO,
      "central": MANAGE_REPO,
      "other": MANAGE_OTHER_REPO,
      "user": MANAGE_USERS,
      "I": MANAGE_USERS
    },
    "DELETE": const {
      "own": MANAGE_OWN_REPO,
      "central": MANAGE_REPO,
      "other": MANAGE_OTHER_REPO,
      "user": MANAGE_USERS,
      "I": MANAGE_USERS
    }
  };



  TagMasterContainer(this._context) {}
  @override
  bool wrap() {
    dynamic json = _context.data;
    if (json is! Map) {
      return _context.respond("JSON data is not Map", false);
    }
    if (json["tags"] != null) {
      if (json["tags"] is! List) {
        return _context.respond("Tags data is not List", false);
      } else {
        tags = json["tags"];
      }
    }
    if (json["relations"] != null) {
      if (json["relations"] is! List) {
        return _context.respond("Relations data is not List", false);
      } else {
        relations = json["relations"];
      }
    }
    if (json["users"] != null) {
      return _context.respond(
          "Users data cannot be loaded through universal wrap", false);
//      if (json["users"] is! List) {
//        return _context.respond("Users data is not List", false);
//      } else {
//        users = json["users"];
//      }
    }
    return true;
  }
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["tags"] = tags;
    map["relations"] = relations;
    map["users"] = users;
    return map;
  }

  void wrapTag() {
    dynamic json = _context.data;
    if (json is! Map) {
      _context..respond("Tag data is not Map", false);
    }
    tags.add(json);
  }
  void wrapTags() {
    dynamic json = _context.data;
    if (json is! List) {
      _context..respond("Tags data is not List", false);
    }
    tags = json;
  }
  void wrapRelation() {
    dynamic json = _context.data;
    if (json is! Map) {
      _context..respond("Relation data is not Map", false);
    }
    relations.add(json);
  }
  void wrapRelations() {
    dynamic json = _context.data;
    if (json is! List) {
      _context..respond("Relations data is not List", false);
    }
    relations = json;
  }
  void wrapUser() {
    dynamic json = _context.data;
    if (json is! Map) {
      _context..respond("User data is not Map", false);
    }
    users.add(json);
  }
  void wrapUsers() {
    dynamic json = _context.data;
    if (json is! List) {
      _context..respond("Users data is not List", false);
    }
    users = json;
  }
  void compileMessages({bool success: false}) {
    _context.respond(messages.join("<br>"), success);
  }
  @override
  void validate() {
    if (!_context.success) {
      return;
    }
    _setUserRepo(repo); // set repository to default one
    if (!success) {
      compileMessages();
      return;
    }
    String method = _context.method;
    if (method == "GET") {
      return;
    } else if (method == "POST") {
      _validateCreate();
    } else if (method == "PUT") {
      _validateUpdate();
    } else if (method == "DELETE") {
      _validateDelete();
    } else {
      throw new StateError("Unknown method");
    }
    if (!success) {
      compileMessages();
      return;
    }
  }
  bool _setUserRepo(Repo repository) {
    userRepo = repository;
    _checkPermissions();
    if (!success) return false;
    return true;
  }
  bool _checkPermissions() {
    User logged = _context.logged;
    if (logged == null) {
      addMessage("Logged user is null");
      return false;
    }
    String column = "";
    Map permissionLine = permissionMatrix[_context.method];
    if (tags.isNotEmpty || relations.isNotEmpty) {
      if (userRepo == null) {
        throw new StateError("Missing central repo");
      }
      if (userRepo == logged.repository) {
        column = "own";
      } else if (userRepo == repo) {
        column = "central";
      } else {
        column = "other";
      }
      if (!logged.checkPermission(permissionLine[column])) {
        return addMessage(
            "Logged user cannot ${methodToCommand(_context.method)} tags or relations in $column repository");
      }
    }
    if (users.isNotEmpty) {
      column = "user";
      if (users.length == 1 && users[0] is Map && users[0]["id"] == logged.id) {
        column = "I";
      }
      if (!logged.checkPermission(permissionLine[column])) {
        return addMessage(
            "Logged user cannot ${methodToCommand(_context.method)} ${column=="I"?"me":"other user"}");
      }
    }
    return true;
  }
  bool _validateCreate() {
    for (dynamic json in tags) {
      addMessage(userRepo.preAddTag(json));
      _preDigUpRelations(json);
    }
    if (!success) {
      return false;
    }
    for (dynamic json in relations) {
      addMessage(userRepo.preAddRelation(json));
    }
    if (!success) {
      return false;
    }
    // TODO user validation
    return true;
  }
  bool _validateUpdate() {
    for (dynamic json in tags) {
      addMessage(userRepo.preUpdateTag(json));
      //_preDigUpRelations(json);
    }
    if (!success) {
      return false;
    }
    for (dynamic json in relations) {
      addMessage(userRepo.preUpdateRelation(json));
    }
    if (!success) {
      return false;
    }
    // TODO user validation
    return true;
  }
  bool _validateDelete() {
    for (dynamic json in tags) {
      addMessage(userRepo.preDeleteTag(json));
    }
    if (!success) {
      false;
    }
    for (dynamic json in relations) {
      addMessage(userRepo.preDeleteRelation(json));
    }
    if (!success) {
      return false;
    }
    // TODO user validation
    return true;
  }
  bool addMessage(String msg) {
    if (msg == null) {
      return true;
    }
    //print(msg);
    messages.add(msg);
    success = false;
    return false;
  }
  void addMessageWithOk(String msg, okMsg) {
    if (msg == null) {
      messages.add(okMsg);
    } else {
      messages.add(msg);
      success = false;
    }
  }
  void addOkMessage(String msg) {
    if (msg != null) {
      //print(msg);
      messages.add(msg);
    }
  }

  @override
  void execute() {
    if (!_context.success) {
      return;
    }
    String method = _context.method;
    bool res = true;


    // save data to model
    if (method == "GET") {
      return;
    } else if (method == "POST") {
      res = _executeCreate();
    } else if (method == "PUT") {
      res = _executeUpdate();
    } else if (method == "DELETE") {
      res = _executeDelete();
    } else {
      throw new StateError("Unknown method");
    }

    modelChanged = true;
    lastChangeTime = new DateTime.now();

    // Save data to output
    // TODO rollback
    if (!success || !res) {
      //throw new StateError("Execution Error in $method");
      print("Execution error in $method");
      compileMessages(success: false);
    } else {
      compileMessages(success: true);
    }


  }
  bool _executeCreate() {
    for (dynamic json in tags) {
      addMessage(userRepo.preAddTag(json));
      if (!success) return false;
      _preDigUpRelations(json);
      if (!success) return false;

      // Active part
      Tag tag = userRepo.addTag(json);
      if (tag == null) {
        addMessage("Tag create failed");
        return false;
      }
      addedTags.add(tag);
      addOkMessage("Tag ${tag.name} (ID=${tag.id}) successfully added");
      bool res = _digUpRelations(json, tag);
      if (!res) return false;
    }
    for (dynamic json in relations) {
      addMessage(userRepo.preAddRelation(json));
      if (!success) return false;
      Relation relation = userRepo.addRelation(json);
      if (relation == null) {
        return addMessage("Relation ${json["id"]} have been deleted");
      }
      addOkMessage("Relation ${relation.id} successfully added");
    }
    if (!success) return false;
    // TODO user execution
    return true;
  }
  bool _executeUpdate() {
    for (dynamic json in tags) {
      addMessage(userRepo.preUpdateTag(json));
      if (!success) return false;
      /*_preDigUpRelations(json);
      if (!success) return false;*/
      Tag tag = userRepo.updateTag(json);
      addOkMessage("Tag ${tag.name} successfully updated");
      /*bool res = _digUpRelations(json, tag);
      if (!res) return false;*/
    }
    if (!success) return false;
    for (dynamic json in relations) {
      addMessage(userRepo.preUpdateRelation(json));
      if (!success) return false;
      Relation relation = userRepo.updateRelation(json);
      if (relation == null) {
        return addMessage("Relation ${json["id"]} have been deleted");
      }
      addOkMessage("Relation ${relation.id} successfully updated");
    }
    if (!success) return false;
    // TODO user execution
    return true;
  }
  bool _executeDelete() {
    for (dynamic json in tags) {
      addMessage(userRepo.preDeleteTag(json));
      if (!success) return false;
      Tag tag = userRepo.deleteTag(json["id"]);
      addOkMessage("Tag ${tag.name} successfully deleted");
    }
    if (!success) return false;
    for (dynamic json in relations) {
      addMessage(userRepo.preDeleteRelation(json));
      if (!success) return false;
      Relation relation = userRepo.deleteRelation(json["id"]);
      if (relation == null) return false;
      addOkMessage("Relation ${relation.id} successfully deleted");
    }
    if (!success) return false;
    // TODO user execution
    return true;
  }
  void _preDigUpRelations(json) {
    if (json is! Map<String, dynamic>) {
      addMessage(json.toString() + " is not Map");
      return;
    }
    Tag mainTag = userRepo.getTag(json["id"]);
    for (String key in ["from", "to"]) {
      String relaKey = "relas_" + (key == "from" ? "src" : "trg");
      if (!json.containsKey(relaKey)) {
        continue;
      }
      if (json[relaKey] is! List<Map>) {
        addMessage("relas_$relaKey tagu ${json} is not List<Map>");
      }
      List<Map> jRelations = json[relaKey];
      if (mainTag == null) {
        for (Map jRelation in jRelations) {
          addMessage(userRepo.preAddRelation(jRelation, ignoreMounts: [key]));
        }
      } else {
        if (key == "from") {
          for (Map jRelation in jRelations) {
            addMessage(
                userRepo.preAddRelationWithMount(jRelation, source: mainTag));
          }
        } else {
          for (Map jRelation in jRelations) {
            addMessage(
                userRepo.preAddRelationWithMount(jRelation, target: mainTag));
          }
        }
      }
    }
  }
  bool _digUpRelations(Map<String, dynamic> json, Tag tag) {
    if (json.containsKey("relas_src")) {
      List<Map> sources = json["relas_src"];
      for (Map jsonRela in sources) {
        addMessage(userRepo.preAddRelationWithMount(jsonRela, source: tag));
        if (!success) return false;
        Relation relation = userRepo.addRelation(jsonRela, source: tag);
        addOkMessage("Relation ${relation.id} successfully added");
      }
    }
    if (json.containsKey("relas_trg")) {
      List<Map> targets = json["relas_trg"];
      for (Map jsonRela in targets) {
        addMessage(userRepo.preAddRelationWithMount(jsonRela, target: tag));
        if (!success) return false;
        Relation relation = userRepo.addRelation(jsonRela, target: tag);
        if (relation == null) {
          return addMessage("Relation ${json["id"]} have been deleted");
        }
        addOkMessage("Relation ${relation.id} successfully added");
      }
    }
    return true;
  }
}
