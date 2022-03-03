import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/user.dart';
import 'package:parking_graduation_app_1/core/models/worker.dart';

class UsersApiService {
  var collection = FirebaseFirestore.instance.collection('users');

  Future<List<Worker>> getWorkers() async {
    List<Worker> workers = [];

    await collection.where('role', isEqualTo: 'worker').get().then((value) {
      for (var doc in value.docs) {
        var map = <String, dynamic>{
          ...doc.data(),
          'id': doc.id,
        };
        workers.add(Worker.fromMap(map));
      }
    });
    return workers;
  }

  Future<Worker> getWorker(String? id) async {
    List<Worker> worker = await getWorkers();
    return worker.singleWhere((element) => element.id == id);
  }

  Future<List<User>> getUsers() async {
    List<User> users = [];

    await collection.where('role', isEqualTo: 'user').get().then((value) {
      for (var doc in value.docs) {
        var map = <String, dynamic>{...doc.data(), 'id': doc.id};
        users.add(User.fromMap(map));
      }
    });

    return users;
  }

  Future<User> getUser(String? id) async {
    List<User> users = await getUsers();
    return users.singleWhere((element) => element.id == id);
  }

  Future<void> makeReservation(
    String userId,
    double newBalance,
    String reservationId,
  ) async {
    await collection.doc(userId).update({
      'balance': newBalance,
      'currentReservationId': reservationId,
    });
  }

  Future<void> addToBalance(String userId, double amount) async {
    var user = await getUser(userId);
    user.balance = user.balance! + amount;
    await collection.doc(userId).update({'balance': user.balance});
  }
}
