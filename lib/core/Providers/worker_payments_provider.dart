import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/payment.dart';

class WorkerPaymentsProvider {
  static WorkerPaymentsProvider? _instance;

  final StreamController<List<Payment>> _paymentsStreamController =
      StreamController();

  List<Payment> _workerPayments = [];

  factory WorkerPaymentsProvider.initialize(String workerId) {
    if (workerId == null) {
      throw Exception('Worker Id is Null');
    }
    _instance = WorkerPaymentsProvider._internal(workerId);

    return _instance!;
  }

  WorkerPaymentsProvider._internal(String workerId) {
    final _collection = FirebaseFirestore.instance.collection('payments');

    _collection
        .where('workerId', isEqualTo: workerId)
        .snapshots()
        .listen((event) {
      List<Payment> payments = [];

      for (var payment in event.docs) {
        payments.add(Payment.fromMap({
          'id': payment.id,
          ...payment.data(),
        }));
      }

      _workerPayments = payments;
      _paymentsStreamController.add(_workerPayments);
    });
  }

  factory WorkerPaymentsProvider() {
    if (_instance == null) {
      throw Exception('Invoked Worker Payments Provider Before Initialization');
    }
    return _instance!;
  }

  Stream<List<Payment>> get stream => _paymentsStreamController.stream;

  List<Payment> get workerPayments => List.of(_workerPayments);
}
