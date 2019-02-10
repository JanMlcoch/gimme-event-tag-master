part of tag_master_common;
class Xr1addTag{
String header; 
String name; 
String type; 
String add; 
Map toJson(){
Map out = {};
out['header'] = header;
out['name'] = name;
out['type'] = type;
out['add'] = add;

return out;
}
void fromJson(Map json){
header = json['header']; 
name = json['name']; 
type = json['type']; 
add = json['add']; 
}
}

class Xr2login{
String loginTitle; 
String loginText; 
String passText; 
String submitText; 
Map toJson(){
Map out = {};
out['loginTitle'] = loginTitle;
out['loginText'] = loginText;
out['passText'] = passText;
out['submitText'] = submitText;

return out;
}
void fromJson(Map json){
loginTitle = json['loginTitle']; 
loginText = json['loginText']; 
passText = json['passText']; 
submitText = json['submitText']; 
}
}

class Xr3wait{
String waitForServer; 
Map toJson(){
Map out = {};
out['waitForServer'] = waitForServer;

return out;
}
void fromJson(Map json){
waitForServer = json['waitForServer']; 
}
}

class Xr4acceptError{
String acceptErrorSauce; 
Map toJson(){
Map out = {};
out['acceptErrorSauce'] = acceptErrorSauce;

return out;
}
void fromJson(Map json){
acceptErrorSauce = json['acceptErrorSauce']; 
}
}

class Xr5defaultMenu{
String buttonToHomeSauce; 
String buttonToOverviewSauce; 
String addTagSauce; 
String backSauce; 
String loginSauce; 
String logoutSauce; 
String relogSauce; 
String editProfile; 
String exportJson; 
Map toJson(){
Map out = {};
out['buttonToHomeSauce'] = buttonToHomeSauce;
out['buttonToOverviewSauce'] = buttonToOverviewSauce;
out['addTagSauce'] = addTagSauce;
out['backSauce'] = backSauce;
out['loginSauce'] = loginSauce;
out['logoutSauce'] = logoutSauce;
out['relogSauce'] = relogSauce;
out['editProfile'] = editProfile;
out['exportJson'] = exportJson;

return out;
}
void fromJson(Map json){
buttonToHomeSauce = json['buttonToHomeSauce']; 
buttonToOverviewSauce = json['buttonToOverviewSauce']; 
addTagSauce = json['addTagSauce']; 
backSauce = json['backSauce']; 
loginSauce = json['loginSauce']; 
logoutSauce = json['logoutSauce']; 
relogSauce = json['relogSauce']; 
editProfile = json['editProfile']; 
exportJson = json['exportJson']; 
}
}

class Xr6errors{
String lostInNavigation; 
Map toJson(){
Map out = {};
out['lostInNavigation'] = lostInNavigation;

return out;
}
void fromJson(Map json){
lostInNavigation = json['lostInNavigation']; 
}
}

class Xr7welcome{
String welcomeSauce; 
Map toJson(){
Map out = {};
out['welcomeSauce'] = welcomeSauce;

return out;
}
void fromJson(Map json){
welcomeSauce = json['welcomeSauce']; 
}
}

class Xr8overview{
String viewTagSauce; 
String name; 
String id; 
String type; 
String addFilter; 
Map toJson(){
Map out = {};
out['viewTagSauce'] = viewTagSauce;
out['name'] = name;
out['id'] = id;
out['type'] = type;
out['addFilter'] = addFilter;

return out;
}
void fromJson(Map json){
viewTagSauce = json['viewTagSauce']; 
name = json['name']; 
id = json['id']; 
type = json['type']; 
addFilter = json['addFilter']; 
}
}

