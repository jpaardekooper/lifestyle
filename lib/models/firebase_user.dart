class AppUser {
  AppUser({this.uid, this.username, this.role});
  String uid;
  String username;
  String role;

  String get getUserName {
    return username;
  }

  String get getUserRole {
    return role;
  }

  set setUserName(String name) {
    username = name;
  }

  set setUserRole(String role) {
    role = role;
  }
}
