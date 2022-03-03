import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/payment.dart';

class PaymentsProvider {
  static PaymentsProvider? _instance;

  final StreamController<List<Payment>> _paymentsStreamController =
      StreamController();

  List<Payment> _payments = [];

  PaymentsProvider._internal() {
    final _collection = FirebaseFirestore.instance.collection('payments');

    _collection.snapshots().listen((event) {
      List<Payment> payments = [];

      for (var payment in event.docs) {
        payments.add(Payment.fromMap({
          'id': payment.id,
          ...payment.data(),
        }));
      }

      _payments = payments;
      _paymentsStreamController.add(_payments);
    });
  }

  factory PaymentsProvider() {
    _instance ??= PaymentsProvider._internal();
    return _instance!;
  }

  Stream<List<Payment>> get stream => _paymentsStreamController.stream;

  List<Payment> get payments => List.of(_payments);
}
