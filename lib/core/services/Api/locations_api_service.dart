import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';
import 'package:parking_graduation_app_1/core/Providers/current_worker_provider.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';

class LocationsApiService {
  final _collection = FirebaseFirestore.instance.collection('locations');

  Stream<List<Location>> getLocationsStream() {
    var streamController = StreamController<List<Location>>();

    _collection.snapshots().listen((event) {
      var locations = event.docs.map((doc) {
        var map = {
          'id': doc.id,
          ...doc.data(),
        };
        return Location.fromMap(map);
      }).toList();

      streamController.add(locations);
    });
    return streamController.stream;
  }

  Stream<List<Location>> getWorkerLocationsStream() {
    var streamController = StreamController<List<Location>>();
    _collection
        .where('workerId', isEqualTo: CurrentWorkerProvider().worker.id)
        .snapshots()
        .listen((event) {
      var locations = event.docs.map((doc) {
        var map = {
          'id': doc.id,
          ...doc.data(),
        };
        return Location.fromMap(map);
      }).toList();

      streamController.add(locations);
    });
    return streamController.stream;
  }

  Future<void> getLocation(String? id) async {
    return await _collection.doc(id).get().then((value) => Location.fromMap(
          ({'id': id, ...value.data()!}),
        ));
  }

  Future<String> addLocation(Map<String, dynamic> data) async {
    String id = "";
    await _collection.add(data).then((doc) => id == doc.id);
    return id;
  }

  Future<void> updateLocation(String? id, Map<String, dynamic> data) async {
    await _collection.doc(id).set(data);
  }

  Future<void> deleteLocation(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> reserveLocation(String id, String currentReservationId) async {
    await _collection.doc(id).update({
      'state': ConstantsHelper.locationStates[2],
      'currentReservationId': currentReservationId,
    });
  }

  Future<void> releaseLocation(String? id) async {
    await _collection.doc(id).update({
      'state': ConstantsHelper.locationStates[0],
      'currentReservationId': null,
    });
  }

  Future<List<Location>> getAvailableLocations() async {
    List<Location> locations = [];

    await _collection
        .where('state', isEqualTo: ConstantsHelper.locationStates[0])
        .get()
        .then((query) {
      for (var doc in query.docs) {
        var map = {'id': doc.id, ...doc.data()};
        locations.add(Location.fromMap(map));
      }
    });

    return locations;
  }
}
