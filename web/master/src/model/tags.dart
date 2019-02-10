part of tag_master_model;

class OverviewTags {
  List<SimpleTag> tags = [];
  List<Function> onTagsChanged = [];

  OverviewTags() {
    model.gateway
    .sendGet(TAGS_API, {"user": model.user.id, "extend": "overview"})
    .then((Map json) {
      List incomingTags = json["tags"];
      tags = [];
      for (Map innerTag in incomingTags) {
        tags.add(new SimpleTag()
          ..fromJson(innerTag));
      }
      onTagsChanged.toList().forEach((f) {
        f();
      });
    }).catchError((e) {
      model.gateway.handleError(e);
    });
  }


  List toJson() {
    List out = [];
    for (var t in tags) {
      out.add(t.toJson());
    }
    return out;
  }

  SimpleTag getTagById(int searchedId) {
//    print(searchedId);
    for (SimpleTag tag in tags) {
//      print(tag.id == searchedId);
      if (tag.id == searchedId){return tag;}
    }
    return null;
  }

  Future<bool> checkName(String value) {
    Completer completer = new Completer();
    if (tags.isEmpty) {
      Function check;
      check = () {
        completer.complete(isInTags(value));
        onTagsChanged.remove(check);
      };
      onTagsChanged.add(check);
    } else {
      new Future.delayed(const Duration(milliseconds:3)).then((_) {
        completer.complete(isInTags(value));
      });
    }
    return completer.future;
  }

  bool isInTags(String name) {
    for (var t in tags) {
      if (t.name == name)return true;
    }
    return false;
  }
}