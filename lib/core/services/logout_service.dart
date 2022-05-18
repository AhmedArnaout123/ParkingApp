import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/common/pages/login_page.dart';
import 'package:parking_graduation_app_1/core/services/storage_service.dart';

class LogoutService {
  final _storageService = StorageService();

  Future<void> logout(BuildContext context) async {
    await _storageService.remove("userRole");
    await _storageService.remove("userId");

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}
