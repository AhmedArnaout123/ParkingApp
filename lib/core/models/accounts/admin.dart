import 'package:parking_graduation_app_1/core/models/accounts/accounts.dart';

class Admin extends Account {
  static Admin fromMap(Map<String, dynamic> map) {
    var admin = Admin();

    admin.id = map['id'];
    admin.phoneNumber = map['phoneNumber'];
    admin.fullName = map['fullName'];
    admin.userName = map['userName'];
    admin.role = map['role'];

    return admin;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['fullName'] = fullName;
    map['userName'] = userName;
    map['role'] = role;

    return map;
  }
}
