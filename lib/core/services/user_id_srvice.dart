import 'package:parking_graduation_app_1/core/services/storage_service.dart';

class UserIdService {
  Future<String> getCurrentUserId() async {
    var storageService = StorageService();

    return await storageService.read('id');
  }
}
