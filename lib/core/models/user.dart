class User {
  String? id;

  String? phoneNumber;

  String? role;

  String? name;

  static User fromMap(Map<String, dynamic> json) {
    var user = User();

    user.id = json['id'];
    user.phoneNumber = json['phoneNumber'];
    user.role = json['role'];
    user.name = json['name'];

    return user;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['role'] = role;
    map['name'] = name;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
