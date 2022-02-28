import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';

class Location {
  String? id;

  String? workerId;

  String? currentReservationId;

  String? workerFullName;

  String? name;

  double? long;

  double? lat;

  String? state;

  static Location fromMap(Map<String, dynamic> map) {
    var location = Location();

    location.id = map['id'];
    location.state = map['state'];
    location.lat = map['lat'];
    location.long = map['long'];
    location.name = map['name'];
    location.workerId = map['workerId'];
    location.workerFullName = map['workerFullName'];
    location.currentReservationId = map['currentReservationId'];
    return location;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['state'] = state;
    map['lat'] = lat;
    map['long'] = long;
    map['name'] = name;
    map['workerId'] = workerId;
    map['workerFullName'] = workerFullName;
    map['currentReservationId'] = currentReservationId;
    return map;
  }

  bool isAvailable() {
    return state == ConstantsHelper.locationStates[0];
  }

  bool isReserved() {
    return state == ConstantsHelper.locationStates[2];
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
