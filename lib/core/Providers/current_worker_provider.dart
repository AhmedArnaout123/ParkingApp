import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/accounts/worker.dart';

class CurrentWorkerProvider {
  static final CurrentWorkerProvider _instance =
      CurrentWorkerProvider._internal();

  static StreamSubscription<DocumentSnapshot>? _subscription;

  static late Worker _worker;

  factory CurrentWorkerProvider() {
    return _instance;
  }

  static Future<void> initialize(String id) async {
    if (_subscription != null) {
      _subscription?.cancel();
    }

    var doc =
        await FirebaseFirestore.instance.collection('accounts').doc(id).get();

    _worker = Worker.fromMap({'id': doc.id, ...doc.data()!});

    _subscription = FirebaseFirestore.instance
        .collection('accounts')
        .doc(id)
        .snapshots()
        .listen(
      (doc) {
        _worker = Worker.fromMap(
          {
            'id': id,
            ...doc.data()!,
          },
        );
      },
    );
  }

  CurrentWorkerProvider._internal();

  Worker get worker => Worker.fromMap(_worker.toMap());
}
