part of tag_master.tests;

void preCheckRelation() {
  common.Repo repo = new common.Repo();
  group("preAddRelation", () {
    Map json = {};
    test("Load repo", () {
      repo.fromJson(sourceJson);
      expect(repo.getTags().length, 4);
      expect(repo.getRelations().length, 3);
    });
    test("integer instead Map", () {
      expect(repo.preAddRelation(5), "5 is not valid Map");
    });
    test("empty Map", () {
      expect(repo.preAddRelation({}),
          '{} should contain "from" and should contain "to" and should contain "str"');
    });
    test("Map with name", () {
      json["name"] = "les";
      expect(repo.preAddRelation(json),
          '{name: les} should contain "from" and should contain "to" and should contain "str"');
    });
    test("Map with from", () {
      json.remove("name");
      json["from"] = 15;
      expect(repo.preAddRelation(json),
          '{from: 15} should contain "to" and should contain "str"');
    });
    test("Map with string from and to", () {
      json["to"] = 3;
      expect(
          repo.preAddRelation(json), '{from: 15, to: 3} should contain "str"');
    });
    test("Map with string from, to and str", () {
      json["str"] = 0.02;
      expect(repo.preAddRelation(json),
          'Relation ${mountsToId(15,3)} should lead from valid Tag');
    });
    test("Map with string from", () {
      json["from"] = "les";
      expect(repo.preAddRelation(json),
          '{from: les, to: 3, str: 0.02} "from" parameter should be int');
    });
    test("Map with string from and to", () {
      json["to"] = "les";
      expect(repo.preAddRelation(json),
          '{from: les, to: les, str: 0.02} "from" parameter should be int and "to" parameter should be int');
    });
    test("Map with float from", () {
      json["from"] = 2.54;
      json["to"] = 3;
      expect(repo.preAddRelation(json),
          '{from: 2.54, to: 3, str: 0.02} "from" parameter should be int');
    });
    test("Map with float str", () {
      json["from"] = 6;
      json["str"] = 3.256;
      expect(repo.preAddRelation(json),
          'Relation ${mountsToId(6,3)} should lead to valid Tag');
    });
    test("Cyclic relation", () {
      json["from"] = 6;
      json["to"] = 6;
      expect(repo.preAddRelation(json),
          'Relation ${mountsToId(6,6)} cannot be cyclic');
    });
    test("Relation already exists", () {
      json["from"] = 8;
      json["to"] = 5;
      expect(repo.preAddRelation(json),
          'Relation ${mountsToId(8,5)} already exists');
    });
    test("Relation already exists", () {
      json["from"] = 9;
      json["to"] = 5;
      expect(repo.preAddRelation(json), isNull);
    });
    test("Map with id", () {
      json["id"] = 9;
      expect(repo.preAddRelation(json),
          '{from: 9, to: 5, str: 3.256, id: 9} should not contain "id"');
      json.remove("id");
    });
  });
  group("preUpdateRelation", () {
    Map json = {"str":5};
    int relaId;
    test("Load repo", () {
      repo.fromJson(sourceJson);
      expect(repo.getTags().length, 4);
      expect(repo.getRelations().length, 3);
    });
    test("Map with string id", () {
      json["id"] = "ahoj";
      expect(repo.preUpdateRelation(json),
      '{str: 5, id: ahoj} "id" parameter should be int');
    });
    test("Map with unknown id", () {
      json["id"] = 9;
      expect(repo.preUpdateRelation(json),
          'Relation 9 should lead from valid Tag');
    });
    test("Map with valid id", () {
      relaId = mountsToId(5, 6);
      json["id"] = relaId;
      expect(repo.preUpdateRelation(json), isNull);
    });
    test("Map with from", () {
      json["from"] = 5;
      expect(repo.preUpdateRelation(json),
      '{str: 5, id: 500006, from: 5} should not contain "from"');
      json.remove("from");
    });
    test("Map with string str", () {
      json["str"] = "ahoj";
      expect(repo.preUpdateRelation(json),
          '{str: ahoj, id: $relaId} "str" parameter should be num');
    });

    group("preDeleteRelation()", () {
      Map json = {};
      int relaId;
      test("Load repo", () {
        repo.fromJson(sourceJson);
        expect(repo.getTags().length, 4);
        expect(repo.getRelations().length, 3);
      });
      test("Map with string id", () {
        json["id"] = "ahoj";
        expect(repo.preDeleteRelation(json),
            '{id: ahoj} "id" parameter should be int');
      });
      test("Map with unknown id", () {
        json["id"] = 9;
        expect(repo.preDeleteRelation(json),
            'Relation specified by {id: 9} is not found');
      });
      test("Map with valid id", () {
        relaId = mountsToId(5, 6);
        json["id"] = relaId;
        expect(repo.preDeleteRelation(json), isNull);
      });
    });
  });
}
