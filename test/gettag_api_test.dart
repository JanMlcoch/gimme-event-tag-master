part of tag_master.tests;




void get_tag_api(){

  common.User noob = new common.User.create(
      {"id": 5, "name": "Admin", "login": "admin", "permissions": []});
  group("Load files", (){
    test("number of loaded users", ()async {
      await server.readFiles();
      expect(server.users.length, 7);
    });
    test("number of loaded relations", (){
      expect(server.repo.getTags().length, 3);
    });
    test("number of loaded tags", (){
      expect(server.repo.getTags().length, 3);
    });
  });
  group("Tags API test", (){
    server_lib.RequestContext context =
    createContext({"extend": "blbost"}, "GET", admin);
    Map<String, dynamic> response;
    test("Elem seed", (){
      int seed = 50;
      common.Entity.seed(seed);
      expect(common.Entity.getFreeId(), seed);
    });
    test("Tags GET extend=blbost", (){
      response = server.tagsGet(context);
      expect(getFail(response), "Unknown extend value");
    });
    test("Tags GET not logged", (){
      context.logged = null;
      response = server.tagsGet(context);
      expect(getFail(response), "User have to be logged");
    });
    test("get full tags ", (){
      context
        ..data = {"extend": "full"}
        ..logged = admin;
      response = server.tagsGet(context);
      expect(response, server.repo.toJson());
    });
  });
  group("Tag GET API central", (){
    server_lib.RequestContext context =
    createContext({"extend": "blbost"}, "GET", admin);
    Map<String, dynamic> response;

    test("get central tag Thilisar", (){
      context
        ..data = {"id": "1", "user": "central"}
        ..logged = admin;
      response = server.tagGet(context);
      expect(response, server.repo.tagToJson(1));
    });
    test("with noob", (){
      context
        ..logged = noob;
      response = server.tagGet(context);
      expect(getFail(response), "Logged user cannot see tags");
    });
    test("with unparsable ID", (){
      context
        ..data = {"id":"ahoj", "user": "central"}
        ..logged = admin;
      response = server.tagGet(context);
      expect(getFail(response), "TagID have to be parsable integer");
    });
    test("with null ID", (){
      context
        ..data = {"id":"null", "user": "central"}
        ..logged = admin;
      response = server.tagGet(context);
      expect(getFail(response), "TagID have to be parsable integer");
    });

  });
  /*group("Tag GET API rest",(){
    server_lib.RequestContext context =
    createContext({"id": "1", "user": "2"}, "GET", admin);
    Map<String, dynamic> response;
    test("User not modified tag",(){
      response=server.tagGet(context);
      expect(getSuccess(response),"Selected user has not modified this tag");
    });

  });*/
}
