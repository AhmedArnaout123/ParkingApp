import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/application_users/user.dart';
import 'package:parking_graduation_app_1/core/models/application_users/worker.dart';

class ApplicationUsersApiService {
  var collection = FirebaseFirestore.instance.collection('users');

  Future<List<Worker>> getWorkers() async {
    List<Worker> workers = [];

    await collection.where('role', isEqualTo: 'worker').get().then((value) {
      for (var doc in value.docs) {
        var map = <String, dynamic>{
          ...doc.data(),
          'id': doc.id,
        };
        workers.add(Worker.fromMap(map));
      }
    });
    return workers;
  }

  Future<List<User>> getUsers() async {
    List<User> users = [];

    await collection.where('role', isEqualTo: 'user').get().then((value) {
      for (var doc in value.docs) {
        var map = <String, dynamic>{...doc.data(), 'id': doc.id};
        users.add(User.fromMap(map));
      }
    });

    return users;
  }
}
