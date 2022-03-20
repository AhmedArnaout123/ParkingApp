class User {
  String? id;

  String? phoneNumber;

  String? name;

  double? balance;

  String? userName;

  String? currentReservationId;

  static User fromMap(Map<String, dynamic> map) {
    var user = User();

    user.id = map['id'];
    user.phoneNumber = map['phoneNumber'];
    user.name = map['name'];
    user.balance = map['balance'] + 0.0;
    user.userName = map['userName'];
    user.currentReservationId = map['currentReservationId'];
    return user;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['name'] = name;
    map['balance'] = balance;
    map['userName'] = userName;
    map['currentReservationId'] = currentReservationId;
    return map;
  }
}