class Xr9viewTag{
String tagIdSauce; 
String tagNameSauce; 
String tagTypeSauce; 
String relationsFromSauce; 
String relationsToSauce; 
String relationStrengthSauce; 
String relationIdSauce; 
String editTagSauce; 
Map toJson(){
Map out = {};
out['tagIdSauce'] = tagIdSauce;
out['tagNameSauce'] = tagNameSauce;
out['tagTypeSauce'] = tagTypeSauce;
out['relationsFromSauce'] = relationsFromSauce;
out['relationsToSauce'] = relationsToSauce;
out['relationStrengthSauce'] = relationStrengthSauce;
out['relationIdSauce'] = relationIdSauce;
out['editTagSauce'] = editTagSauce;

return out;
}
void fromJson(Map json){
tagIdSauce = json['tagIdSauce']; 
tagNameSauce = json['tagNameSauce']; 
tagTypeSauce = json['tagTypeSauce']; 
relationsFromSauce = json['relationsFromSauce']; 
relationsToSauce = json['relationsToSauce']; 
relationStrengthSauce = json['relationStrengthSauce']; 
relationIdSauce = json['relationIdSauce']; 
editTagSauce = json['editTagSauce']; 
}
}

class Xr10editTag{
String tagIdSauce; 
String tagNameSauce; 
String tagTypeSauce; 
String relationsFromSauce; 
String relationsToSauce; 
String relationStrengthSauce; 
String relationIdSauce; 
String editTagSauce; 
String addRelationSauce; 
String ChangeTagTypeSauce; 
String submitChangesToTagSauce; 
String to; 
String typ5; 
String typ4; 
String typ3; 
String typ2; 
String typ1; 
String noValidTarget; 
String tooManySynTargets; 
String notEnoughSynTargets; 
Map toJson(){
Map out = {};
out['tagIdSauce'] = tagIdSauce;
out['tagNameSauce'] = tagNameSauce;
out['tagTypeSauce'] = tagTypeSauce;
out['relationsFromSauce'] = relationsFromSauce;
out['relationsToSauce'] = relationsToSauce;
out['relationStrengthSauce'] = relationStrengthSauce;
out['relationIdSauce'] = relationIdSauce;
out['editTagSauce'] = editTagSauce;
out['addRelationSauce'] = addRelationSauce;
out['ChangeTagTypeSauce'] = ChangeTagTypeSauce;
out['submitChangesToTagSauce'] = submitChangesToTagSauce;
out['to'] = to;
out['typ5'] = typ5;
out['typ4'] = typ4;
out['typ3'] = typ3;
out['typ2'] = typ2;
out['typ1'] = typ1;
out['noValidTarget'] = noValidTarget;
out['tooManySynTargets'] = tooManySynTargets;
out['notEnoughSynTargets'] = notEnoughSynTargets;

return out;
}
void fromJson(Map json){
tagIdSauce = json['tagIdSauce']; 
tagNameSauce = json['tagNameSauce']; 
tagTypeSauce = json['tagTypeSauce']; 
relationsFromSauce = json['relationsFromSauce']; 
relationsToSauce = json['relationsToSauce']; 
relationStrengthSauce = json['relationStrengthSauce']; 
relationIdSauce = json['relationIdSauce']; 
editTagSauce = json['editTagSauce']; 
addRelationSauce = json['addRelationSauce']; 
ChangeTagTypeSauce = json['ChangeTagTypeSauce']; 
submitChangesToTagSauce = json['submitChangesToTagSauce']; 
to = json['to']; 
typ5 = json['typ5']; 
typ4 = json['typ4']; 
typ3 = json['typ3']; 
typ2 = json['typ2']; 
typ1 = json['typ1']; 
noValidTarget = json['noValidTarget']; 
tooManySynTargets = json['tooManySynTargets']; 
notEnoughSynTargets = json['notEnoughSynTargets']; 
}
}

