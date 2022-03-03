import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/worker.dart';

class WorkersApiService {
  final _collection = FirebaseFirestore.instance.collection('workers');

  Stream<List<Worker>> getWorkersStream() {
    var streamController = StreamController<List<Worker>>();

    _collection.snapshots().listen((event) {
      List<Worker> workers = [];

      for (var worker in event.docs) {
        workers.add(Worker.fromMap({
          'id': worker.id,
          ...worker.data(),
        }));
      }
      streamController.add(workers);
    });

    return streamController.stream;
  }

  Future<Worker> getWorker(String id) async {
    var doc = await _collection.doc(id).get();
    return Worker.fromMap({'id': id, ...doc.data()!});
  }
}
