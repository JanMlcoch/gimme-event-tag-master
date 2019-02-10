part of tag_master.tests;

void advanced_repo(){
  group("Advanced Repo",(){
    group("Repo prototyping",(){
      common.Repo mainRepo = new common.Repo();
      common.Repo userRepo = new common.Repo();
      common.Tag tag1;
      common.Tag tag2;
      common.Relation rela1;
      common.Relation rela2;
      userRepo.prototype = mainRepo;
      mainRepo.fromJson(sourceJson);

      test("Four tags",(){
        expect(mainRepo.getTags().length,4);
      });
      test("Three relations",(){
        expect(mainRepo.getRelations().length,3);
      });
      test("getTag from mainRepo",(){
        tag1=mainRepo.getTag(5);
        expect(tag1,isNotNull);
        expect(tag1.name,"pivo");
      });
      test("updateTag from prototype",(){
        userRepo.updateTag({"id":tag1.id,"name":"superpivo"});
        tag2=userRepo.getTag(5);
        expect(tag2.name,"superpivo");
      });
      test("Pivo and Superpivo types should equal",(){
        expect(tag1.type,tag2.type);
      });
      test("update of user tag",(){
        // vyuziti tagu1 pro update tagu2 !!!!
        userRepo.updateTag({"id":tag1.id,"type":CONCRETE});
        expect(tag2.type,CONCRETE);
      });
      test("getRelation on empty userRepo",(){
        rela1=userRepo.getRelation(mountsToId(5,6));
        expect(rela1,isNotNull);
        expect(rela1.strength,0.75);
      });

      test("UpdateRelation from mainRepo",(){
        userRepo.updateRelation({"id":rela1.id,"str":2});
        rela2=userRepo.getRelation(mountsToId(5,6));
        expect(rela2.strength,2);
      });
      test("Relation2 fromTag should be Superpivo",(){
        expect(rela2.fromTag,tag2);
      });
      test("Relation2 toTag should be null",(){
        expect(rela2.toTag,isNull);
      });
      test("Relation1 fromTag should be Pivo",(){
        expect(rela1.fromTag,tag1);
      });
      test("AddTag() to userRepo",(){
        Map<String,dynamic> jtag={
          "name":"les",
          "type":CORE
        };
        userRepo.addTag(jtag);
        tag1=null;
        for(common.Tag tag in mainRepo.getTags()){
          if(tag.name=="les"){
            tag1=tag;
          }
        }
        expect(tag1,isNotNull);
      });
      test("AddTag should not add tag to userRepo",(){
        expect(userRepo.hasTag(tag1.id),isFalse);
      });
      test("UpdateTag into userRepo",(){
        Map<String,dynamic> jtag={
          "id":tag1.id,
          "name":"prales",
          "type":CORE,
          /*"relas_src":[
            {"to":5,"str":0.4},
            {"to":6,"str":1.1}
          ],
          "relas_trg":[
            {"from":5,"str":0.5}
          ]*/
        };
        expect(userRepo.hasTag(tag1.id),isFalse);
        tag2=userRepo.updateTag(jtag);
        expect(userRepo.hasTag(tag1.id),isTrue);
      });
      test("Tag1 from repo and tag2 have same ID",(){
        expect(tag1.id,tag2.id);
      });
      test("Tag1 from repo is different than tag2",(){
        expect("pra"+tag1.name,tag2.name);
      });
      test("precheck: addRelation should not add to prototype",(){
        expect(mainRepo.getRelations().length,3);
      });
      test("addRelation to userRepo",(){
        userRepo.addRelation({"to":5,"str":0.4},source:tag2);
        userRepo.addRelation({"to":6,"str":1.1},source:tag2);
        userRepo.addRelation({"from":5,"str":0.5},target:tag2);
        expect(userRepo.getRelations().length,4);
      });
      test("addRelation should not add to prototype",(){
        expect(mainRepo.getRelations().length,3);
      });
      test("Delete tag from userRepo",(){
        tag1=userRepo.deleteTag(tag1.id);
        expect(tag1,isNotNull);
        expect(userRepo.hasTag(tag1.id),isFalse);
      });
      test("DeleteTag should not delete relations",(){
        expect(userRepo.getRelations().length,4);
      });
      test("Check orphaned relations",(){
        rela1=userRepo.getRelation(mountsToId(tag1.id,5));
        expect(rela1,isNotNull);
        expect(rela1.fromTag,isNull);
      });

      //test("",(){});
      //test("",(){});
      //test("",(){});
    });
  });

}