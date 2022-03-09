import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class CurrentUserProvider {
  static final CurrentUserProvider _instance = CurrentUserProvider._internal();

  static StreamSubscription<DocumentSnapshot>? _subscription;

  static late User _user;

  factory CurrentUserProvider() {
    return _instance;
  }

  factory CurrentUserProvider.initialize(String id) {
    if (_subscription != null) {
      _subscription?.cancel();
    }

    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen(
      (event) {
        _user = User.fromMap(
          {
            'id': id,
            ...event.data()!,
          },
        );
      },
    );

    return _instance;
  }

  CurrentUserProvider._internal();

  User get user => User.fromMap(_user.toMap());
}
