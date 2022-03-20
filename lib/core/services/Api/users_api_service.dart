import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/accounts/user.dart';

class UsersApiService {
  final _collection = FirebaseFirestore.instance.collection('users');

  Stream<List<User>> getUsersStream() {
    var streamController = StreamController<List<User>>();

    _collection.snapshots().listen((event) {
      List<User> users = [];

      for (var user in event.docs) {
        users.add(User.fromMap({
          'id': user.id,
          ...user.data(),
        }));
      }
      streamController.add(users);
    });

    return streamController.stream;
  }

  Stream<User> getUserStream(String userId) {
    var streamController = StreamController<User>();

    _collection.doc(userId).snapshots().listen((event) {
      streamController.add(User.fromMap({
        'id': userId,
        ...event.data()!,
      }));
    });
    return streamController.stream;
  }

  Future<List<User>> getUsers() async {
    List<User> users = [];

    await _collection.get().then((value) {
      for (var doc in value.docs) {
        var map = <String, dynamic>{...doc.data(), 'id': doc.id};
        users.add(User.fromMap(map));
      }
    });

    return users;
  }

  Future<User> getUser(String? id) async {
    var doc = await _collection.doc(id).get();
    return User.fromMap({'id': doc.id, ...doc.data()!});
  }

  Future<void> makeReservation(
    String userId,
    double newBalance,
    String reservationId,
  ) async {
    await _collection.doc(userId).update({
      'balance': newBalance,
      'currentReservationId': reservationId,
    });
  }

  Future<void> finishReservation(String? reservationId) async {
    try {
      var snapShots = await _collection
          .where('currentReservationId', isEqualTo: reservationId)
          .get();
      var userId = snapShots.docs.single.id;
      await _collection.doc(userId).update({'currentReservationId': null});
    } catch (e) {
      return;
    }
  }

  Future<void> addToBalance(String userId, double amount) async {
    var user = await getUser(userId);
    user.balance = user.balance! + amount;
    await _collection.doc(userId).update({'balance': user.balance});
  }

  Future<void> subtractFromBalance(String userId, double amount) async {
    var user = await getUser(userId);
    user.balance = user.balance! - amount;
    await _collection.doc(userId).update({'balance': user.balance});
  }
}
