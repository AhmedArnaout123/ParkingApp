class Location {
  String? id;

  String? workerId;

  String? name;

  double? long;

  double? lat;

  bool? isReserved;

  static Location fromMap(Map<String, dynamic> map) {
    var location = Location();

    location.id = map['id'];
    location.isReserved = map['isReserved'];
    location.lat = map['lat'];
    location.long = map['long'];
    location.name = map['name'];
    location.workerId = map['workerId'];

    return location;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['isReserved'] = isReserved;
    map['lat'] = lat;
    map['long'] = long;
    map['name'] = name;
    map['workerId'] = workerId;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
