import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<dynamic> read(String key) async {
    var instance = await SharedPreferences.getInstance();
    return instance.get(key);
  }

  Future<bool> write(String key, dynamic value) async {
    var instance = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case double:
        return instance.setDouble(key, value);
      case int:
        return instance.setInt(key, value);
      case bool:
        return instance.setBool(key, value);
      case String:
        return instance.setString(key, value);
      default:
        throw Exception('the value type can\'t be stored');
    }
  }

  Future<bool> remove(String key) async {
    var instance = await SharedPreferences.getInstance();
    if (instance.containsKey(key)) {
      return instance.remove(key);
    }
    return false;
  }
}
