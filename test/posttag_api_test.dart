part of tag_master.tests;

void post_tag_api() {
  const String method = "POST";
  server_lib.RequestContext createContextWrapTagAndValidate(
      Map<String, dynamic> data, common.User logged) {
    server_lib.RequestContext context = createContext(data, method, logged);
    getContainer(context)
      ..wrapTag()
      ..validate();
    return context;
  }
  server_lib.RequestContext createContextWrapRelationAndValidate(
      Map<String, dynamic> data, common.User logged) {
    server_lib.RequestContext context = createContext(data, method, logged);
    getContainer(context)
      ..wrapRelation()
      ..validate();
    return context;
  }

  common.Repo repo = server.repo;
  // START OF TESTS
  group("Wraps", () {
    server_lib.RequestContext context;
    test("Load repo", () {
      repo.fromJson(sourceJson);
      expect(repo.getTags().length, 4);
      expect(repo.getRelations().length, 3);
    });
    test("created context have container", () {
      context = createContext(null, method, admin);
      expect(context.container, isNotNull);
      expect(context.container is server.TagMasterContainer, isTrue);
    });
    test("WrapTag null", () {
      getContainer(context).wrapTag();
      expect(context.message, "Tag data is not Map");
    });
    test("WrapRelation null", () {
      context = createContext(null, method, admin);
      getContainer(context).wrapRelation();
      expect(context.message, "Relation data is not Map");
    });
    test("WrapRelations null", () {
      context = createContext(null, method, admin);
      getContainer(context).wrapRelations();
      expect(context.message, "Relations data is not List");
    });
    test("WrapTags null", () {
      context = createContext(null, method, admin);
      getContainer(context).wrapTags();
      expect(context.message, "Tags data is not List");
    });
    test("WrapUser null", () {
      context = createContext(null, method, admin);
      getContainer(context).wrapUser();
      expect(context.message, "User data is not Map");
    });
    test("WrapUsers null", () {
      context = createContext(null, method, admin);
      getContainer(context).wrapUsers();
      expect(context.message, "Users data is not List");
    });
    test("Wrap null", () {
      context = createContext(null, method, admin);
      getContainer(context).wrap();
      expect(context.message, 'JSON data is not Map');
    });
    test("Wrap with empty Map", () {
      context = createContext({}, method, admin);
      getContainer(context).wrap();
      expect(context.message, '');
    });
    test("Wrap with wrong tags type", () {
      context = createContext({"tags": 5}, method, admin);
      getContainer(context).wrap();
      expect(context.message, 'Tags data is not List');
    });
    test("Wrap with wrong relations type", () {
      context = createContext({"relations": 5}, method, admin);
      getContainer(context).wrap();
      expect(context.message, 'Relations data is not List');
    });
    test("Wrap with users List", () {
      context = createContext({"users": []}, method, admin);
      getContainer(context).wrap();
      expect(context.message,
          'Users data cannot be loaded through universal wrap');
    });
    test("Wrap common tag", () {
      context =
          createContext({"name": "les", "type": CORE}, method, admin);
      getContainer(context)..wrapTag();
      Map map = getContainer(context).toJson();
      expect(map, {
        "tags": [{"name": "les", "type": CORE}],
        "relations": [],
        "users": []
      });
    });
  });
  group("validate POST tags", () {
    server_lib.RequestContext context;
    Map tag1 = {};
    test("validate with failed wrap", () {
      context = createContext(null, method, admin);
      getContainer(context)
        ..wrap()
        ..validate();
      expect(context.message, 'JSON data is not Map');
    });
    test("validate with empty tags", () {
      context = createContext({"tags": []}, method, admin);
      getContainer(context)
        ..wrap()
        ..validate();
      expect(context.message, '');
      expect(context.success, isTrue);
    });
    test("validate empty tag", () {
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          '{} should contain "name" and should contain "type"');
    });
    test("validate tag with name and type", () {
      tag1 = {"name": "les", "type": CORE};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message, '');
      expect(context.success, isTrue);
    });
    test("validate tag with name and type and ID", () {
      tag1 = {"id": 5, "name": "les", "type": CORE};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.success, isFalse);
    });
    test("validate tag with relations", () {
      tag1 = {
        "name": "les",
        "type": CORE,
        "relas_src": [{"to": 5, "str": 0.5}]
      };
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message, '');
    });
    test("validate tag with relations with forbidden from", () {
      tag1 = {
        "name": "les",
        "type": CORE,
        "relas_src": [{"from": 5, "to": 5, "str": 0.5}]
      };
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          '{from: 5, to: 5, str: 0.5} should not contain "from"');
    });
    test("validate tag with relations with unknown to", () {
      tag1 = {
        "name": "les",
        "type": CORE,
        "relas_src": [{"to": 525, "str": 0.5}]
      };
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          'Relation ${mountsToId(-1,525)} should lead to valid Tag');
    });
    test("validate noob", () {
      tag1 = {
        "name": "les",
        "type": CORE,
        "relas_src": [{"to": 525, "str": 0.5}]
      };
      context = createContextWrapTagAndValidate(tag1, noob);
      expect(context.message,
          'Logged user cannot create tags or relations in central repository');
    });
  });
  group("validate POST relations", () {
    server_lib.RequestContext context;
    Map rela1 = {};
    test("validate with failed wrap", () {
      context = createContextWrapRelationAndValidate(null, admin);
      expect(context.message, 'Relation data is not Map');
    });
    test("validate with empty Map", () {
      context = createContextWrapRelationAndValidate(rela1, admin);
      expect(context.message,
          '{} should contain "from" and should contain "to" and should contain "str"');
    });
    test("validate with already existing relation", () {
      rela1 = {"from": 5, "to": 6, "str": 0.2};
      context = createContextWrapRelationAndValidate(rela1, admin);
      expect(context.message, 'Relation ${mountsToId(5,6)} already exists');
    });
    test("validate with correct relation", () {
      rela1 = {"from": 9, "to": 6, "str": 0.2};
      context = createContextWrapRelationAndValidate(rela1, admin);
      expect(context.message, '');
      expect(context.success, isTrue);
    });
    test("relation without from", () {
      rela1 = {"to": 6, "str": 0.2};
      context = createContextWrapRelationAndValidate(rela1, admin);
      expect(context.message, '{to: 6, str: 0.2} should contain "from"');
    });
    test("validate with noob", () {
      rela1 = {"from": 9, "to": 6, "str": 0.2};
      context = createContextWrapRelationAndValidate(rela1, noob);
      expect(context.message,
          'Logged user cannot create tags or relations in central repository');
    });
  });
  /*test("validate noob with users",(){
    Map user1=noob.toJson();
    context=createContext(user1,method,noob);
    getContainer(context)..wrapUser()..validate();
    expect(context.message,'Logged user cannot create me');
  });*/

}
