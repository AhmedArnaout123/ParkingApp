import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/user.dart';

class UsersProvider {
  static UsersProvider? _instance;

  final StreamController<List<User>> _usersStreamController =
      StreamController();

  List<User> _users = [];

  UsersProvider._internal() {
    final _collection = FirebaseFirestore.instance.collection('users');

    _collection.snapshots().listen((event) {
      List<User> users = [];

      for (var user in event.docs) {
        users.add(User.fromMap({
          'id': user.id,
          ...user.data(),
        }));
      }

      _users = users;
      _usersStreamController.add(_users);
    });
  }

  factory UsersProvider() {
    _instance ??= UsersProvider._internal();
    return _instance!;
  }

  Stream<List<User>> get stream => _usersStreamController.stream;

  List<User> get users => List.of(_users);
}
