import 'package:parking_graduation_app_1/core/models/accounts/accounts.dart';

class Worker extends Account {
  static Worker fromMap(Map<String, dynamic> map) {
    var worker = Worker();

    worker.id = map['id'];
    worker.phoneNumber = map['phoneNumber'];
    worker.fullName = map['fullName'];
    worker.userName = map['userName'];
    worker.role = map['role'];

    return worker;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['userName'] = userName;
    map['fullName'] = fullName;
    map['role'] = role;

    return map;
  }
}
