part of tag_master.compiler;

List<Tag> tempIncomingTags = [];

List<Tag> validate(List<Tag> incomingTags) {
  incomingTags = protectConsistency(incomingTags);
  incomingTags = removeMultiSynonym(incomingTags);
  incomingTags = protectConsistency(incomingTags);
  incomingTags = removeSynonymCycles(incomingTags);
  incomingTags = protectConsistency(incomingTags);
  incomingTags = remapSynonyms(incomingTags);
  incomingTags = removeCompositeCycles(incomingTags);
  incomingTags = remapComposite(incomingTags);
  incomingTags = removeCustomTagRelations(incomingTags);
  incomingTags = setSynonymStrength(incomingTags);
  incomingTags = removeForbiddenRelationByTypes(incomingTags);
  incomingTags = warnAboutNotBranched45(incomingTags);
  incomingTags = addReflexiveRelations(incomingTags);
  incomingTags = removeRelationlessTags(incomingTags);
  incomingTags = protectConsistency(incomingTags);
  return incomingTags;
}

List<Tag> protectConsistency(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    List<int> idsToRemove = [];
    tag.relations.forEach((id,str){
      if(getTagById(id,incomingTags)==null){
        idsToRemove.add(id);
      }
    });
    for(int id in idsToRemove){
      tag.relations.remove(id);
      print("Relation was removed, from tag "+tag.name+" to tag with id of "+id.toString()+" because the latter had not existed.");
    }
  }
  return incomingTags;
}

List<Tag> removeSynonymCycles(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.type==1){
      incomingTags = checkAndFixSynonymForCycle(tag,incomingTags)["tags"];
    }
  }
  return incomingTags;
}

List<Tag> removeMultiSynonym(List<Tag> incomingTags) {
  List<Tag> tagsToRemove = [];
  for(Tag tag in incomingTags){
    if(tag.type==1&&tag.relations.length>1){
      tagsToRemove.add(tag);
    }
  }
  for(Tag tag in tagsToRemove){
      print("Synonym "+tag.name+" was removed because of multitargeting");
      incomingTags.remove(tag);
  }
  return incomingTags;
}

List<Tag> remapSynonyms(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.type==1){
      remapSynonym(tag,incomingTags);
    }
  }
  return incomingTags;
}

List<Tag> removeCompositeCycles(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.type==3){
      removeCompositeCycle(tag,incomingTags);
    }
  }
  return incomingTags;
}

List<Tag> remapComposite(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.type==3){
      tempIncomingTags = incomingTags;
      remapThisComposite(tag);
    }
  }
  return tempIncomingTags;
}

List<Tag> removeCustomTagRelations(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.type==4){
      if(tag.relations.length>0){
        print("Relations were removed from custom tag "+tag.name+".");
        tag.relations.clear();
      }
    }
  }
  return incomingTags;
}


List<Tag> setSynonymStrength(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.type==1){
      tag.relations.forEach((id,str){
        if(str!=1){
          print("Relation strength from synonym "+tag.name+" to tag "+getTagById(id,incomingTags).name+" was adjusted to 1");
          tag.relations[id] = 1.0;
        }
      });
    }
  }
  return incomingTags;
}

List<Tag> removeForbiddenRelationByTypes(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    List<int> idsToDestroy = [];
    tag.relations.forEach((id,str){
      int toType = getTagById(id,incomingTags).type;
      if(isForbiddenRelationByType(tag.type,toType)){
        idsToDestroy.add(id);
      }
    });
    for(int id in idsToDestroy){
      print("Relation from tag "+tag.name+" to tag "+getTagById(id,incomingTags).name+" because they were of forbidden combination of types");
      tag.relations.remove(id);
    }
  }
  return incomingTags;
}

List<Tag> warnAboutNotBranched45(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.type>3&&tag.relations.length<3){
      print("Significant tag "+tag.name+" has only "+tag.relations.length.toString()+" relations.");
    }
  }
  return incomingTags;
}

List<Tag> addReflexiveRelations(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.type>3||tag.type==2){
      tag.relations[tag.id] = 1.0;
    }
  }
  return incomingTags;
}

