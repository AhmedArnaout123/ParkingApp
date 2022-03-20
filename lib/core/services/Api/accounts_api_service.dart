import 'package:cloud_firestore/cloud_firestore.dart';

class AccountApiService {
  final _collection = FirebaseFirestore.instance.collection('accounts');

  Future<String> addAccount(Map<String, dynamic> data) async {
    String id = "";
    await _collection.add(data).then((doc) => id == doc.id);
    return id;
  }
}
