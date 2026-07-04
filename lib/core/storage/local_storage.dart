import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  late SharedPreferences _sharedPrefs;
  late FlutterSecureStorage _secureStorage;

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
  }

  Future<void> setString(String key, String value) async {
    await _sharedPrefs.setString(key, value);
  }

  String? getString(String key) {
    return _sharedPrefs.getString(key);
  }

  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }
  
  Future<void> clearSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }
}