class Xr11relationTableRow{
String restore; 
String remove; 
String tbd; 
String typ5; 
String typ4; 
String typ3; 
String typ2; 
String typ1; 
Map toJson(){
Map out = {};
out['restore'] = restore;
out['remove'] = remove;
out['tbd'] = tbd;
out['typ5'] = typ5;
out['typ4'] = typ4;
out['typ3'] = typ3;
out['typ2'] = typ2;
out['typ1'] = typ1;

return out;
}
void fromJson(Map json){
restore = json['restore']; 
remove = json['remove']; 
tbd = json['tbd']; 
typ5 = json['typ5']; 
typ4 = json['typ4']; 
typ3 = json['typ3']; 
typ2 = json['typ2']; 
typ1 = json['typ1']; 
}
}

class Xr12filters{
String submit; 
String subStringSauce; 
String typ5; 
String typ4; 
String typ3; 
String typ2; 
String typ1; 
Map toJson(){
Map out = {};
out['submit'] = submit;
out['subStringSauce'] = subStringSauce;
out['typ5'] = typ5;
out['typ4'] = typ4;
out['typ3'] = typ3;
out['typ2'] = typ2;
out['typ1'] = typ1;

return out;
}
void fromJson(Map json){
submit = json['submit']; 
subStringSauce = json['subStringSauce']; 
typ5 = json['typ5']; 
typ4 = json['typ4']; 
typ3 = json['typ3']; 
typ2 = json['typ2']; 
typ1 = json['typ1']; 
}
}

class Xr13SSTag{
Map toJson(){
Map out = {};

return out;
}
void fromJson(Map json){
}
}

class Xr14SmartOptionList{
Map toJson(){
Map out = {};

return out;
}
void fromJson(Map json){
}
}

