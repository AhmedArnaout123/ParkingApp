import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/reservation.dart';
import 'package:parking_graduation_app_1/core/services/current_application_user_service.dart';

class ReservationsApiService {
  var collection = FirebaseFirestore.instance.collection('reservations');

  Future<String> addReservation(Map<String, dynamic> data) async {
    String id = "";
    await collection.add(data).then((doc) => id = doc.id);
    return id;
  }

  Future<Reservation> getCurrentLocationReservation(String? locationId) async {
    var workerId = await CurrentApplicationUserService().getId();
    var query = await collection
        .where('workerId', isEqualTo: workerId)
        .where('isFinished', isEqualTo: false)
        .where('locationId', isEqualTo: locationId)
        .get();

    if (query.docs.length != 1) {
      throw Exception('Unhandeld state');
    }

    var map = {'id': query.docs.first.id, ...query.docs.first.data()};
    return Reservation.fromMap(map);
  }

  Future<void> finishLocationReservation(String? locationId) async {
    var reservation = await getCurrentLocationReservation(locationId);
    collection.doc(reservation.id).update({
      'endDate': DateTime.now().toString().substring(0, 16),
      'isFinished': true
    });
  }
}
