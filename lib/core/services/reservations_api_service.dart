import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/reservation.dart';

class ReservationsApiService {
  final _collection = FirebaseFirestore.instance.collection('reservations');

  Future<String> addReservation(Map<String, dynamic> data) async {
    String id = "";
    await _collection.add(data).then((doc) => id = doc.id);
    return id;
  }

  // Future<Reservation> getCurrentLocationReservation(String? locationId) async {
  //   var query = await _collection
  //       .where('workerId', isEqualTo: workerId)
  //       .where('isFinished', isEqualTo: false)
  //       .where('locationId', isEqualTo: locationId)
  //       .get();

  //   if (query.docs.length != 1) {
  //     throw Exception('Unhandeld state');
  //   }

  //   var map = {'id': query.docs.first.id, ...query.docs.first.data()};
  //   return Reservation.fromMap(map);
  // }

  Future<void> finishReservation(String? reservationId) async {
    _collection.doc(reservationId).update({
      'endDate': DateTime.now().toString().substring(0, 16),
      'isFinished': true
    });
  }
}
