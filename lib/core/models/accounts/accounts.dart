class Account {
  String? id;

  String? fullName;

  String? userName;

  String? password;

  String? phoneNumber;

  String? role;

  static Account fromMap(Map<String, dynamic> map) {
    var account = Account();

    account.fullName = map['fullName'];
    account.id = map['id'];
    account.userName = map['userName'];
    account.phoneNumber = map['phoneNumber'];
    account.role = map['role'];
    account.password = map['passowrd'];

    return account;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['id'] = id;
    map['fullName'] = fullName;
    map['userName'] = userName;
    map['role'] = role;
    map['password'] = password;
    map['phoneNumber'] = phoneNumber;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
