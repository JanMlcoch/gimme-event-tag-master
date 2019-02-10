library tag_master.web;

import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:mustache4dart/mustache4dart.dart' as mustache;
//import '../lib/library.dart';
part "gateway.dart";


const String TAGS_CONTROLLER = "/api/tags";
const String TAG_CONTROLLER = "/api/tag";

InputElement createTagButton;
InputElement tagNameInput;
DivElement tagList;
List<Tag> tags;
Map<String,Tag> flattags;
Element controls;
bool selectOpened = false;

void main() {
  tagNameInput = querySelector("#newTag");
  createTagButton = querySelector("#insertTag");
  tagList = querySelector("#listedTags");

  createTagButton.onClick.listen((MouseEvent e) {
    addTag(new Tag.fromString(tagNameInput.value));
    tagNameInput.value = "";
    redraw();
  });
  tagNameInput
    ..onKeyPress.listen((KeyboardEvent e) {
      //print(e.which);
      if (e.which == 13) {
        addTag(new Tag.fromString(tagNameInput.value));
        tagNameInput.value = "";
        redraw();
      }
    });

  redraw();
}

void redraw() {
  getTags().catchError((dynamic e) {
    querySelector("#erLog").innerHtml = e.toString();
  }).then(handleTags);
}

void handleTags(List<Map> jtags) {
  tags = [];
  flattags={};
  controls = null;
  int nsuper = 0;
  int count = 0;
  int sum = 0;
  int twolikes=0;

  for (Map<String, dynamic> jtag in jtags) {
    Tag tag = new Tag();
    tags.add(tag);
    tag.fromJSON(jtag);
    flattags[tag.name]=tag;
    count += tag.tagCount();
    sum += tag.tagLikes();
    if (tag.supertag) {
      nsuper++;
    }
    if(tag.likes>1){
      twolikes++;
    }
  }
  DivElement table = new DivElement()..classes.add("table");
  //TableElement table = new TableElement();
  //StringBuffer strbuf = new StringBuffer();
  //strbuf.write("<table>");
  table.innerHtml = """<div class='tablehead'>
         <span>Počet: $count tagů</span><br>
         <span>Supertagy: $nsuper tagů</span><br>
         <span>Oblíbené: $twolikes tagů</span><br>
         <span>Suma: $sum likeů</span></div>
""";
  tags.sort((Tag tag1, Tag tag2) {
    int tag1likes = tag1.likes;
    int tag2likes = tag2.likes;
    return tag2likes - tag1likes;
  });
  for (Tag tag in tags) {
    table.append(tag.widget());
    if (tag.childs != null) {
      tag.childs.sort((Tag tag1, Tag tag2) {
        int tag1likes = tag1.likes;
        int tag2likes = tag2.likes;
        return tag2likes - tag1likes;
      });
      for (Tag child in tag.childs) {
        table.append(child.widget());
      }
    }
  }
  tagList
    ..innerHtml = ""
    ..append(table);
  ElementList rows = querySelectorAll(".tag_row");
  for (DivElement row in rows) {
    row.onMouseEnter.listen((MouseEvent e) {
      createControls(row);
    });
  }
}
void createControls(Element row) {
  if (selectOpened) {
    return;
  }
  if (controls == null) {
    controls = new DivElement();
    StringBuffer options = new StringBuffer();
    Map<String,String> optionWidgets=new Map<String,String>();
    for (Tag tag in tags) {
      if (tag.supertag) {
        optionWidgets[tag.name]=tag.optionWidget();
        //options.write(tag.optionWidget());
      }
    }
    List<String> optKeys=optionWidgets.keys.toList();
    optKeys.sort();
    for(String opt in optKeys){
      options.write(optionWidgets[opt]);
    }
    ButtonElement likeButton = new ButtonElement()
      ..innerHtml = "Like"
      ..id = "like_button";
    likeButton.onClick.listen((MouseEvent e) {
      Tag tag = getTagByControl(e.target);
      addTag(tag);
      redraw();
    });
    controls.append(likeButton);

    ButtonElement dislikeButton = new ButtonElement()
      ..innerHtml = "Dislike"
      ..id = "dislike_button";
    dislikeButton.onClick.listen((MouseEvent e) {
      Tag tag = getTagByControl(e.target);
      addTag(tag, false);
      redraw();
    });
    controls.append(dislikeButton);

    ButtonElement supertagButton = new ButtonElement()
      ..innerHtml = "Supertag"
      ..id = "supertag_button";
    controls.append(supertagButton);
    supertagButton.onClick.listen((MouseEvent e) {
      Tag tag = getTagByControl(e.target);
      if (tag.supertag) {
        superTag(tag, false);
      } else {
        superTag(tag);
      }
      redraw();
    });

    SelectElement parentSelect = new SelectElement()
      ..innerHtml = "<option selected value='null'>Bez Supertagu</option>" +
          options.toString()
      ..id = "parent_select";
    parentSelect.onMouseEnter.listen((_) {
      selectOpened = true;
    });
    parentSelect.onMouseOut.listen((_) {
      selectOpened = false;
    });
    parentSelect.onChange.listen((Event e) {
      Tag tag = getTagByControl(e.target);
      String targetName = (e.target as SelectElement).value;
      Tag target = getTagByName(targetName);
      moveTag(tag, target);
      redraw();
    });
    controls.append(parentSelect);
  }

  controls.remove();
  Tag tag = getTagByRow(row);
  if(tag==null){return;}
  SelectElement select = controls.querySelector("select");
  if (tag._parent != null) {
    select.value = tag._parent.name;
  } else {
    select.value = "null";
  }
  select.disabled = tag.supertag;
  //Tag tag=tags[tagname];
  row.querySelector(".controls").append(controls);
}
Tag getTagByName(String name) {
  return flattags[name];
}
Tag getTagByRow(Element row) {
  for (Tag tag in flattags.values) {
    if (row == tag.row) {
      return tag;
    }
  }
  return null;
}
Tag getTagByControl(Element button) {
  DivElement row = button.parent.parent.parent;
  return getTagByRow(row);
}
class Tag {
  bool supertag = false;
  String name = "";
  int likes = 0;
  List<Tag> childs;
  Element row;
  Tag _parent;

  Tag() {}
  Tag.fromString(this.name) {}
  void fromJSON(Map<String, dynamic> json) {
    name = json["name"];
    likes = json["likes"];
    supertag = json["super"];
    if (json.containsKey("childs")) {
      childs = [];
      for (Map<String, dynamic> jtag in json["childs"]) {
        Tag child = new Tag();
        child.fromJSON(jtag);
        childs.add(child);
        flattags[child.name]=child;
        child._parent = this;
      }
    }
  }
  DivElement widget() {
    Map out = {};
    out["tag"] = name;
    out["likes"] = likes;

    String template = """
      <div class='tag_name_field'>{{tag}}</div><div class='tag_likes_field'>{{likes}}</div><div class="controls"></div>
  """;
    row = new DivElement()
      ..innerHtml = mustache.render(template, out)
      ..classes.add("tag_row");
    if (supertag) {
      row.classes.add("supertag");
    }
    if (_parent != null) {
      row.classes.add("child");
    }
    return row;
  }
  String optionWidget() {
    if (supertag) {
      return '<option value="${name}">${name}</option>';
    } else {
      return "";
    }
  }
  int tagCount() {
    if (childs == null) {
      return 1;
    }
    return childs.length + 1;
  }
  int tagLikes() {
    if (childs == null) {
      return likes;
    }
    int count = likes;
    for (Tag tag in childs) {
      count += tag.likes;
    }
    return count;
  }
}
