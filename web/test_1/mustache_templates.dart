//library tag_master.mustache_templates;
//
//import 'package:dart_ext/collection_ext.dart';
//
//import 'package:mustache4dart/mustache4dart.dart';
//
////import 'package:dart_ext/collection_ext.dart';
//import 'main.dart';
//part "texts.dart";
////import 'package:dart_ext/function_ext.dart';
////import 'package:dart_ext/function_ext_mirror_invoke.dart';    // use mirror.
////import 'package:dart_ext/string_ext.dart';
//
//class HTMLBlock {
//  String template;
//  Map json;
//
//  HTMLBlock(this.template, this.json);
//
//  String renderBlock() {
//    Map jsonToRender = merge(texts, this.json);
//    return render(this.template, jsonToRender);
//  }
//
//  String renderWithJson(json) {
//    Map jsonToRender = merge(texts, json);
//    return render(this.template, jsonToRender);
//  }
//}
//
//HTMLBlock login = new HTMLBlock("""<h1>{{loginTitle}}</h1>
//      <form>
//        <table>
//          <tr>
//            <td>{{loginText}}
//            </td>
//            <td><input type='text' id='login'/></td>
//          </tr>
//          <tr>
//            <td>{{passText}}
//            </td>
//            <td><input type='password' id='password'/></td>
//          </tr>
//          <tr>
//            <td><input type='button' id='submitCredentials' value='{{submitText}}'></td>
//          </tr>
//        </table>
//      </form>""", {
//  "loginTitle": texts["loginTitle"],
//  "loginText": texts["loginText"],
//  "passText": texts["passText"],
//  "submitText": texts["submitText"]
//});
//
//HTMLBlock waitPlease = new HTMLBlock("<h1>Please Wait</h1>", {});
//
//HTMLBlock defaultMenu = new HTMLBlock("""
//<table>
//  <tr>
//    <td>{{menuItem1}}</td>
//    <td>{{menuItem2}}</td>
//    <td>{{menuItem3}}</td>
//    <td>{{menuItem4}}</td>
//    <td>{{menuItem5}}</td>
//    <td>{{menuItem6}}</td>
//    <td>{{loginHandle}}</td>
//  </tr>
//</table>
//<div id='sub_content'></div>
//""", {
//  "menuItem1": "",
//  "menuItem2": "",
//  "menuItem3": "",
//  "menuItem4": "",
//  "menuItem5": "",
//  "menuItem6": "",
//  "loginHandle": "",
//});
////insert
//
//HTMLBlock handleLogin = new HTMLBlock(
//    "<table><tr>{{loginSauce}}<b>{{loginName}}</b></tr>{{logOut}}<tr></tr><tr>{{relog}}</tr><tr>{{editProfile}}</tr></table>",//edited
//    {
//  "loginSauce": texts["loginSauce"],
//  "loginName": "",
//  "logout": "",
//  "editProfile": ""
//});
//
//HTMLBlock loginName = new HTMLBlock("<span class='loginName'></span>", {});
//
//HTMLBlock buttonToOverview = new HTMLBlock(
//    "<input type='button' value='{{buttonToOverviewSauce}}' id='toOverview'/>",
//    {"buttonToOverviewSauce": texts["buttonToOverviewSauce"]});
//
//HTMLBlock buttonToHome = new HTMLBlock(
//    "<input type='button' value='{{buttonToHomeSauce}}' id='toHome'/>", {
//  "buttonToHomeSauce": texts["buttonToHomeSauce"]
//});
//
//HTMLBlock acceptError = new HTMLBlock(
//    "<input type='button' value='{{acceptErrorSauce}}' id='acceptError'/>", {
//  "acceptErrorSauce": texts["acceptErrorSauce"]
//});
//
//HTMLBlock buttonLogout = new HTMLBlock(
//    "<input type='button' value='{{logoutSauce}}' class='logout' disabled='true' />", {
//  "logoutSauce": texts["logoutSauce"]
//});
//
//HTMLBlock buttonRelog = new HTMLBlock(
//    "<input type='button' value='{{relogSauce}}' id='relog' />", {});
//
//HTMLBlock buttonToViewTag = new HTMLBlock(
//    "<input type='button' value='{{viewTagSauce}}' id='viewtag{{id}}' class='buttonToEditTag' />",
//    {});
//
//HTMLBlock buttonToEditTag = new HTMLBlock(
//    "<input type='button' value='{{editTagSauce}}' id='edittag' />",/*{{id}}*/
//    {});
//
//HTMLBlock buttonBack = new HTMLBlock(
//    "<input type='button' value='{{backSauce}}' id='backButton' {{#cannotGoBack}}disabled='true'{{/cannotGoBack}} />",
//    {});
//
//HTMLBlock buttonToAddTag = new HTMLBlock(
//    "<input type='button' value='{{addTagSauce}}' id='addTag' />",
//    {});
//
//HTMLBlock buttonChangeTagType = new HTMLBlock(
//    "<input type='button' value='{{ChangeTagTypeSauce}}' id='changeType' disabled='true'/>",
//    {});
//
//HTMLBlock buttonSubmitChangesToTag = new HTMLBlock(
//    "<input type='button' value='{{submitChangesToTagSauce}}' id='submitTag' />",
//    {});
//
//HTMLBlock overview = new HTMLBlock(
//    "<table>{{#tags}}{{#tag}}<tr><td>{{editButton}}</td><td><div id='toColor{{i}}' style='background-color: {{color}};' >{{name}}</div></td></tr>{{/tag}}{{/tags}}</table>",
//    {"tags": []});
//
//HTMLBlock insertBlock(String mark, HTMLBlock subBlock, HTMLBlock uberBlock) {
//  //je třeba mít unikátní name značek
//  uberBlock.template =
//      uberBlock.template.replaceAll("{{" + mark + "}}", subBlock.template);
//  //print(uberBlock.template);
//  //print("{{" + mark + "}}");
//  //print(subBlock.template);
//  //print(uberBlock.template);
//  uberBlock.json[mark] = "";
//  uberBlock.json = merge(
//      uberBlock.json, subBlock.json); //zatím funguje pouze pro nezanořené bloky
//  return uberBlock;
//}
//
//HTMLBlock viewTag = new HTMLBlock("""{{#tag}}
//<table>
//    <tr>
//        <td>{{tagIdSauce}}</td>
//        <td>{{id}}</td>
//    </tr>
//    <tr>
//        <td>{{tagNameSauce}}</td>
//        <td>{{name}}</td>
//    </tr>
//    <tr>
//        <td>{{tagTypeSauce}}</td>
//        <td id='tagType'>{{type}}</td>
//    </tr>
//</table>
//<h4>
//            {{relationsFromSauce}}
//</h4>
//        <table id='relTable' class='centerAlign'>
//          <tr>
//              <td>{{relationIdSauce}}</td>
//              <td>Z Tagu</td>
//              <td>Do Tagu</td>
//              <td>{{relationStrengthSauce}}</td>
//          </tr>
//            {{#relas}}
//                {{#id}}
//                  <tr id='{{relRowId}}'>
//                    <td>{{id}}</td>
//                    <td class='tagId' >{{from}}</td>
//                    <td class='tagId' >{{to}}</td>
//                    <td>{{str}}</td>
//                </tr>
//                {{/id}}
//
//            {{/relas}}
//        </table>
//            <h4>{{relationsToSauce}}</h4>
//    {{notReadySauce}}
//{{/tag}}{{edit}}""", {});
//
//HTMLBlock editTag = new HTMLBlock("""{{#tag}}
//<table>
//    <tr>
//        <td>{{tagIdSauce}}</td>
//        <td>{{id}}</td>
//    </tr>
//    <tr>
//        <td>{{tagNameSauce}}</td>
//        <td><input type='text' id='inputTagName' value='{{name}}' /></td>
//    </tr>
//    <tr>
//        <td>{{tagTypeSauce}}</td>
//        <td id='tagType'>{{#Typ1}}{{typ1}}{{/Typ1}}{{#Typ2}}{{typ2}}{{/Typ2}}{{#Typ3}}{{typ3}}{{/Typ3}}{{#Typ4}}{{typ4}}{{/Typ4}}{{#Typ5}}{{typ5}}{{/Typ5}}{{changeType}}</td>
//    </tr>
//</table>
//<h4>
//            {{relationsFromSauce}}
//</h4>
//      <table id="relTable" class='centeraling'>
//          <tr>
//              <td>{{relationIdSauce}}</td>
//              <td>Z Tagu</td>
//              <td>Do Tagu</td>
//              <td>{{relationStrengthSauce}}</td>
//          </tr>
//            {{#relas}}
//                {{#id}}
//                  {{relRow}}
//                {{/id}}
//
//            {{/relas}}
//        </table>
//            <input type='button' value='{{addRelationSauce}}' id='addRelation' />
//            <h4>{{relationsToSauce}}</h4>
//    {{notReadySauce}}<br />
//{{submit}}
//{{/tag}}""", {});
//
//HTMLBlock relRow = new HTMLBlock("""
//  <tr id='{{relRowId}}'>
//      <td>{{id}}</td>
//      <td><input type='text' id='inputTagName' value='{{from}}' disabled='true' /></td>
//      <td><input type='text' id='inputTagName' value='{{to}}' /></td>
//      <td><input type='text' id='inputTagName' value='{{str}}' /></td>
//  </tr>
//""", {});
//
//HTMLBlock chooseNewTagType = new HTMLBlock("""
//{{chooseTagTypeSauce}}
//<select id='tagTypeSelect'>
//  <option value='1'>{{typ1}}</option>
//  <option value='2'>{{typ2}}</option>
//  <option value='3'>{{typ3}}</option>
//  <option value='4'>{{typ4}}</option>
//  <option value='5'>{{typ5}}</option>
//</select>
//<input type='button' value='{{submitText}}' id='submit' />
//
//""", {});
//
//HTMLBlock setupSynonym = new HTMLBlock("""
//
//{{tagName}}<input type='text' id='name' /><br />
//{{chooseSynonymTargetSauce}}<br />
//<select id='selectTarget' >
//
//  <optgroup label='{{typ5}}'>
//  {{#tags}}{{#Typ5}}
//    <option value='{{id}}'>{{name}}</option>
//  {{/Typ5}}{{/tags}}
//  </optgroup>
//  <optgroup label='{{typ4}}'>
//  {{#tags}}{{#Typ4}}
//    <option value='{{id}}'>{{name}}</option>
//  {{/Typ4}}{{/tags}}
//  </optgroup>
//  <optgroup label='{{typ3}}'>
//  {{#tags}}{{#Typ3}}
//    <option value='{{id}}'>{{name}}</option>
//  {{/Typ3}}{{/tags}}
//  </optgroup>
//  <optgroup label='{{typ2}}'>
//  {{#tags}}{{#Typ2}}
//    <option value='{{id}}'>{{name}}</option>
//  {{/Typ2}}{{/tags}}
//  </optgroup>
//  <optgroup label='{{typ1}}'>
//  {{#tags}}{{#Typ1}}
//    <option value='{{id}}'>{{name}}</option>
//  {{/Typ1}}{{/tags}}
//  </optgroup>
//
//</select>
//<input type='button' value='{{submitText}}' id='submit' />
//
//""", {});
////<input type="number" name="points" min="0" max="100" step="10" value="30">
//HTMLBlock setupComposite = new HTMLBlock("""
//
//{{tagName}}<input type='text' id='name' /><br />
//{{chooseCompositeTargetSauce}}<br />
//<table id='tableOfTargetedRelations'><tr><td>{{relTarget}}</td><td>{{relationStrengthSauce}}</td></td>
//  {{targeted}}
//</table>
//<input type='button' value='{{addRelationSauce}}' id='add' />
//<input type='button' value='{{submitText}}' id='submit' />
//{{compoCompoRedirSauce}}
//""", {});
//
//HTMLBlock setupCustom = new HTMLBlock("""
//
//{{tagName}}<input type='text' id='name' /><br />
//<input type='button' value='{{submitText}}' id='submit' />
//
//""", {});
//
//HTMLBlock targetedRelationInTr = new HTMLBlock("""
//<tr><td>
//<select id='selectTarget{{count}}' >111
//
//  <optgroup label='{{typ5}}'>
//  {{#tags}}{{#Typ5}}
//    <option value='{{id}}'>{{name}}</option>
//  {{/Typ5}}{{/tags}}
//  </optgroup>
//  <optgroup label='{{typ4}}'>
//  {{#tags}}{{#Typ4}}
//    <option value='{{id}}' {{#core}}disabled='true'{{/core}}>{{name}}</option>
//  {{/Typ4}}{{/tags}}
//  </optgroup>
//  <optgroup label='{{typ3}}' >
//  {{#tags}}{{#Typ3}}
//    <option value='{{id}}' {{#core}}disabled='true'{{/core}}>{{name}}</option>
//  {{/Typ3}}{{/tags}}1
//  </optgroup>
//  <optgroup label='{{typ2}}' disabled='true'>
//  {{#tags}}{{#Typ2}}
//    <option value='{{id}}' disabled='true'>{{name}}</option>
//  {{/Typ2}}{{/tags}}
//  </optgroup>
//  <optgroup label='{{typ1}}' disabled='true'>
//  {{#tags}}{{#Typ1}}
//    <option value='{{id}}' disabled='true'>{{name}}</option>
//  {{/Typ1}}{{/tags}}
//  </optgroup>
//
//</select>
//</td><td>
//<input type="number" name="str" min="-1" max="1" step="0.05" value="0" id="str{{count}}" />
//</td></tr>
//""",{"count":1});
//
//HTMLBlock targetedRelationInTr2 = new HTMLBlock("""
//<tr><td>{{id}}</td><td>{{name}}</td><td>
//<select id='selectTarget{{count}}' >
//
//  <optgroup label='{{typ5}}'>
//  {{#taggs}}{{#Typ5}}
//    <option value='{{id}}' id='o{{count}}_{{id}}' {{#custom}}disabled='true'{{/custom}}>{{name}}</option>
//  {{/Typ5}}{{/taggs}}
//  </optgroup>
//  <optgroup label='{{typ4}}'>
//  {{#taggs}}{{#Typ4}}
//    <option value='{{id}}' id='o{{count}}_{{id}}' {{#core}}disabled='true'{{/core}}>{{name}}</option>
//  {{/Typ4}}{{/taggs}}
//  </optgroup>
//  <optgroup label='{{typ3}}' >
//  {{#taggs}}{{#Typ3}}
//    <option value='{{id}}' id='o{{count}}_{{id}}' {{#core}}disabled='true'{{/core}}>{{name}}</option>
//  {{/Typ3}}{{/taggs}}1
//  </optgroup>
//  <optgroup label='{{typ2}}'>
//  {{#taggs}}{{#Typ2}}
//    <option value='{{id}}' id='o{{count}}_{{id}}' {{#notSyn}}disabled='true'{{/notSyn}}>{{name}}</option>
//  {{/Typ2}}{{/taggs}}
//  </optgroup>
//  <optgroup label='{{typ1}}'>
//  {{#taggs}}{{#Typ1}}
//    <option value='{{id}}' id='o{{count}}_{{id}}' {{#notSyn}}disabled='true'{{/notSyn}}>{{name}}</option>
//  {{/Typ1}}{{/taggs}}
//  </optgroup>
//
//</select>
//</td><td>
//<input type="number" name="str" min="-1" max="1" step="0.05" value="{{str}}" id="str{{count}}" />
//</td></tr>
//""",{"count":1});
//
//void tetrisBlocks() {
//  handleLogin = insertBlock("logOut", buttonLogout, handleLogin);
//  handleLogin = insertBlock("loginName", loginName, handleLogin);
//  handleLogin = insertBlock("relog", buttonRelog, handleLogin);
//
//
//  defaultMenu = insertBlock("loginHandle", handleLogin, defaultMenu);
//  defaultMenu = insertBlock("menuItem1", buttonToHome, defaultMenu);
//  defaultMenu = insertBlock("menuItem2", buttonToOverview, defaultMenu);
//  defaultMenu = insertBlock("menuItem3", buttonToAddTag, defaultMenu);
//  defaultMenu = insertBlock("menuItem6", buttonBack, defaultMenu);
//
//  overview = insertBlock("editButton", buttonToViewTag, overview);
//
//  editTag = insertBlock("relRow", targetedRelationInTr2, editTag);
//  editTag = insertBlock("changeType", buttonChangeTagType, editTag);
//  editTag = insertBlock("submit", buttonSubmitChangesToTag, editTag);
//
//  setupComposite = insertBlock("targeted",targetedRelationInTr,setupComposite);
//  //viewTag = insertBlock("edit", buttonToEditTag, viewTag);
//
//  //print(overview.template);
//  //print(defaultMenu.template+defaultMenu.json.toString());
//}
//
//class PageModel {
//  Map _attributes;
//  PageModel(attributes) {
//    this._attributes = attributes;
//  }
//  void changeParameter(Map newAttributes, {bool tryLogged: true}) {
//    this._attributes = newAttributes;
//    redraw(tryLogged: tryLogged);
//  }
//  dynamic attr(String key) {
//    return this._attributes[key];
//  }
//}
//main() {
//  tetrisBlocks();
//  //print(defaultMenu.template);
////  print(overview.template);
////
////  print(setupComposite.template);
//}