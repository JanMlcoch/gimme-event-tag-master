part of tag_master.tests;

void after_api(){

}







/*void after_api_old(){
  group("User PostAPI:",(){
    common.User user1;
    test("Elem seed",(){
      int seed=50;
      common.Entity.seed(seed);
      expect(common.Entity.getFreeId(),seed);
    });
    test("Admin permissions",(){
      expect(admin.checkPermission(common.MANAGE_OTHER_REPO),isTrue);
      expect(admin.checkPermission(common.MANAGE_OWN_REPO),isTrue);
      expect(admin.checkPermission(common.MANAGE_USERS),isTrue);
      expect(admin.checkPermission(common.SEE_REPO),isTrue);
      expect(admin.checkPermission(common.MANAGE_REPO),isTrue);
    });
    test("create user by updateUser()",(){
      Map res=server.updateUser({"login":"nikdo","pass":"aaa"},"create",null,admin);
      expect(res["resp"],"New user succesfully created");
    });
    test("create user with same login",(){
      Map res=server.updateUser({"login":"nikdo","pass":"aaa"},"create",null,admin);
      expect(res["resp"],"Selected login have already been used");
    });
    test("update on null user should fail",(){
      Map res=server.updateUser({"pass":"aaa"},"update",null,admin);
      expect(res["resp"],"Updated user does not exists");
    });
    test("User1 get by users.getuserByLogin()",(){
      user1=server.users.getUserByLogin("nikdo");
      expect(user1,isNotNull);
    });
    test("change user login (should fail)",(){
      Map res=server.updateUser({"login":"nikdo2"},"update",user1,admin);
      expect(res["resp"],"Cannot change login - it is forbidden");
    });
    test("change user login to same value",(){
      Map res=server.updateUser({"login":"nikdo"},"update",user1,admin);
      expect(res["resp"],"User updated successfully");
    });
    test("User1 permissions",(){
      expect(user1.checkPermission(common.MANAGE_OTHER_REPO),isFalse);
      expect(user1.checkPermission(common.MANAGE_OWN_REPO),isTrue);
      expect(user1.checkPermission(common.MANAGE_USERS),isFalse);
      expect(user1.checkPermission(common.SEE_REPO),isTrue);
      expect(user1.checkPermission(common.MANAGE_REPO),isFalse);
    });
    test("delete NULL user",(){
      Map res=server.updateUser(null,"delete",null,admin);
      expect(res["resp"],'User could not be deleted');
    });
    test("delete user nikdo",(){
      Map res=server.updateUser(null,"delete",user1,admin);
      expect(res["resp"],'User successfully deleted');
    });
    test("nikdo is deleted, should return null",(){
      user1=server.users.getUserByLogin("nikdo");
      expect(user1,isNull);
    });
    test("Unknown command",(){
      Map res=server.updateUser({"login":"nikdo","pass":"aaa"},"modify",user1,admin);
      expect(res["resp"],'Unknown command modify');
    });

  });
  group("Tags PostAPI",(){
    common.Repo repo = new common.Repo();
    common.Repo repo1;
    common.Tag tag1;
    test("ID as String",(){
      Map res=server.updateTag({"id":"1"},"modify",repo,admin);
      expect(res["resp"],'Tag ID have to be integer');
    });
    test("Unknown method",(){
      Map res=server.updateTag({"id":1},"modify",repo,admin);
      expect(res["resp"],'Unknown command modify');
    });
    test("Create Tag",(){
      Map res=server.updateTag({"id":1,"name":"pivo","type":common.CORE},"create",repo,admin);
      expect(res["resp"],'New default tag created');
    });
    test("Tags toJson()",(){
      Map<String,dynamic> json=repo.toJson();
      //print(json);
      List<Map> jtags=json["tags"];
      expect(jtags.length,1);
      Map<String,dynamic> jtag=jtags[0];
      tag1=repo.getTag(jtag["id"]);
      expect(tag1,isNotNull);
      expect(tag1.name,jtag["name"]);
    });
    test("Create Tag second",(){
      Map res=server.updateTag({"id":tag1.id,"name":"pivo","type":common.CORE},"create",repo,admin);
      expect(res["resp"],'Cannot create tag because it already exists');
    });
    test("Update Tag",(){
      Map res=server.updateTag({"id":tag1.id,"name":"pivo2","type":common.CORE},"update",repo,admin);
      expect(res["resp"],'Update of tag successful');
    });
    test("Update effects on tag",(){
      expect(tag1.name,"pivo2");
    });
    test("Update bogus Tag",(){
      Map res=server.updateTag({"id":3562,"name":"pivo2","type":common.CORE},"update",repo,admin);
      expect(res["resp"],'Tag ordered for modification does not exists');
    });
    test("Delete bogus Tag",(){
      Map res=server.updateTag({"id":3562,"name":"pivo2","type":common.CORE},"delete",repo,admin);
      expect(res["resp"],'Tag ordered for delete does not exists');
    });
    test("Delete Tag1",(){
      Map res=server.updateTag({"id":tag1.id},"delete",repo,admin);
      expect(res["resp"],'Tag successfully deleted');
    });
    test("Delete Tag1 again",(){
      Map res=server.updateTag({"id":tag1.id},"delete",repo,admin);
      expect(res["resp"],'Tag ordered for delete does not exists');
    });

  });

}*/