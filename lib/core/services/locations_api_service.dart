import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';
import 'package:parking_graduation_app_1/core/models/location.dart';

class LocationsApiService {
  final _collection = FirebaseFirestore.instance.collection('locations');

  Future<List<Location>> getLocations() async {
    List<Location> locations = [];
    await _collection.get().then((query) {
      for (var doc in query.docs) {
        var map = {
          'id': doc.id,
          ...doc.data(),
        };
        locations.add(Location.fromMap(map));
      }
    });

    return locations;
  }

  Future<List<Location>> getWorkerLocations(String workerId) async {
    List<Location> locations = [];
    await _collection
        .where('workerId', isEqualTo: workerId)
        .get()
        .then((query) {
      for (var doc in query.docs) {
        var map = {
          'id': doc.id,
          ...doc.data(),
        };
        locations.add(Location.fromMap(map));
      }
    });

    return locations;
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

  Future<void> reserveLocation(String? id) async {
    await _collection
        .doc(id)
        .update({'state': ConstantsHelper.locationStates[2]});
  }

  Future<void> releaseLocation(String? id) async {
    await _collection
        .doc(id)
        .update({'state': ConstantsHelper.locationStates[0]});
  }
}
