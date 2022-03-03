import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/reservation.dart';

class ReservationProvider {
  static ReservationProvider? _instance;

  final StreamController<List<Reservation>> _reservationsStreamController =
      StreamController();

  List<Reservation> _reservations = [];

  ReservationProvider._internal() {
    final _collection = FirebaseFirestore.instance.collection('reservations');

    _collection.snapshots().listen((event) {
      List<Reservation> reservations = [];

      for (var reservation in event.docs) {
        reservations.add(Reservation.fromMap({
          'id': reservation.id,
          ...reservation.data(),
        }));
      }

      _reservations = reservations;
      _reservationsStreamController.add(_reservations);
    });
  }

  factory ReservationProvider() {
    _instance ??= ReservationProvider._internal();
    return _instance!;
  }

  Stream<List<Reservation>> get stream => _instance == null
      ? throw Exception('Invoked Reservation Provider Before Initialization')
      : _reservationsStreamController.stream;

  List<Reservation> get reservations => _instance == null
      ? throw Exception('Invoked Reservation Provider Before Initialization')
      : List.of(_reservations);
}
