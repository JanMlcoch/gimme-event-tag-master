part of tag_master.tests;

void put_tag_api() {
  const String method = "PUT";

  server_lib.RequestContext createContextWrapTagAndValidate(
      Object data, common.User logged) {
    server_lib.RequestContext context = createContext(data, method, logged);
    getContainer(context)
      ..wrapTag()
      ..validate();
    return context;
  }
  server_lib.RequestContext createContextWrapRelationAndValidate(
      Object data, common.User logged) {
    server_lib.RequestContext context = createContext(data, method, logged);
    getContainer(context)
      ..wrapRelation()
      ..validate();
    return context;
  }
  server_lib.RequestContext createContextWrapTagValidateAndExecute(
      Object data, common.User logged) {
    server_lib.RequestContext context = createContext(data, method, logged);
    getContainer(context)
      ..wrapTag()
      ..validate()
      ..execute();
    return context;
  }
  server_lib.RequestContext createContextWrapRelationValidateAndExecute(
      Object data, common.User logged) {
    server_lib.RequestContext context = createContext(data, method, logged);
    getContainer(context)
      ..wrapRelation()
      ..validate()
      ..execute();
    return context;
  }
  server_lib.RequestContext createContextWrapRelationsValidateAndExecute(
      Object data, common.User logged) {
    server_lib.RequestContext context = createContext(data, method, logged);
    getContainer(context)
      ..wrapRelations()
      ..validate()
      ..execute();
    return context;
  }
  server_lib.RequestContext createContextWrapValidateAndExecute(
      Object data, common.User logged) {
    server_lib.RequestContext context = createContext(data, method, logged);
    getContainer(context)
      ..wrap()
      ..validate()
      ..execute();
    return context;
  }
  common.Repo repo = server.repo;

  // START OF TESTS
  group("tags PUT validation", () {
    server_lib.RequestContext context;
    Map tag1;
    test("Load repo", () {
      repo.fromJson(sourceJson);
      expect(repo.getTags().length, 4);
      expect(repo.getRelations().length, 3);
    });
    test("WrapTag null", () {
      context = createContext(null, method, admin);
      getContainer(context).wrapTag();
      expect(context.message, "Tag data is not Map");
    });
    test("validate with failed wrapTag", () {
      context = createContextWrapTagAndValidate(null, admin);
      expect(context.message, 'Tag data is not Map');
    });
    test("validate tag with name and type", () {
      tag1 = {"name": "les", "type": CORE};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message, '{name: les, type: 5} should contain "id"');
    });
    test("validate tag with wrong id", () {
      tag1 = {"id": 256};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message, 'Tag with ID=256 is not found');
    });
    test("validate tag with right id", () {
      tag1 = {"id": 9};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message, '');
    });
    test("validate tag with noob", () {
      tag1 = {"id": 9};
      context = createContextWrapTagAndValidate(tag1, noob);
      expect(context.message,
          'Logged user cannot update tags or relations in central repository');
    });
    test("validate tag with string type", () {
      tag1 = {"id": 9, "type": "ahoj"};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          '{id: 9, type: ahoj} "type" parameter should be int');
    });
    test("validate tag with string type", () {
      tag1 = {"id": 9, "type": "ahoj"};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          '{id: 9, type: ahoj} "type" parameter should be int');
    });
    test("validate tag with relations", () {
      tag1 = {"id": 9, "relas_src": [{"to": 5, "str": 0.5}]};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          '{id: 9, relas_src: [{to: 5, str: 0.5}]} should not contain "relas_src"');
    });
    test("validate tag with relation with forbidden from", () {
      tag1 = {"id": 9, "relas_src": [{"from": 6, "to": 5, "str": 0.5}]};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          '{id: 9, relas_src: [{from: 6, to: 5, str: 0.5}]} should not contain "relas_src"');
    });
    test("validate tag with relation with unknown to", () {
      tag1 = {"id": 9, "relas_src": [{"to": 256, "str": 0.5}]};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          '{id: 9, relas_src: [{to: 256, str: 0.5}]} should not contain "relas_src"');
    });
    test("validate tag with relation already existing", () {
      tag1 = {"id": 5, "relas_src": [{"to": 6, "str": 0.5}]};
      context = createContextWrapTagAndValidate(tag1, admin);
      expect(context.message,
          '{id: 5, relas_src: [{to: 6, str: 0.5}]} should not contain "relas_src"');
    });
  });
  group("Validate PUT relations", () {
    server_lib.RequestContext context;
    Map rela1;
    test("validate with failed wrapRelation", () {
      context = createContextWrapRelationAndValidate(null, admin);
      expect(context.message, 'Relation data is not Map');
    });
    test("validate correct relation", () {
      rela1 = {"id": mountsToId(5, 6), "str": 0.2};
      context = createContextWrapRelationAndValidate(rela1, admin);
      expect(context.message, '');
    });
    test("validate with noob", () {
      rela1 = {"id": mountsToId(5, 6), "str": 0.2};
      context = createContextWrapRelationAndValidate(rela1, noob);
      expect(context.message,
          'Logged user cannot update tags or relations in central repository');
    });
    test("validate creation of relation", () {
      rela1 = {"id": mountsToId(9, 6), "str": 0.2};
      context = createContextWrapRelationAndValidate(rela1, admin);
      expect(context.message, '');
    });
    test("validate creation of relation with wrong from", () {
      rela1 = {"id": mountsToId(256, 6), "str": 0.2};
      context = createContextWrapRelationAndValidate(rela1, admin);
      expect(context.message, 'Relation 25600006 should lead from valid Tag');
    });
    test("validate creation of relation by wrapRelations()", () {
      List relas = [{"id": mountsToId(9, 6), "str": 0.2}];
      context = createContext(relas, "PUT", admin);
      getContainer(context)
        ..wrapRelations()
        ..validate();
      expect(context.message, '');
    });
    test(" wrapRelations() two wrong relations", () {
      List relas = [
        {"id": mountsToId(256, 6), "str": 0.2},
        {"blbl": mountsToId(9, 6), "str": 0.2}
      ];
      context = createContext(relas, "PUT", admin);
      getContainer(context)
        ..wrapRelations()
        ..validate();
      expect(context.message,
          'Relation 25600006 should lead from valid Tag<br>{blbl: 900006, str: 0.2} should contain "id"');
    });
  });
  group("Execute PUT tags", () {
    Map tag1;
    server_lib.RequestContext context;
    test("validate tag with right id", () {
      tag1 = {"id": 9};
      context = createContextWrapTagValidateAndExecute(tag1, admin);
      expect(context.message, 'Tag festival successfully updated');
    });
    test("validate tag with right id", () {
      tag1 = {"id": 9, "name": "festivalek"};
      context = createContextWrapTagValidateAndExecute(tag1, admin);
      expect(context.message, 'Tag festivalek successfully updated');
    });
  });
  group("Execute PUT relations", () {
    Map rela1;
    server_lib.RequestContext context;
    test("relation with wrong id", () {
      rela1 = {"id": 10001, "str": 0.2};
      context = createContextWrapRelationValidateAndExecute(rela1, admin);
      expect(context.message, 'Relation 10001 should lead from valid Tag');
    });
    test("relation with from", () {
      rela1 = {"from": 9, "str": 0.2};
      context = createContextWrapRelationValidateAndExecute(rela1, admin);
      expect(context.message,
          '{from: 9, str: 0.2} should contain "id" and should not contain "from"');
    });
    test("relation with right id", () {
      int relaId = mountsToId(9, 5);
      rela1 = {"id": relaId, "str": 0.2};
      context = createContextWrapRelationValidateAndExecute(rela1, admin);
      expect(context.message, 'Relation $relaId successfully updated');
    });
    test("relation leading to COMPOSITE", () {
      int relaId = mountsToId(9, 8);
      rela1 = {"id": relaId, "str": 0.2};
      context = createContextWrapRelationValidateAndExecute(rela1, admin);
      expect(context.message, 'Relation $relaId successfully updated');
    });
    test("multiple relation", () {
      int relaId = mountsToId(8, 9);
      int relaId2 = mountsToId(6, 9);
      List relas = [{"id": relaId, "str": 0.2}, {"id": relaId2, "str": 1.2}];
      context = createContextWrapRelationsValidateAndExecute(relas, admin);
      expect(context.message,
          'Relation $relaId successfully updated<br>Relation $relaId2 successfully updated');
    });
  });
  group("Execute Full PUT API", () {
    server_lib.RequestContext context;
    test("Load repo", () {
      repo.fromJson(sourceJson);
      expect(repo.getTags().length, 4);
      expect(repo.getRelations().length, 3);
      expect(repo.getTag(9), isNotNull);
      expect(repo.getTag(9).name, "festival");
    });
    test("Correct PUT with 1 tag and several relations", () {
      Map full = {
        "tags": [{"id": 9, "name": "festivalek"}],
        "relations": [
          {"id": mountsToId(9, 5), "str": 5},
          {"id": mountsToId(9, 6), "str": 0.2},
          {"id": mountsToId(5, 9), "str": 0.6}
        ]
      };
      context = createContextWrapValidateAndExecute(full, admin);
      expect(context.message,
          'Tag festivalek successfully updated<br>Relation ${mountsToId(9, 5)} successfully updated<br>Relation ${mountsToId(9, 6)} successfully updated<br>Relation ${mountsToId(5, 9)} successfully updated');
    });
  });
}
