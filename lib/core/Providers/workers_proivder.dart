import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/worker.dart';

class WorkersProvider {
  static WorkersProvider? _instance;

  final StreamController<List<Worker>> _workersStreamController =
      StreamController();

  List<Worker> _workers = [];

  WorkersProvider._internal() {
    final _collection = FirebaseFirestore.instance.collection('workers');

    _collection.snapshots().listen((event) {
      List<Worker> workers = [];

      for (var worker in event.docs) {
        workers.add(Worker.fromMap({
          'id': worker.id,
          ...worker.data(),
        }));
      }

      _workers = workers;
      _workersStreamController.add(_workers);
    });
  }

  factory WorkersProvider() {
    _instance ??= WorkersProvider._internal();
    return _instance!;
  }

  Stream<List<Worker>> get stream => _workersStreamController.stream;

  List<Worker> get workers => List.of(_workers);
}
