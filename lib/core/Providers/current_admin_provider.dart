import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin.dart';

class CurrentAdminProvider {
  static final CurrentAdminProvider _instance =
      CurrentAdminProvider._internal();

  static StreamSubscription<DocumentSnapshot>? _subscription;

  static late Admin _admin;

  factory CurrentAdminProvider() {
    return _instance;
  }

  factory CurrentAdminProvider.initialize(String id) {
    if (_subscription != null) {
      _subscription?.cancel();
    }

    _subscription = FirebaseFirestore.instance
        .collection('admins')
        .doc(id)
        .snapshots()
        .listen(
      (event) {
        _admin = Admin.fromMap(
          {
            'id': id,
            ...event.data()!,
          },
        );
      },
    );

    return _instance;
  }

  CurrentAdminProvider._internal();

  Admin get admin => Admin.fromMap(_admin.toMap());
}
