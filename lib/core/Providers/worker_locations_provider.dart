import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';

class WorkerLocationsProvider {
  static WorkerLocationsProvider? _instance;

  final StreamController<List<Location>> _locationsStreamController =
      StreamController();

  List<Location> _workerLocations = [];

  factory WorkerLocationsProvider.initialize(String workerId) {
    if (workerId == null) {
      throw Exception('Worker Id is Null');
    }
    _instance = WorkerLocationsProvider._internal(workerId);

    return _instance!;
  }

  WorkerLocationsProvider._internal(String workerId) {
    final _collection = FirebaseFirestore.instance.collection('locations');

    _collection
        .where('workerId', isEqualTo: workerId)
        .snapshots()
        .listen((event) {
      List<Location> locations = [];

      for (var location in event.docs) {
        locations.add(Location.fromMap({
          'id': location.id,
          ...location.data(),
        }));
      }

      _workerLocations = locations;
      _locationsStreamController.add(_workerLocations);
    });
  }

  factory WorkerLocationsProvider() {
    if (_instance == null) {
      throw Exception(
          'Invoked Worker Locations Provider Before Initialization');
    }
    return _instance!;
  }

  Stream<List<Location>> get stream => _locationsStreamController.stream;

  List<Location> get workerLocations => List.of(_workerLocations);
}
