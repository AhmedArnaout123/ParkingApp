import 'package:parking_graduation_app_1/core/models/accounts/accounts.dart';

class User extends Account {
  double? balance;

  String? currentReservationId;

  static User fromMap(Map<String, dynamic> map) {
    var user = User();

    user.id = map['id'];
    user.phoneNumber = map['phoneNumber'];
    user.userFullName = map['userFullName'];
    user.balance = map['balance'] + 0.0;
    user.userName = map['userName'];
    user.currentReservationId = map['currentReservationId'];
    user.role = map['role'];
    return user;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['userFullName'] = userFullName;
    map['balance'] = balance;
    map['userName'] = userName;
    map['currentReservationId'] = currentReservationId;
    map['role'] = role;

    return map;
  }
}
