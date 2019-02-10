part of tag_master.tests;

int mountsToId(int source, int target) {
  return common.Relation.mountsToId(source, target);
}
Map<String, dynamic> sourceJsonExpanded = {
  "tags": [
    {"id": 5, "name": "pivo", "type": CORE},
    {"id": 6, "name": "Asonance", "type": CONCRETE},
    {"id": 8, "name": "soboty", "type": COMPOSITE},
    {"id": 9, "name": "festival", "type": CORE}
  ],
  "relas": [
    {"from": 5, "to": 6, "str": 0.1},
    {"from": 8, "to": 5, "str": 8},
    {"from": 8, "to": 6, "str": 0},
    {"from": 5, "to": 258, "str": 0.5},
    {"from": 5, "to": 6, "str": 0.75},
    {"from": 6, "to": 5, "str": 0.5},
    {"from": 5, "to": 5, "str": 0.5},
    {"from": 5, "to": 8, "str": 0.5}
  ]
};
Map<String, dynamic> sourceJson = {
  "tags": [
    {"id": 5, "name": "pivo", "type": CORE},
    {"id": 6, "name": "Asonance", "type": CONCRETE},
    {"id": 8, "name": "soboty", "type": COMPOSITE},
    {"id": 9, "name": "festival", "type": CORE}
  ],
  "relas": [
    {"from": 8, "to": 5, "str": 8},
    {"from": 5, "to": 6, "str": 0.75},
    {"from": 6, "to": 5, "str": 0.5}
  ]
};
common.User admin = new common.User.create({
  "id": 5,
  "name": "Admin",
  "login": "admin",
  "permissions": [
    common.MANAGE_OTHER_REPO,
    common.MANAGE_OWN_REPO,
    common.MANAGE_USERS,
    common.SEE_REPO,
    common.MANAGE_REPO
  ]
});
common.User noob = new common.User.create(
    {"id": 5, "name": "Admin", "login": "admin", "permissions": []});

server_lib.RequestContext createContext(
    Object data, String method, common.User logged) {
  server_lib.RequestContext context = new server_lib.RequestContext();
  context
    ..data = data
    ..logged = logged
    ..method = method
    ..container = new server.TagMasterContainer(context);
  return context;
}
server.TagMasterContainer getContainer(server_lib.RequestContext context) {
  return context.container;
}
String getSuccess(Object obj) {
  expect(obj, isMap);
  Map map = obj;
  expect(map["suc"], isTrue);
  return map["resp"];
}
String getFail(Object obj) {
  expect(obj, isMap);
  Map map = obj;
  expect(map["suc"], isFalse);
  return map["resp"];
}
const int CORE = 5;
const int CONCRETE = 4;
const int COMPOSITE = 3;
const int COMMON = 2;
const int COMPARABLE = 1;
