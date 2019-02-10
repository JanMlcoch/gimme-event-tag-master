part of tag_master.tests;

common.Users users = new common.Users();

void user() {
  Map juser = {"id": 15, "login": "blbec", "password": "aaa", "name": "Blbec"};
  common.User user1 = new common.User.create(juser);
  group("User1 tests",(){
    test("Elem seed",(){
      int seed=0;
      common.Entity.seed(seed);
      expect(common.Entity.getFreeId(),seed);
    });
    test("User1 is created", () {
      expect(user1, isNotNull);
    });
    test("User1 ID should be 1", () {
      expect(user1.id, 1);
    });
    test("User1 login", () {
      expect(user1.login, "blbec");
    });
    test("User1 password aaa", () {
      expect(user1.checkPassword("aaa"), true);
    });
    test("User1 wrong password", () {
      expect(user1.checkPassword("aba"), false);
    });

  });
  group("User2 tests",(){
    common.User user2 = new common.User()..fromJson(juser);
    test("User2 id should be 15", () {
      expect(user2.id, 15);
    });
    test("User2 rename", () {
      user2.fromJson({"name": "glob", "password": "bbb"});
      expect(user2.name, "glob");
    });
    test("User2 new password", () {
      expect(user2.checkPassword("bbb"), true);
    });
    test("User2 login is same as User1", () {
      expect(user2.login, user1.login);
    });
    test("User2 can modify own tags", () {
      expect(user2.checkPermission(common.MANAGE_OWN_REPO), true);
    });
    test("User2 can see default tags", () {
      expect(user2.checkPermission(common.SEE_REPO), true);
    });
    test("User2 cannot modify default tags", () {
      expect(user2.checkPermission(common.MANAGE_REPO), false);
    });
    test("User2 gained raight to modify others tags", () {
      user2.fromJson({"permissions":[common.MANAGE_OWN_REPO,common.MANAGE_OTHER_REPO]});
      expect(user2.checkPermission(common.MANAGE_OTHER_REPO), true);
    });

  });
}
