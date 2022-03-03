import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class CurrentUserProvider {
  static CurrentUserProvider? _instance;

  final StreamController<User> _userStreamController = StreamController();

  User _user = User();

  factory CurrentUserProvider.initialize(String id) {
    if (id == null) {
      throw Exception('User Id is Null');
    }
    _instance = CurrentUserProvider._internal(id);

    return _instance!;
  }

  CurrentUserProvider._internal(String id) {
    final _collection = FirebaseFirestore.instance.collection('users');

    _collection.doc(id).snapshots().listen((event) {
      var user = User.fromMap({'id': id, ...event.data()!});
      _user = user;
      _userStreamController.add(user);
    });
  }

  factory CurrentUserProvider() {
    if (_instance == null) {
      throw Exception('Invoked User Provider Before Initialization');
    }
    return _instance!;
  }

  Stream<User> get stream => _instance == null
      ? throw Exception('Invoked User Provider Before Initialization')
      : _userStreamController.stream;

  User get user => _instance == null
      ? throw Exception('Invoked User Provider Before Initialization')
      : User.fromMap(_user.toMap());
}