class Xr0lang_cz{
List tagTypes; 
Xr1addTag addTag; 
Xr2login login; 
Xr3wait wait; 
Xr4acceptError acceptError; 
Xr5defaultMenu defaultMenu; 
Xr6errors errors; 
Xr7welcome welcome; 
Xr8overview overview; 
Xr9viewTag viewTag; 
Xr10editTag editTag; 
Xr11relationTableRow relationTableRow; 
Xr12filters filters; 
Xr13SSTag SSTag; 
Xr14SmartOptionList SmartOptionList; 
String invalidRelation; 
String coreSauce; 
String loginName; 
String notReadySauce; 
String concreteSauce; 
String compositeSauce; 
String commonSauce; 
String comparableSauce; 
String typ5; 
String typ4; 
String typ3; 
String typ2; 
String typ1; 
String chooseTagTypeSauce; 
String chooseSynonymTargetSauce; 
String tagName; 
String compoCompoRedirSauce; 
String chooseCompositeTargetSauce; 
String relTarget; 
String willBe; 
String moreStatesError; 
Map toJson(){
Map out = {};
out['tagTypes'] = tagTypes;
out['addTag'] = addTag.toJson();
out['login'] = login.toJson();
out['wait'] = wait.toJson();
out['acceptError'] = acceptError.toJson();
out['defaultMenu'] = defaultMenu.toJson();
out['errors'] = errors.toJson();
out['welcome'] = welcome.toJson();
out['overview'] = overview.toJson();
out['viewTag'] = viewTag.toJson();
out['editTag'] = editTag.toJson();
out['relationTableRow'] = relationTableRow.toJson();
out['filters'] = filters.toJson();
out['SSTag'] = SSTag.toJson();
out['SmartOptionList'] = SmartOptionList.toJson();
out['invalidRelation'] = invalidRelation;
out['coreSauce'] = coreSauce;
out['loginName'] = loginName;
out['notReadySauce'] = notReadySauce;
out['concreteSauce'] = concreteSauce;
out['compositeSauce'] = compositeSauce;
out['commonSauce'] = commonSauce;
out['comparableSauce'] = comparableSauce;
out['typ5'] = typ5;
out['typ4'] = typ4;
out['typ3'] = typ3;
out['typ2'] = typ2;
out['typ1'] = typ1;
out['chooseTagTypeSauce'] = chooseTagTypeSauce;
out['chooseSynonymTargetSauce'] = chooseSynonymTargetSauce;
out['tagName'] = tagName;
out['compoCompoRedirSauce'] = compoCompoRedirSauce;
out['chooseCompositeTargetSauce'] = chooseCompositeTargetSauce;
out['relTarget'] = relTarget;
out['willBe'] = willBe;
out['moreStatesError'] = moreStatesError;

return out;
}
void fromJson(Map json){
tagTypes = json['tagTypes']; 
addTag = new Xr1addTag()..fromJson(json['addTag']); 
login = new Xr2login()..fromJson(json['login']); 
wait = new Xr3wait()..fromJson(json['wait']); 
acceptError = new Xr4acceptError()..fromJson(json['acceptError']); 
defaultMenu = new Xr5defaultMenu()..fromJson(json['defaultMenu']); 
errors = new Xr6errors()..fromJson(json['errors']); 
welcome = new Xr7welcome()..fromJson(json['welcome']); 
overview = new Xr8overview()..fromJson(json['overview']); 
viewTag = new Xr9viewTag()..fromJson(json['viewTag']); 
editTag = new Xr10editTag()..fromJson(json['editTag']); 
relationTableRow = new Xr11relationTableRow()..fromJson(json['relationTableRow']); 
filters = new Xr12filters()..fromJson(json['filters']); 
SSTag = new Xr13SSTag()..fromJson(json['SSTag']); 
SmartOptionList = new Xr14SmartOptionList()..fromJson(json['SmartOptionList']); 
invalidRelation = json['invalidRelation']; 
coreSauce = json['coreSauce']; 
loginName = json['loginName']; 
notReadySauce = json['notReadySauce']; 
concreteSauce = json['concreteSauce']; 
compositeSauce = json['compositeSauce']; 
commonSauce = json['commonSauce']; 
comparableSauce = json['comparableSauce']; 
typ5 = json['typ5']; 
typ4 = json['typ4']; 
typ3 = json['typ3']; 
typ2 = json['typ2']; 
typ1 = json['typ1']; 
chooseTagTypeSauce = json['chooseTagTypeSauce']; 
chooseSynonymTargetSauce = json['chooseSynonymTargetSauce']; 
tagName = json['tagName']; 
compoCompoRedirSauce = json['compoCompoRedirSauce']; 
chooseCompositeTargetSauce = json['chooseCompositeTargetSauce']; 
relTarget = json['relTarget']; 
willBe = json['willBe']; 
moreStatesError = json['moreStatesError']; 
}
}

class Xr15small_templates{
String loginName; 
String buttonToOverview; 
String buttonToHome; 
String acceptError; 
String buttonLogout; 
Map toJson(){
Map out = {};
out['loginName'] = loginName;
out['buttonToOverview'] = buttonToOverview;
out['buttonToHome'] = buttonToHome;
out['acceptError'] = acceptError;
out['buttonLogout'] = buttonLogout;

return out;
}
void fromJson(Map json){
loginName = json['loginName']; 
buttonToOverview = json['buttonToOverview']; 
buttonToHome = json['buttonToHome']; 
acceptError = json['acceptError']; 
buttonLogout = json['buttonLogout']; 
}
}

