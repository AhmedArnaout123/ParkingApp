import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_graduation_app_1/core/models/accounts/accounts.dart';

class AccountsApiService {
  final _collection = FirebaseFirestore.instance.collection('accounts');

  Future<String> addAccount(Map<String, dynamic> data) async {
    String id = "";
    await _collection.add(data).then((doc) => id == doc.id);
    return id;
  }

  Future<Account> login(String userName, String password) async {
    var query = await _collection
        .where('userName', isEqualTo: userName)
        .where('password', isEqualTo: password)
        .get();

    var doc = query.docs.first;
    return Account.fromMap({'id': doc.id, ...doc.data()});
  }

  Future<String> registerUser(
    String fullName,
    String userName,
    String phoneNumber,
    String password,
  ) async {
    String id = "";
    await _collection.add({
      'role': 'user',
      'userName': userName,
      'fullName': fullName,
      'password': password,
      'phoneNumber': phoneNumber,
      'balance': 0,
      'currentReservationId': null
    }).then((doc) => id = doc.id);

    return id;
  }
}