List<Tag> removeRelationlessTags(List<Tag> incomingTags) {
  for(Tag tag in incomingTags){
    if(tag.relations.length<1){
      print("Tag "+tag.name+" was removed because it did not have any relations (therefore was insignificant for imprintification).");
    }
  }
  return incomingTags;
}
//konec druhé úrovně zanoření
Map checkAndFixSynonymForCycle(Tag tag, List<Tag> incomingTags){//vrací true když je vše OK
  bool toReturnBool;
  int nextId;
  tag.relations.forEach((id,str){
    nextId = id;
  });
  Tag nextTag = getTagById(nextId,incomingTags);
  if(nextTag.type!=1){
    toReturnBool = true;
  }
  else{
    Map nextIteration = checkAndFixSynonymForCycle(nextTag,incomingTags);
    toReturnBool = nextIteration["succes"];
    incomingTags = nextIteration["tags"];
  }
  if(!toReturnBool){
    incomingTags.remove(tag);
    print("Synonym "+tag.name+" was removed because it was part of synonym cycle");
  }
  return {"succes":toReturnBool,"tags":incomingTags};
}

Tag getTagById(int id, List<Tag> incomingTags){
  for(Tag tag in incomingTags){
    if(tag.id==id){
      return tag;
    }
  }
  return null;
}

List<Tag> remapSynonym(Tag tag,List<Tag> incomingTags) {
  int targetId;
  tag.relations.forEach((id,str){
    targetId = id;
  });
  Tag target = getTagById(targetId,incomingTags);
  if(target.type==1){
    remapSynonym(target,incomingTags);
    target = getTagById(targetId,incomingTags);
    int targetsTargetId;
    target.relations.forEach((id,str){
      targetsTargetId = id;
    });
    tag.relations.clear();
    tag.relations = {targetsTargetId:1};
    print("(INFO) synonym "+tag.name+" was remaped from its former target "+target.name+" to "+getTagById(targetsTargetId,incomingTags).name);
  }
  return incomingTags;
}

List<Tag> removeCompositeCycle(Tag tag,List<Tag> incomingTags){
  tempIncomingTags = incomingTags;
  List<int> sequenceList = [];
  seekAndDestroyCompositeCycle(sequenceList,tag);
  return tempIncomingTags;
}

void seekAndDestroyCompositeCycle(List<int> history,Tag tag){
  List<int> idsToDestroy = [];
  history.add(tag.id);
  tag.relations.forEach((id,str){
    if(history.contains(id)){
      idsToDestroy.add(id);
    }
    else{
      List<int> historyx = history.toList();
      seekAndDestroyCompositeCycle(historyx,getTagById(id,tempIncomingTags));
    }
  });
  for(int id in idsToDestroy){
    if(getTagById(tag.id,tempIncomingTags).relations.containsKey(id)){
      getTagById(tag.id,tempIncomingTags).relations.remove(id);
      print("Relation from "+tag.name+" to "+getTagById(id,tempIncomingTags).name+" was removed because tags were part of composite cycles");
    }
  }
}

List<Tag> remapThisComposite(Tag tag){
  bool containsCompositeTargets = false;
  tag.relations.forEach((id,v){
    if(getTagById(id,tempIncomingTags).type==3){
      containsCompositeTargets = true;
    }
  });
  while(containsCompositeTargets){
    List<int> idsToDestroy = [];
    Map<int,double> nextGenerationRelations = {};
    tag.relations.forEach((id,str){
      Tag target = getTagById(id,tempIncomingTags);
      if(target.type==3){
        idsToDestroy.add(id);
        target.relations.forEach((targetsTargetId,str2){
          if(nextGenerationRelations[targetsTargetId]==null){
            nextGenerationRelations[targetsTargetId] = str*str2;
          }
          else{
            nextGenerationRelations[targetsTargetId] = nextGenerationRelations[targetsTargetId]+str*str2;
          }
        });
      }
    });

    for(int id in idsToDestroy){
      if(tag.relations.containsKey(id)){
        tag.relations.remove(id);
        print("Composite-Composite relation of tag "+tag.name+" to "+getTagById(id,tempIncomingTags).name+" was remaped");
      }
    }
    nextGenerationRelations.forEach((id,str){
      if(tag.relations.containsKey(id)) {
        tag.relations[id] = tag.relations[id] + str;
      }
      else{
        tag.relations[id] = str;
      }
    });
    containsCompositeTargets = false;
    tag.relations.forEach((id,v){
      if(getTagById(id,tempIncomingTags).type==3){
        containsCompositeTargets = true;
      }
    });
  }
  Tag matchTempTag = getTagById(tag.id,tempIncomingTags);
  for(Tag tempTag in tempIncomingTags){
    if(tempTag==matchTempTag){
      tempTag = tag;
    }
  }
  return tempIncomingTags;
}

bool isForbiddenRelationByType(int fromType, int toType){
  if(fromType==1){
    return toType<1;
  }
  else if(fromType==2){
    return true;
  }
  else if(fromType==3||fromType==4){
    return toType<4;
  }
  else if(fromType==5){
    return toType<5;
  }
  return true;
}