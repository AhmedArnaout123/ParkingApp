import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/accounts/user.dart';

class CurrentUserProvider {
  static final CurrentUserProvider _instance = CurrentUserProvider._internal();

  static StreamSubscription<DocumentSnapshot>? _subscription;

  static late User _user;

  factory CurrentUserProvider() {
    return _instance;
  }

  static Future<void> initialize(String id) async {
    if (_subscription != null) {
      _subscription?.cancel();
    }

    var doc =
        await FirebaseFirestore.instance.collection('accounts').doc(id).get();

    _user = User.fromMap({'id': doc.id, ...doc.data()!});
    _subscription = FirebaseFirestore.instance
        .collection('accounts')
        .doc(id)
        .snapshots()
        .listen(
      (doc) {
        _user = User.fromMap(
          {
            'id': id,
            ...doc.data()!,
          },
        );
      },
    );
  }

  CurrentUserProvider._internal();

  User get user => User.fromMap(_user.toMap());
}
