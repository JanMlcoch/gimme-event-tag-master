part of tag_master_view;

class AddTagWidget extends Widget{
  InputElement nameInput;
  SelectElement select;
  Element submit;
  String get name => "AddTagWidget";

  AddTagWidget(){
    template = parse(resources.templates.add_tag);
  }


  @override
  void destroy(){
    //do nothing
  }

  @override
  Map out(){
    Map out = resources.lang_cz.addTag.toJson();
    out["options"] = resources.lang_cz.tagTypes;
    return out;
  }

  @override
  void setChildrenTargets(){
    // do nothing
  }

  @override
  void tideFunctionality(){
      nameInput = target.querySelector("#add_tag_name");
      select = target.querySelector("#add_tag_type");
      submit = target.querySelector(".submit_add_tag");

      void doSubmit(_){
        String name = nameInput.value;
        if(name!=""){
          name = name[0].toUpperCase()+name.substring(1).toLowerCase();
          model.overviewTags.checkName(name).then((bool e){
            if(!e){
              model.doNewTag(name, int.parse(select.value));
              view.platformWidget.setMenuPath(PlatformWidget.PATH_EDIT_TAG);
            }else{
              window.alert("is used");
              nameInput.select();
            }
          });
        }
      }

      submit.onClick.listen(doSubmit);
      select.onKeyDown.listen((e){
        if(e.keyCode == KeyCode.ENTER){
          doSubmit(null);
        }
      });

      nameInput.onKeyDown.listen((e){
        if(e.keyCode == KeyCode.ENTER){
          doSubmit(null);
        }
      });


    nameInput.focus();
  }
}