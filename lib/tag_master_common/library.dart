library tag_master_common;

part "src/tag.dart";
part 'src/stack.dart';
part "src/user.dart";
//part "src/block.dart";
//part "src/matrix.dart";
part "src/relation.dart";
part "src/tag_master_entity.dart";
part "../resources.dart";
part "src/repo.dart";

const String TAG_TYPE_API = "/api/type";
const String USER_API = "/api/user";
const String TAGS_API = "/api/tags";
const String TAG_API = "/api/tag";
const String LOGIN_API = "/api/login";
const String RELATION_API = "/api/relation";
const String REL_TAGS_API = "/api/rel_tags";
//const String SOCKET_API="/api/sock";
const int BLOCK_LENGTH = 35;

//enum TagType {CORE,CONCRETE,COMPOSITE,COMMON,COMPARABLE}

// DIFFERENCES between objects
const int ANOTHER = 0;
const int DIFFERENT = 1;
const int SIMILAR = 2;
const int SAME = 3;

// PERMISSIONS
const int SEE_REPO = 10;
const int MANAGE_USERS = 11;
const int MANAGE_REPO = 12;
const int MANAGE_OWN_REPO = 13;
const int MANAGE_OTHER_REPO = 14;
