import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/worker.dart';

class CurrentWorkerProvider {
  static CurrentWorkerProvider? _instance;

  final StreamController<Worker> _workerStreamController = StreamController();

  Worker _worker = Worker();

  factory CurrentWorkerProvider.initialize(String id) {
    if (id == null) {
      throw Exception('Worker Id is Null');
    }
    _instance = CurrentWorkerProvider._internal(id);

    return _instance!;
  }

  CurrentWorkerProvider._internal(String id) {
    final _collection = FirebaseFirestore.instance.collection('workers');

    _collection.doc(id).snapshots().listen((event) {
      var worker = Worker.fromMap({'id': id, ...event.data()!});
      _worker = worker;
      _workerStreamController.add(worker);
    });
  }

  factory CurrentWorkerProvider() {
    if (_instance == null) {
      throw Exception('Invoked Worker Provider Before Initialization');
    }
    return _instance!;
  }

  Stream<Worker> get stream => _instance == null
      ? throw Exception('Invoked Worker Provider Before Initialization')
      : _workerStreamController.stream;

  Worker get worker => _instance == null
      ? throw Exception('Invoked Worker Provider Before Initialization')
      : Worker.fromMap(_worker.toMap());
}
