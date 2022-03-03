import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin.dart';

class CurrentAdminProvider {
  static CurrentAdminProvider? _instance;

  final StreamController<Admin> _adminStreamController = StreamController();

  Admin _admin = Admin();

  factory CurrentAdminProvider.initialize(String id) {
    if (id == null) {
      throw Exception('Admin Id is Null');
    }
    _instance = CurrentAdminProvider._internal(id);

    return _instance!;
  }

  CurrentAdminProvider._internal(String id) {
    final _collection = FirebaseFirestore.instance.collection('admins');

    _collection.doc(id).snapshots().listen((event) {
      var admin = Admin.fromMap({'id': id, ...event.data()!});
      _admin = admin;
      _adminStreamController.add(admin);
    });
  }

  factory CurrentAdminProvider() {
    if (_instance == null) {
      throw Exception('Invoked Admin Provider Before Initialization');
    }
    return _instance!;
  }

  Stream<Admin> get stream => _instance == null
      ? throw Exception('Invoked Admin Provider Before Initialization')
      : _adminStreamController.stream;

  Admin get admin => _instance == null
      ? throw Exception('Invoked Admin Provider Before Initialization')
      : Admin.fromMap(_admin.toMap());
}
