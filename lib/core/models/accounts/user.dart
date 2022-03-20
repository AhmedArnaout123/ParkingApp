import 'package:parking_graduation_app_1/core/models/accounts/accounts.dart';

class User extends Account {
  int? balance;

  String? currentReservationId;

  static User fromMap(Map<String, dynamic> map) {
    var user = User();

    user.id = map['id'];
    user.phoneNumber = map['phoneNumber'];
    user.fullName = map['fullName'];
    user.balance = map['balance'];
    user.userName = map['userName'];
    user.currentReservationId = map['currentReservationId'];
    user.role = map['role'];
    return user;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['fullName'] = fullName;
    map['balance'] = balance;
    map['userName'] = userName;
    map['currentReservationId'] = currentReservationId;
    map['role'] = role;

    return map;
  }
}
