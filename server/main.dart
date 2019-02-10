library tag_master.server;

import '../server_libs/server/library.dart';
//import 'package:tag_master/tag_master_common/library.dart';
import '../lib/tag_master_common/library.dart';
import "dart:convert";
import "dart:async";
import "dart:math" as Math;
import "package:postgresql/postgresql.dart";
import "dart:io" as Io;

part 'tag_master.dart';
part 'user_master.dart';
part 'container.dart';

const String REPO_FILE = "data/repo2.json";
const String USER_FILE = "data/users.json";
const String DATABASE = 'postgres://akcnik.thilisar.cz:brMO4i5mblfVcm@sql3.pipni.cz:5432/akcnik.thilisar.cz';

typedef Map DHandler(RequestContext context);
//Tags tags = new Tags();
Repo repo = new Repo();
Users users = new Users();

bool modelChanged = false;
DateTime lastChangeTime;
String instanceId;

void main(){
  lastChangeTime = new DateTime.now();
  instanceId = new Math.Random().nextDouble().toString();
  //tests.main();
  loadServer();
  route(TAG_TYPE_API, (RequestContext context){
    context.write(JSON.encode({
      "CORE": Tag.CORE,
      "CONCRETE": Tag.CONCRETE,
      "COMPOSITE": Tag.COMPOSITE,
      "COMMON": Tag.COMMON,
      "COMPARABLE": Tag.COMPARABLE
    }));
    context.close();
  });
  loadUserMaster(users);
  loadTagMaster(repo, users);
  route("/api/reset", (RequestContext context){
    readFiles().then((_){
      context.write(resOut("Data reseted", true));
      context.close();
    });
  }, method: "POST");
  route("/api/tests", routeHandler(runTests), method: "POST");

  serve(9999);
  checkDataLock().then((bool locked){
    readDatabase().then((_){
      print("read files finished");
      print(users.toJson());
      print(repo.toJson());
    });
  });

  /*Timer saver = */
  new Timer.periodic(new Duration(seconds: 5), persist);
}

Future<bool> checkDataLock()async{
  if(new DateTime.now().difference(lastChangeTime).inMinutes>10){
    print("timeout");
    Io.exit(0);
  }


  Completer completer = new Completer();
  var connection = await connect(DATABASE);

  List<Row> rows = await connection.query("""
      select * from "tag_master_repository_lock" order by time desc limit 1
    """).toList();

  Map record = rows.first.toMap();
  DateTime time = record["time"];
  Map settings = JSON.decode(record["settings"]);
  String id = settings["instanceId"];

  if(id == instanceId){
    completer.complete(false);
    return completer.future;
  }

  Duration delta =  new DateTime.now().difference(time);

  if(delta.inMinutes<3){
    // is locked
    print("database is locked");
    Io.exit(0);
  }

  connection.execute("""
    insert into "tag_master_repository_lock" (settings)
     values (@settings)
    """,{
    "settings": JSON.encode({
      "instanceId": instanceId
    })
  });

  new Future.delayed(const Duration(seconds: 181)).then((_){
    checkDataLock();
  });
  await completer.complete();
  return completer.future;
}

Map<String, dynamic> runTests(RequestContext context){
  return {};
}

Function routeHandler(DHandler handler){
  return (RequestContext context){
    if(context.userId != null){
      User logged = users[context.userId];
      if(logged == null){
        return context.respond("Cannot found logged user", false);
      }
      context.logged = logged;
    }
    context.container = new TagMasterContainer(context);
    Map<String, dynamic> res = handler(context);
    if(res != null){
      context
        ..write(res)
        ..close();
    }
    if(!context.closed){
      throw new StateError("Request OUT stream is not validly closed");
      context.respond("No proper closer", false);
    }
  };
}

Future readDatabase()async {
  Completer out = new Completer();
  var connection = await connect(DATABASE);

  Future<List> selectUsers()async{
    List rows = await connection.query("""
      select * from "user"
    """).toList();
    List out = [];
    for(Row row in rows){
      Map user = row.toMap();
      user["permissions"] = JSON.decode(user["permissions"]);
      out.add(user);
    }
    users.fromJson(out);
    return out;
  }

  Future<Map> getRepository()async{
    List<Row> rows = await connection.query("""
      select * from "tag_master_repository" order by version desc limit 1
    """).toList();
    Map<String, dynamic> json = JSON.decode(rows.first.toMap()["repository"]);
    repo.fromJson(json);
    return rows.first.toMap();
  }

  Future.wait([
    getRepository(),
    selectUsers()
  ]).then((_){
    out.complete();
  });
  return out.future;
}

Future readFiles(){
  return Future
  .wait([readFile(REPO_FILE), readFile(USER_FILE)])
  .then((List<String> responses){
    Map<String, dynamic> json = JSON.decode(responses[0]);
    repo.fromJson(json);
    List<Map> jusers = JSON.decode(responses[1]);
    users.fromJson(jusers);
    //print(repo.toJson());
    //print(users.toJson());
  });
}

Future persist(Timer t)async {
  if(modelChanged){
    saveFile(USER_FILE, users.toJson(), suffix:"_new.json");
    saveFile(REPO_FILE, repo.toJson(), suffix:"_new.json");
    modelChanged = false;

    var connection = await connect(DATABASE);

    int version = (await connection.query("""
      select max("version") from "tag_master_repository"
    """).toList()).first.toList().first;

    connection.execute("""
      insert into "tag_master_repository" (repository, version) values (@repository, @version)
    """, {
      "repository": JSON.encode(repo.toJson()),
      "version": ++version
    }).then((int result){
      print("inserted successfully");
    }).catchError((error){
      print(error);
    });
  }
}

String methodToCommand(String method){
  if(method == "POST"){
    return "create";
  }
  if(method == "PUT"){
    return "update";
  }
  if(method == "DELETE"){
    return "delete";
  }
  return method;
}
