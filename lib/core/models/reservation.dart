class Reservation {
  String? id;

  String? userId;

  String? locationId;

  double? time;

  String? startDate;

  String? endDate;

  double? cost;

  static Reservation fromMap(Map<String, dynamic> map) {
    var res = Reservation();

    res.id = map['id'];
    res.cost = map['cost'];
    res.endDate = map['endDate'];
    res.startDate = map['startDate'];
    res.locationId = map['locationId'];
    res.userId = map['userId'];
    res.time = map['time'];

    return res;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['cost'] = cost;
    map['endDate'] = endDate;
    map['startDate'] = startDate;
    map['locationId'] = locationId;
    map['userId'] = userId;
    map['time'] = time;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
