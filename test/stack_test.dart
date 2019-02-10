part of tag_master.tests;

void stack() {
  group("Tags stack:", () {
    List<Map> jtags = [
    {"id": 50, "name": "pivo","type":CORE},
  {"name": "gloglo", "type": COMPOSITE}
];
    common.Tags tags = new common.Tags();
    common.Tags tags2 = new common.Tags();
    common.Tag tag1;
    common.Tag tag2;
    common.Tag tag3;
    test("Elem seed",(){
      int seed=50;
      common.Entity.seed(seed);
      expect(common.Entity.getFreeId(),seed);
    });
    test("Tags is empty", () {
      expect(tags.length, 0);
    });
    test("Tags contains 2 tags", () {
      tags.fromJson(jtags);
      expect(tags.length, 2);
    });
    test("Tag1 is gettable by ID 50", () {
      tag1 = tags[50];
      expect(tag1, isNotNull);
      expect(tag1.id, 50);
    });

    test("Tag2 can be obtained through iteration", () {
      for (common.Tag tag in tags.values) {
        if (tag.id != 50) {
          tag2 = tag;
          break;
        }
      }
      expect(tag2, isNotNull);
    });
    test("Tag2 ID is 51", () {
      expect(tag2.id, 51);
    });
    test("Copy of Tags into Tags2", () {
      tags2.copy(tags);
      expect(tags.length, 2);
    });
    test("Tag1 from both Tags are copies", () {
      expect((tags[50] as common.Tag).name, (tags2[50] as common.Tag).name);
    });
    test("Tag1 from both Tags is not same", () {
      expect((tags[50] as common.Tag), isNot(equals(tags2[50] as common.Tag)));
    });
    test("toIdList", () {
      expect(tags.toIdList(), allOf(contains(50), contains(51)));
    });
    test("Removal tag1 copy by tag1 object", () {
      expect(tags2.delete(tag1), true);
      expect(tags2[50], isNull);
    });
    test("getTag() by source tag ID", () {
      tag3 = tags2.getTag(tag2.id);
      expect(tag3, isNotNull);
      expect(tag3.name, tag2.name);
    });
    test("overwrite by add()", () {
      tag3.type = COMPARABLE;
      tags.add(tag3);
      expect(tags.values, isNot(contains(tag2)));
    });
    test("toJson()",(){
      List expected=[
        {"id":50,"name":"pivo","type":CORE,"relas_src":[],"relas_trg":[]},
        {"id":51,"name":"gloglo","type":COMPARABLE,"relas_src":[],"relas_trg":[]}
      ];
      expect(tags.toJson(),equals(expected));
    });
  });
  group("Relations stack:", () {
    common.Relations relas = new common.Relations();
    common.Relations relas2 = new common.Relations();
    common.Relation rela1;

    List<Map> jrelas = [
      {"from":51,"to":25,"str":0.5},
      {"from":51,"to":26,"str":2},
      {"from":51,"to":26,"str":0.1}
    ];
    test("load by fromJSON()",(){
      relas.fromJson(jrelas);
      expect(relas.length,2);
    });
    test("IDs of relations",(){
      expect(relas.toIdList(),unorderedEquals([mountsToId(51,25),mountsToId(51,26)]));
    });
    test("Rela to 25 have strength 0.5",(){
      rela1=relas[mountsToId(51,25)];
      expect(rela1,isNotNull);
      expect(rela1.strength,0.5);
    });
    test("Rela to 26 have strength 0.1",(){
      rela1=relas[mountsToId(51,26)];
      expect(rela1,isNotNull);
      expect(rela1.strength,0.1);
    });
    test("Copy of relas",(){
      relas2.copy(relas);
      expect(relas2.length,2);
    });
    test("Relas2 contains relation copies",(){
      rela1=relas[mountsToId(51,25)];
      expect((relas2[mountsToId(51,25)] as common.Relation).strength,rela1.strength);
    });
    test("Relas2 contains different objects",(){
      expect(relas2[mountsToId(51,25)],isNot(equals(rela1)));
    });
    test("Compare of copies",(){
      expect(relas2.compare(relas),common.SAME);
    });
    test("Compare of modified copies",(){
      rela1.strength=0.4;
      expect(relas2.compare(relas),common.SIMILAR);
    });
    test("Compare of differently large relations",(){
      relas.delete(rela1);
      expect(relas2.compare(relas),common.DIFFERENT);
    });
    test("check of toJson()",(){
      List expected=[
        {"from":51,"to":26,"str":0.1}
      ];
      expect(relas.toJson(),equals(expected));
    });


  });
}
