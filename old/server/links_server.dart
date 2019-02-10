//library tag_master.links_server;
//
//import "../server_libs/server/library.dart";
//import "../server_libs/shelf_web_socket/shelf_web_socket.dart" as web_socket;
//import "dart:io" as io;
//import "dart:convert" as convert;
//import "dart:async";
//import "../packages/tag_master/tag_master_common/library.dart";
//import "../packages/shelf/shelf.dart";
//
//Tags tags = new Tags();
//List<User> users = new List<User>();
//BlockMatrix blocks = new BlockMatrix();
//Map<User,Matrix> matrices=new Map<User,Matrix>();
//List sockets = [];
//
//
//
//
//void main(){
//  loadServer();
//
//  List <Map> jTags = convert.JSON.decode(new io.File("data/repo.json").readAsStringSync(encoding:convert.UTF8));
//  tags = new Tags()..fromJson(jTags);
//  tags.addIds();
//
//  List <Map> jUsers = convert.JSON.decode(new io.File("data/users.json").readAsStringSync(encoding:convert.UTF8));
//  for(Map juser in jUsers){
//    User user=new User()..fromJson(juser);
//    users.add(user);
//  }
//
//  blocks.createBlocks(tags);
//  List<Map> jusers=new List<Map>();
//
//
//
//  routeGet("/api/matrix", (RequestContext context){
//    if(context.data==""||context.data.length==0){
//      for(User user in users){
//        jusers.add(user.toJson());
//      }
//      context.write(convert.JSON.encode({"users":jusers,"blocks":blocks.toJson()}));
//    }else{
//      context.write(sendFullBlock(context.data));
//    }
//    context.close();
//  });
//
//  /*serveSocket(SOCKET_CONTROLLER, (Map incoming){
//    incoming["good"] = true;
////    print("juh");
//    sockets.forEach((s){
//      s.add(convert.JSON.encode(incoming));
//    });
//  },(dynamic socket){
//    sockets.add(socket);
//  });
//
//  new Timer.periodic(const Duration(seconds:5),(_){
//    sockets.forEach((s){
//      s.add('{"zprava":"Motivation message"}');
//    });
//  });*/
//
//  serve(9999);
//}
//Map<String,dynamic> sendFullBlock(Map<String,dynamic> data){
//  Map<String,dynamic> out={};
//  out["tags"]=tags.toJson();
//  if(data["block"]==null&&!data["block"] is List){return errorMsg("Wrong data[block]");}
//  Block block=blocks.getBlock(data["block"][0], data["block"][1]);
//  if(block==null){return errorMsg("Wrong block coordinates");}
//  User user=User.getUserById(data["user"]);
//  if(user==null){return errorMsg("Wrong user id");}
//  out["block"]=FullBlock.fullBlockToJson(block, matrices[user]);
//
//
//
//  return out;
//}
//Map<String,dynamic> errorMsg(String text){
//  return {"resp":text,"suc":false};
//}
