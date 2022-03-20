import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/reservation.dart';

class ReservationsApiService {
  final _collection = FirebaseFirestore.instance.collection('reservations');

  Stream<List<Reservation>> getReservationsStream() {
    var streamController = StreamController<List<Reservation>>();

    _collection.snapshots().listen((event) {
      List<Reservation> reservations = [];

      for (var reservation in event.docs) {
        reservations.add(Reservation.fromMap({
          'id': reservation.id,
          ...reservation.data(),
        }));
      }
      streamController.add(reservations);
    });

    return streamController.stream;
  }

  Stream<Reservation> getReservationStream(String? id) {
    var streamController = StreamController<Reservation>();

    _collection.doc(id).snapshots().listen((event) {
      streamController.add(Reservation.fromMap({
        'id': event.id,
        ...event.data()!,
      }));
    });

    return streamController.stream;
  }

  Future<String> addReservation(Map<String, dynamic> data) async {
    String id = "";
    await _collection.add(data).then((doc) => id = doc.id);
    return id;
  }

  Future<void> finishReservation(String? reservationId) async {
    _collection.doc(reservationId).update({
      'endDate': DateTime.now().toString().substring(0, 16),
      'isFinished': true
    });
  }

  Future<void> extendReservation(
      String? reservationId, String newDate, double newCost) async {
    await _collection.doc(reservationId).update({
      'endDate': newDate,
      'cost': newCost,
    });
  }
}
