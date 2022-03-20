import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/accounts/user.dart';

class UsersApiService {
  final _collection = FirebaseFirestore.instance.collection('accounts');

  Stream<List<User>> getUsersStream() {
    var streamController = StreamController<List<User>>();

    _collection.where("role", isEqualTo: "user").snapshots().listen((event) {
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

  Future<List<User>> getUsersFuture() async {
    List<User> users = [];

    await _collection.where("role", isEqualTo: "user").get().then((value) {
      for (var doc in value.docs) {
        var map = <String, dynamic>{...doc.data(), 'id': doc.id};
        users.add(User.fromMap(map));
      }
    });

    return users;
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

  Future<User> getUserFuture(String id) async {
    var doc = await _collection.doc(id).get();
    return User.fromMap({'id': doc.id, ...doc.data()!});
  }

  Future<void> makeReservation(
    String userId,
    int newBalance,
    String reservationId,
  ) async {
    await _collection.doc(userId).update({
      'balance': newBalance,
      'currentReservationId': reservationId,
    });
  }

  Future<void> finishReservation(String userId) async {
    await _collection.doc(userId).update({'currentReservationId': null});
  }

  Future<void> addToBalance(String userId, int amount) async {
    var user = await getUserFuture(userId);
    user.balance = user.balance! + amount;
    await _collection.doc(userId).update({'balance': user.balance});
  }

  Future<void> subtractFromBalance(String userId, int amount) async {
    var user = await getUserFuture(userId);
    user.balance = user.balance! - amount;
    await _collection.doc(userId).update({'balance': user.balance});
  }
}
