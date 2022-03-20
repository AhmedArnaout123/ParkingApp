class Admin {
  String? id;

  String? phoneNumber;

  String? name;

  String? userName;

  static Admin fromMap(Map<String, dynamic> map) {
    var admin = Admin();

    admin.id = map['id'];
    admin.phoneNumber = map['phoneNumber'];
    admin.name = map['name'];
    admin.userName = map['userName'];
    return admin;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['name'] = 'name';
    map['userName'] = userName;

    return map;
  }
}
