part of tag_master.tests;

void repo_test() {
  common.Repo repo;
  common.Tag pivo;
  common.Tag festival;
  common.Relation rela1;
  common.Relation rela2;
  Map<String, dynamic> jtag;
  group("Tags repo", () {
    common.Tag les;
    test("Elem seed", () {
      int seed = 100;
      common.Entity.seed(seed);
      expect(common.Entity.getFreeId(), seed);
    });
    test("New repo is empty", () {
      repo = new common.Repo();
      expect(repo.getTags().length, 0);
      expect(repo.getRelations().length, 0);
    });
    test("Four tags", () {
      repo.fromJson(sourceJsonExpanded);
      expect(repo.getTags().length, 4);
    });
    test("Four Relations", () {
      expect(repo.getRelations().length, 4);
    });
    test("Pivo tag have name pivo", () {
      pivo = repo.getTag(5);
      expect(pivo.name, "pivo");
    });
    test("Pivo source relations", () {
      jtag = pivo.toJson();
      expect(jtag["relas_src"], equals([mountsToId(5, 6), mountsToId(5, 8)]));
    });
    test("Pivo target relations", () {
      expect(jtag["relas_trg"], equals([mountsToId(8, 5), mountsToId(6, 5)]));
    });
    /*test("Add Tag with relations", () {
      jtag = {
        "name": "les",
        "type": common.CORE,
        "relas_src": [
          {"from": 56, "to": 6, "str": 0.2},
          {"to": 5, "str": 0.2},
          {"to": 8, "str": 0.2}
        ],
        "relas_trg": [
          {"from": 5, "str": 0.2},
          {"from": 6, "str": 0.2},
          {"from": 8, "str": 0.2},
        ]
      };
      repo.addTag(jtag);
      for (common.Tag tag in repo.getTags()) {
        if (tag.name == "les") {
          les = tag;
        }
      }
      expect(les, isNotNull);
    });*/
    test("Add tag", () {
      jtag = {"name": "les", "type": CORE,};
      les = repo.addTag(jtag);
      expect(les, isNotNull);
      expect(les.name, "les");
    });
    test("Number of tags after add", () {
      expect(repo.getTags().length, 5);
    });
    test("Add relations to les", () {
      repo.addRelation({"from": 56, "to": 6, "str": 0.2}, source: les);
      repo.addRelation({"to": 5, "str": 0.2}, source: les);
      repo.addRelation({"to": 8, "str": 0.2}, source: les);
      repo.addRelation({"from": 5, "str": 0.2}, target: les);
      repo.addRelation({"from": 6, "str": 0.2}, target: les);
      repo.addRelation({"from": 8, "str": 0.2}, target: les);
    });
    test("Number of relations after add", () {
      expect(repo.getRelations().length, 10);
    });
    test("Les source relations", () {
      jtag = les.toJson();
      expect(jtag["relas_src"], unorderedEquals([
        mountsToId(les.id, 5),
        mountsToId(les.id, 6),
        mountsToId(les.id, 8)
      ]));
    });
    test("Les target relations", () {
      expect(jtag["relas_trg"], unorderedEquals([
        mountsToId(5, les.id),
        mountsToId(6, les.id),
        mountsToId(8, les.id)
      ]));
    });
    test("getTag()", () {
      expect(repo.getTag(les.id), les);
    });
    test("getRelation()", () {
      rela1 = repo.getRelation(mountsToId(8, les.id));
      expect(rela1, isNotNull);
      expect(repo.getRelation(rela1.id), rela1);
    });
  });

  group("Relations repo", () {
    test("Newly initialized repo", () {
      repo = new common.Repo();
      repo.fromJson(sourceJson);
      expect(repo.getRelations().length, 3);
    });
    test("Festival exists", () {
      for (common.Tag tag in repo.getTags()) {
        if (tag.name == "festival") {
          festival = tag;
        }
      }
      expect(festival, isNotNull);
      expect(festival.name, "festival");
    });
    test("Add relation", () {
      expect(repo.getRelations().length, 3);
      jtag = {"from": 8, "to": festival.id, "str": 2};
      repo.addRelation(jtag);
      expect(repo.getRelations().length, 4);
    });
    test("Add multiple relations", () {
      jtag = {"from": festival.id, "to": 5, "str": 2};
      repo.addRelation(jtag);
      jtag = {"from": 6, "to": festival.id, "str": 0.2};
      repo.addRelation(jtag);
      jtag = {"from": 5, "to": festival.id, "str": 1};
      repo.addRelation(jtag);
      expect(repo.getRelations().length, 7);
    });
    test("Get bogus relation", () {
      rela2 = repo.getRelation(203);
      expect(rela2, isNull);
    });
    test("Delete real relation", () {
      rela2 = repo.getRelation(mountsToId(8, festival.id));
      rela2 = repo.deleteRelation(rela2.id);
      expect(rela2, isNotNull);
    });
    test("After delete relation", () {
      expect(repo.getRelations().length, 6);
      expect(repo.getRelation(mountsToId(8, festival.id)), isNull);
    });
    test("check source tag of deleted relation", () {
      List<int> src = rela2.fromTag.relations_source.toIdList();
      expect(src, unorderedEquals([mountsToId(8, 5)]));
    });
    test("check target tag of deleted relation", () {
      List<int> src = rela2.toTag.relations_target.toIdList();
      expect(src, unorderedEquals(
          [mountsToId(5, festival.id), mountsToId(6, festival.id)]));
    });
    //test("",(){});
  });
  group("Update repo", () {
    common.Repo repo2;
    test("Newly initized repo", () {
      repo2 = new common.Repo();
      repo2.fromJson(sourceJson);
      expect(repo2.getRelations().length, 3);
    });
    test("Update tag in repo", () {
      pivo = repo2.updateTag({"id": pivo.id, "type": CONCRETE});
      expect(pivo.type, CONCRETE);
    });
    test("Check tags overview()", () {
      List targetJson = [
        {'id': 5, 'name': 'pivo', 'type': 4, 'rel_num': [2, 1]},
        {'id': 6, 'name': 'Asonance', 'type': 4, 'rel_num': [1, 1]},
        {'id': 8, 'name': 'soboty', 'type': 3, 'rel_num': [0, 1]},
        {'id': 9, 'name': 'festival', 'type': 5, 'rel_num': [0, 0]}
      ];
      expect(repo2.overview()["tags"], targetJson);
    });
    test("check source relations of updated tag", () {
      List<int> src = pivo.relations_target.toIdList();
      expect(src,
          unorderedEquals([mountsToId(6, pivo.id), mountsToId(8, pivo.id)]));
    });
    test("Common Update rela in repo", () {
      rela1 = repo2.getRelation(mountsToId(6, pivo.id));
      expect(rela1, isNotNull);
      rela1 = repo2.updateRelation({"id": rela1.id, "str": 0.25});
      expect(rela1, isNotNull);
      expect(rela1.strength, 0.25);
    });
    /*test("Redirection of relation", () {
      rela1 = repo.updateRelation(rela1, {"from": pivo.id});
      expect(res, isTrue);
      expect(rela1.fromTag, repo.getTag(6));
    });*/
  });
}
