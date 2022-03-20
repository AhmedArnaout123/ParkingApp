class Reservation {
  String? id;

  String? userId;

  String? userFullName;

  String? userPhoneNumber;

  String? workerId;

  String? workerFullName;

  String? locationId;

  String? locationName;

  String? startDate;

  String? endDate;

  int? cost;

  bool? isFinished;

  static Reservation fromMap(Map<String, dynamic> map) {
    var res = Reservation();

    res.id = map['id'];
    res.userId = map['userId'];
    res.userPhoneNumber = map['userPhoneNumber'];
    res.userFullName = map['userFullName'];
    res.workerId = map['workerId'];
    res.workerFullName = map['workerFullName'];
    res.locationId = map['locationId'];
    res.locationName = map['locationName'];
    res.cost = map['cost'];
    res.endDate = map['endDate'];
    res.startDate = map['startDate'];
    res.isFinished = map['isFinished'];

    return res;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['userId'] = userId;
    map['userPhoneNumber'] = userPhoneNumber;
    map['userFullName'] = userFullName;
    map['wokerId'] = workerId;
    map['wokerFullName'] = workerFullName;
    map['locationId'] = locationId;
    map['locationName'] = locationName;
    map['cost'] = cost;
    map['endDate'] = endDate;
    map['startDate'] = startDate;
    map['isFinished'] = isFinished;
    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
