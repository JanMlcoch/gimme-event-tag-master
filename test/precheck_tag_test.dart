part of tag_master.tests;

void preCheckTag() {
  common.Repo repo = new common.Repo();
  common.Tag les;
  group("AddTag prechecks", () {
    Map json = {};
    test("not object JSON", () {
      expect(repo.preAddTag(5), "5 is not valid Map");
    });
    test("wrong Map type", () {
      expect(repo.preAddTag({5: 5}),
          '{5: 5} should contain "name" and should contain "type"');
      // should be corrected to something like "5 is not valid Map generics"
    });
    test("empty Map", () {
      expect(repo.preAddTag(json),
          '{} should contain "name" and should contain "type"');
    });
    test("Map with ID", () {
      json["id"] = 5;
      expect(repo.preAddTag(json),
          '{id: 5} should contain "name" and should contain "type" and should not contain "id"');
    });
    test("Map with name", () {
      json.remove("id");
      json["name"] = "les";
      expect(repo.preAddTag(json), '{name: les} should contain "type"');
    });
    test("Map with name and type - working", () {
      json["type"] = CORE;
      expect(repo.preAddTag(json), isNull);
    });
    test("Map with string type", () {
      json["type"] = "ahoj";
      expect(repo.preAddTag(json),
          '{name: les, type: ahoj} "type" parameter should be int');
    });
    test("Map with large type", () {
      json["type"] = 25464;
      expect(repo.preAddTag(json), 'les has unknown Tag type');
    });
    test("Map with float name", () {
      json["type"] = CORE;
      json["name"] = 5.256;
      expect(repo.preAddTag(json),
          '{name: 5.256, type: 5} "name" parameter should be String');
    });
  });
  group("preUpdateTag()", () {
    Map json = {};
    test("not object JSON", () {
      expect(repo.preUpdateTag(5), "5 is not valid Map");
    });
    test("empty Map", () {
      expect(repo.preUpdateTag(json), '{} should contain "id"');
    });
    test("Map with float id", () {
      json["id"] = 52.548;
      expect(
          repo.preUpdateTag(json), '{id: 52.548} "id" parameter should be int');
    });
    test("Map with normal integer id", () {
      json["id"] = 5;
      expect(repo.preUpdateTag(json), 'Tag with ID=5 is not found');
    });
    test("AddTag to repo", () {
      les = repo.addTag({"name": "les", "type": CONCRETE});
      expect(repo.getTags().length, 1);
    });
    test("Map with les id", () {
      json["id"] = les.id;
      expect(repo.preUpdateTag(json), isNull);
    });
    test("Map with float name", () {
      json["name"] = 5.245;
      expect(repo.preUpdateTag(json),
          '{id: 1, name: 5.245} "name" parameter should be String');
    });
    test("Map with String name", () {
      json["name"] = "prales";
      expect(repo.preUpdateTag(json), isNull);
    });
  });
  group("preDeleteTag", () {
    Map json = {};
    test("Empty map", () {
      expect(repo.preDeleteTag(json), '{} should contain "id"');
    });
    test("Map with String id", () {
      json["id"] = "ahoj";
      expect(
          repo.preDeleteTag(json), '{id: ahoj} "id" parameter should be int');
    });
    test("Map with arbitrary id", () {
      json["id"] = 24456;
      expect(repo.preDeleteTag(json), 'Tag specified by {id: 24456} not found');
    });
    test("Map with les id", () {
      json["id"] = les.id;
      expect(repo.preDeleteTag(json), isNull);
    });
  });
}
