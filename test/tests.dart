library tag_master.tests;

import "package:unittest/unittest.dart";
//import "package:unittest/vm_config.dart";
import "../lib/tag_master_common/library.dart" as common;
import "../server/main.dart" as server;
import "../server_libs/server/library.dart" as server_lib;

part "common.dart";
part "stack_test.dart";
part "user_test.dart";
part "after_api_test.dart";
part "repo_test.dart";
part "repo_adv_test.dart";
part "gettag_api_test.dart";
part "precheck_tag_test.dart";
part "precheck_relation_test.dart";
part "posttag_api_test.dart";
part "puttag_api_test.dart";

void main(){
  //Directory.current=Directory.current.parent;
  test("Elem seed",(){
    int seed=100;
    common.Entity.seed(seed);
    expect(common.Entity.getFreeId(),seed);
  });
  stack();
  user();
  preCheckTag();
  preCheckRelation();
  //after_api();
  repo_test();
  advanced_repo();
  get_tag_api();
  post_tag_api();
  put_tag_api();
}