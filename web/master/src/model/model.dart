library tag_master_model;


import "dart:math";
import "dart:html";
import "dart:async";
import "dart:convert";
import 'package:tag_master/tag_master_common/library.dart';

part "gateway.dart";
part "user.dart";
part "client_tag.dart";
part "client_relation.dart";
part "tags.dart";
part "query.dart";
part "SSTagState.dart";

Xr0lang_cz lang;

void setLangInModel(val) {
  lang = val;
}


TagMasterRootModel model = new TagMasterRootModel();


class TagMasterRootModel{
  int numberOfShowedSmartOptions = 5;
  ClientRepo myRepo;
  Function onChange;
  Function requestRepaint;
  Gateway gateway;
  ClientUser user;
  bool canGoBack = false;
  Map tagMustacheJson = null;
  List<Filter> activeFilterList = [];
  Map formState = null;


  OverviewTags _overviewTags;
  ClientTag _tagToView;
  String _currentErrorMessage = "";
  bool _waitPlease = false;

  TagMasterRootModel(){
    gateway = new Gateway();
    user = new ClientUser();
    new Future.delayed(const Duration(milliseconds: 1)).then((_){
      user.requestUserData();
    });
  }

  void clearTempData(){
    tagMustacheJson = null;
  }

  void refreshOverviewTags(){
    _overviewTags = new OverviewTags();
  }

  OverviewTags get overviewTags{
    if(_overviewTags==null){
      _overviewTags = new OverviewTags();
    }

    return _overviewTags;
  }

  ClientTag get tagToView => _tagToView;

  String get currentErrorMessage => _currentErrorMessage;
  set currentErrorMessage(String val){
    _currentErrorMessage = val;
    _waitPlease = false;
    onChange();
  }


  bool get waitPlease => _waitPlease;
  set waitPlease(bool val){
    _waitPlease = val;
    onChange();
  }


  void setClientTagId(int id) {
    _tagToView = new ClientTag(id);
  }

  void doNewTag(String name, int type){
    _tagToView = new ClientTag.newTag(name, type);
  }
}

class ClientRepo extends Repo{

}

abstract class _DataIncoming{
  void dataIncoming(Map data);
  // if false, Gateway will solve exception
  bool dataError(String message);
}
