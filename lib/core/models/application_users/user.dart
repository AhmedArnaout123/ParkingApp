class User {
  String? id;

  String? phoneNumber;

  String? role;

  String? name;

  double? balance;

  static User fromMap(Map<String, dynamic> map) {
    var user = User();

    user.id = map['id'];
    user.phoneNumber = map['phoneNumber'];
    user.role = map['role'];
    user.name = map['name'];
    user.balance = map['balance'] + 0.0;

    return user;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['role'] = role;
    map['name'] = name;
    map['balance'] = name;

    return map;
  }
}
