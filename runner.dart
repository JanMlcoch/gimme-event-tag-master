import "dart:io";
import "dart:convert";

main(){
  Directory.current = new Directory("nginx");

  Directory logs = new Directory("logs");
  File accessLog = new File("logs/access.log");
  File errorLog = new File("logs/error.log");
  if(!logs.existsSync()){
    logs.createSync();
    accessLog.createSync();
    errorLog.createSync();
  }else{
    if(accessLog.existsSync() && !errorLog.existsSync())
      errorLog.createSync();
    else if(!accessLog.existsSync() && errorLog.existsSync())
      accessLog.createSync();
    else{
      accessLog.createSync();
      errorLog.createSync();
    }
  }


  Process.start("nginx/nginx.exe", [], workingDirectory: "nginx").then((Process process){
    process.stdout
    .transform(UTF8.decoder)
    .listen((data){
      print("outNginx:" + data);
    });
    process.stderr
    .transform(UTF8.decoder)
    .listen((data){
      print("errorNginx:" + data);
    });
  });

  Directory.current = new Directory("../");

  Process.start("dart.exe",["--package-root=packages","server/main.dart"]).then((Process process){
    process.stdout
    .transform(UTF8.decoder)
    .listen((data){
      print("outServer:" + data);
    });
    process.stderr
    .transform(UTF8.decoder)
    .listen((data){
      print("errorServer:" + data);
    });
  });


  Process.start("dart.exe",["--package-root=packages","bin/resources_watcher.dart"]).then((Process process){
    process.stdout
    .transform(UTF8.decoder)
    .listen((data){
      print("outWatcher:" + data);
    });
    process.stderr
    .transform(UTF8.decoder)
    .listen((data){
      print("errorWatcher:" + data);
    });
  });



}