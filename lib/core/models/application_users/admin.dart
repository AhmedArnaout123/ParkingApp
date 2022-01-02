class Admin {
  String? id;

  String? phoneNumber;

  String? role;

  String? name;

  String? userName;

  static Admin fromMap(Map<String, dynamic> map) {
    var admin = Admin();

    admin.id = map['id'];
    admin.phoneNumber = map['phoneNumber'];
    admin.role = map['role'];
    admin.name = map['name'];
    admin.userName = map['userName'];
    return admin;
  }
}
