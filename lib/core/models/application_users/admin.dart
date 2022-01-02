class Admin {
  String? id;

  String? phoneNumber;

  String? role;

  String? name;

  static Admin fromMap(Map<String, dynamic> map) {
    var admin = Admin();

    admin.id = map['id'];
    admin.phoneNumber = map['phoneNumber'];
    admin.role = map['role'];
    admin.name = map['name'];

    return admin;
  }
}
