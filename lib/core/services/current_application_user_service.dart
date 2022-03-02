import 'package:parking_graduation_app_1/core/models/application_users/admin.dart';
import 'package:parking_graduation_app_1/core/models/application_users/user.dart';
import 'package:parking_graduation_app_1/core/models/application_users/worker.dart';
import 'package:parking_graduation_app_1/core/services/storage_service.dart';

class CurrentApplicationUserService {
  static final CurrentApplicationUserService _instance =
      CurrentApplicationUserService._internal();

  CurrentApplicationUserService._internal();

  factory CurrentApplicationUserService() {
    return _instance;
  }

  User? _cashedUser = null;
  Admin? _cashedAdmin = null;
  Worker? _cashedWorker = null;

  Future<User> getCurrentUser() async {
    if (_cashedUser != null) {
      return _cashedUser!;
    }

    var user = User();
    var storageService = StorageService();

    user.id = await storageService.read('id');
    user.role = await storageService.read('role');
    user.balance = await storageService.read('balance');
    user.name = await storageService.read('name');
    user.phoneNumber = await storageService.read('phoneNumber');
    user.userName = await storageService.read('userName');

    _cashedUser = user;
    return user;
  }

  Future<void> setOrUpdateUser(User user) async {
    _cashedUser = user;

    var storageService = StorageService();

    storageService.write('id', user.id);
    storageService.write('role', user.role);
    storageService.write('balance', user.balance);
    storageService.write('name', user.name);
    storageService.write('phoneNumber', user.phoneNumber);
    storageService.write('userName', user.userName);
  }

  Future<Admin> getCurrentAdmin() async {
    if (_cashedAdmin != null) {
      return _cashedAdmin!;
    }

    var admin = Admin();
    var storageService = StorageService();

    admin.id = await storageService.read('id');
    admin.role = await storageService.read('role');
    admin.name = await storageService.read('name');
    admin.phoneNumber = await storageService.read('phoneNumber');
    admin.userName = await storageService.read('userName');

    _cashedAdmin = admin;
    return admin;
  }

  Future<void> setOrUpdateAdmin(Admin admin) async {
    _cashedAdmin = admin;

    var storageService = StorageService();

    storageService.write('id', admin.id);
    storageService.write('role', admin.role);
    storageService.write('name', admin.name);
    storageService.write('phoneNumber', admin.phoneNumber);
    storageService.write('userName', admin.userName);
  }

  Future<Worker> getCurrentWorker() async {
    if (_cashedWorker != null) {
      return _cashedWorker!;
    }

    var worker = Worker();
    var storageService = StorageService();

    worker.id = await storageService.read('id');
    worker.role = await storageService.read('role');
    worker.name = await storageService.read('name');
    worker.phoneNumber = await storageService.read('phoneNumber');
    worker.userName = await storageService.read('userName');

    _cashedWorker = worker;
    return worker;
  }

  Future<void> setOrUpdateWorker(Worker worker) async {
    _cashedWorker = worker;

    var storageService = StorageService();

    storageService.write('id', worker.id);
    storageService.write('role', worker.role);
    storageService.write('name', worker.name);
    storageService.write('phoneNumber', worker.phoneNumber);
    storageService.write('userName', worker.userName);
  }

  Future<String> getId() async {
    return await StorageService().read('id');
  }
}
