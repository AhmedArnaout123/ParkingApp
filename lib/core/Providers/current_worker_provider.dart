import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/worker.dart';

class CurrentWorkerProvider {
  static final CurrentWorkerProvider _instance =
      CurrentWorkerProvider._internal();

  static StreamSubscription<DocumentSnapshot>? _subscription;

  static late Worker _worker;

  factory CurrentWorkerProvider() {
    return _instance;
  }

  factory CurrentWorkerProvider.initialize(String id) {
    if (_subscription != null) {
      _subscription?.cancel();
    }

    _subscription = FirebaseFirestore.instance
        .collection('workers')
        .doc(id)
        .snapshots()
        .listen(
      (event) {
        _worker = Worker.fromMap(
          {
            'id': id,
            ...event.data()!,
          },
        );
      },
    );

    return _instance;
  }

  CurrentWorkerProvider._internal();

  Worker get worker => Worker.fromMap(_worker.toMap());
}
