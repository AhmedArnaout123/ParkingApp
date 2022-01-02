import 'package:parking_graduation_app_1/core/services/storage_service.dart';

class CurrentApplicationUserService {
  var storageService = StorageService();

  Future<String> getId() async {
    return await storageService.read('id');
  }

  Future<String> getRole() async {
    return await storageService.read('role');
  }

  Future<String> getName() async {
    return await storageService.read('name');
  }

  Future<void> setName(String name) async {
    await storageService.write('name', name);
  }

  Future<void> setId(String id) async {
    await storageService.write('id', id);
  }

  Future<void> setRole(String role) async {
    await storageService.write('role', role);
  }
}
