import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/payment.dart';

class PaymentsApiService {
  final _collection = FirebaseFirestore.instance.collection('payments');

  Future<List<Payment>> getPayments() async {
    List<Payment> payments = [];
    await _collection.get().then((query) {
      for (var doc in query.docs) {
        var map = {
          'id': doc.id,
          ...doc.data(),
        };
        payments.add(Payment.fromMap(map));
      }
    });

    return payments;
  }

  Future<List<Payment>> getWorkerPayments(String workerId) async {
    List<Payment> payments = [];
    await _collection
        .where('workerId', isEqualTo: workerId)
        .get()
        .then((query) {
      for (var doc in query.docs) {
        var map = {
          'id': doc.id,
          ...doc.data(),
        };
        payments.add(Payment.fromMap(map));
      }
    });

    return payments;
  }

  Future<String> addPayment(Map<String, dynamic> data) async {
    String id = "";
    await _collection.add(data).then((doc) => id == doc.id);
    return id;
  }
}