class Xr16templates{
String accept_error; 
String add_tag; 
String choose_new_tag_type; 
String default_menu; 
String default_menu_tetrised; 
String edit_tag; 
String edit_tag_optgroup; 
String edti_tag_v2; 
String filtered_overview; 
String login; 
String new_relation_table_row_from_old; 
String new_relation_table_row_to_old; 
String original_relation_table_row_from; 
String original_relation_table_row_to; 
String overview; 
String overview_with_color; 
String platform; 
String relation_table_row1; 
String relation_table_row1_backup; 
String rel_row; 
String setup_composite; 
String setup_custom; 
String setup_synonym; 
String smart_option_list; 
String smart_select_tag; 
String subcontent; 
String targeted_relation_in_tr; 
String view_tag; 
String wait; 
String welcome; 
Map toJson(){
Map out = {};
out['accept_error'] = accept_error;
out['add_tag'] = add_tag;
out['choose_new_tag_type'] = choose_new_tag_type;
out['default_menu'] = default_menu;
out['default_menu_tetrised'] = default_menu_tetrised;
out['edit_tag'] = edit_tag;
out['edit_tag_optgroup'] = edit_tag_optgroup;
out['edti_tag_v2'] = edti_tag_v2;
out['filtered_overview'] = filtered_overview;
out['login'] = login;
out['new_relation_table_row_from_old'] = new_relation_table_row_from_old;
out['new_relation_table_row_to_old'] = new_relation_table_row_to_old;
out['original_relation_table_row_from'] = original_relation_table_row_from;
out['original_relation_table_row_to'] = original_relation_table_row_to;
out['overview'] = overview;
out['overview_with_color'] = overview_with_color;
out['platform'] = platform;
out['relation_table_row1'] = relation_table_row1;
out['relation_table_row1_backup'] = relation_table_row1_backup;
out['rel_row'] = rel_row;
out['setup_composite'] = setup_composite;
out['setup_custom'] = setup_custom;
out['setup_synonym'] = setup_synonym;
out['smart_option_list'] = smart_option_list;
out['smart_select_tag'] = smart_select_tag;
out['subcontent'] = subcontent;
out['targeted_relation_in_tr'] = targeted_relation_in_tr;
out['view_tag'] = view_tag;
out['wait'] = wait;
out['welcome'] = welcome;

return out;
}
void fromJson(Map json){
accept_error = json['accept_error']; 
add_tag = json['add_tag']; 
choose_new_tag_type = json['choose_new_tag_type']; 
default_menu = json['default_menu']; 
default_menu_tetrised = json['default_menu_tetrised']; 
edit_tag = json['edit_tag']; 
edit_tag_optgroup = json['edit_tag_optgroup']; 
edti_tag_v2 = json['edti_tag_v2']; 
filtered_overview = json['filtered_overview']; 
login = json['login']; 
new_relation_table_row_from_old = json['new_relation_table_row_from_old']; 
new_relation_table_row_to_old = json['new_relation_table_row_to_old']; 
original_relation_table_row_from = json['original_relation_table_row_from']; 
original_relation_table_row_to = json['original_relation_table_row_to']; 
overview = json['overview']; 
overview_with_color = json['overview_with_color']; 
platform = json['platform']; 
relation_table_row1 = json['relation_table_row1']; 
relation_table_row1_backup = json['relation_table_row1_backup']; 
rel_row = json['rel_row']; 
setup_composite = json['setup_composite']; 
setup_custom = json['setup_custom']; 
setup_synonym = json['setup_synonym']; 
smart_option_list = json['smart_option_list']; 
smart_select_tag = json['smart_select_tag']; 
subcontent = json['subcontent']; 
targeted_relation_in_tr = json['targeted_relation_in_tr']; 
view_tag = json['view_tag']; 
wait = json['wait']; 
welcome = json['welcome']; 
}
}

class GeneratedResources{
String default_menu; 
String handle_login; 
Xr0lang_cz lang_cz; 
String login; 
Xr15small_templates small_templates; 
Xr16templates templates; 
Map toJson(){
Map out = {};
out['default_menu'] = default_menu;
out['handle_login'] = handle_login;
out['lang_cz'] = lang_cz.toJson();
out['login'] = login;
out['small_templates'] = small_templates.toJson();
out['templates'] = templates.toJson();

return out;
}
void fromJson(Map json){
default_menu = json['default_menu']; 
handle_login = json['handle_login']; 
lang_cz = new Xr0lang_cz()..fromJson(json['lang_cz']); 
login = json['login']; 
small_templates = new Xr15small_templates()..fromJson(json['small_templates']); 
templates = new Xr16templates()..fromJson(json['templates']); 
}
}

