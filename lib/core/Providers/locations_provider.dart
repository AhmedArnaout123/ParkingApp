import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';

class LocationsProvider {
  static LocationsProvider? _instance;

  final StreamController<List<Location>> _locationsStreamController =
      StreamController();

  List<Location> _locations = [];

  LocationsProvider._internal() {
    final _collection = FirebaseFirestore.instance.collection('locations');

    _collection.snapshots().listen((event) {
      List<Location> locations = [];

      for (var location in event.docs) {
        locations.add(Location.fromMap({
          'id': location.id,
          ...location.data(),
        }));
      }

      _locations = locations;
      _locationsStreamController.add(_locations);
    });
  }

  factory LocationsProvider() {
    _instance ??= LocationsProvider._internal();
    return _instance!;
  }

  Stream<List<Location>> get stream => _locationsStreamController.stream;

  List<Location> get locations => List.of(_locations);
}
