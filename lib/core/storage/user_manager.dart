import 'local_storage.dart';
import 'package:uuid/uuid.dart';
import '../utils/Constants.dart';
import 'dart:convert';

import '../../features/auth/data/dto/response/user_response.dart';

import '../config/app_config.dart';
import '../utils/crypto_utils.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  final LocalStorage _storage = LocalStorage();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  String get languageCode => _storage.getString(Constants.keyLanguageCode) ?? Constants.defaultLanguage;
  Future<void> setLanguage(String code) => _storage.setString(Constants.keyLanguageCode, code);

  String get themeMode => _storage.getString(Constants.keyThemeMode) ?? Constants.defaultTheme;
  Future<void> setThemeMode(String mode) => _storage.setString(Constants.keyThemeMode, mode);

  String? get userId => _storage.getString(Constants.keyUserId);
  bool get isLoggedIn => _storage.getBool(Constants.keyIsLogged) ?? false;
  Future<void> setLogged(bool value) => _storage.setBool(Constants.keyIsLogged, value);
  Future<void> saveUserId(String id) => _storage.setString(Constants.keyUserId, id);
  String? get userName => _storage.getString(Constants.keyUserName);
  Future<void> saveUserName(String name) => _storage.setString(Constants.keyUserName, name);
  Future<void> saveUser(UserResponse user) async {
    final rawJson = jsonEncode(user.toJson());
    final encryptedData = CryptoUtils.encryptAES(rawJson, AppConfig.storageEncryptionKey);
    await _storage.setString(Constants.keyUserData, encryptedData);
    if (user.id.isNotEmpty) await saveUserId(user.id);
    final fullName = [user.firstName, user.lastName]
        .where((v) => v != null && v.trim().isNotEmpty)
        .join(' ');
    await saveUserName(fullName.isNotEmpty ? fullName : user.username);
  }

  UserResponse? getUser() {
    final storedData = _storage.getString(Constants.keyUserData);

    if (storedData == null || storedData.isEmpty) {
      return null;
    }

    try {
      String jsonStr;
      try {
        jsonStr = CryptoUtils.decryptAES(storedData, AppConfig.storageEncryptionKey);
      } catch (_) {
        jsonStr = storedData;
      }

      final decoded = jsonDecode(jsonStr);

      if (decoded is Map) {
        return UserResponse.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  Future<void> clearUser() async {
    await _storage.remove(Constants.keyUserData);
  }

  Future<String?> getToken() => _storage.getSecureString(Constants.keyAccessToken);
  Future<void> saveToken(String token) => _storage.setSecureString(Constants.keyAccessToken, token);

  Future<String?> getTrustToken() => _storage.getSecureString(Constants.keyTrustToken);
  Future<void> saveTrustToken(String token) => _storage.setSecureString(Constants.keyTrustToken, token);

  Future<String?> getFcmToken() => _storage.getSecureString(Constants.keyFcmToken);
  Future<void> saveFcmToken(String token) => _storage.setSecureString(Constants.keyFcmToken, token);

  Future<String> getOrCreateDeviceId() async {
    String? deviceId = await _storage.getSecureString(Constants.keyDeviceId);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      await _storage.setSecureString(Constants.keyDeviceId, deviceId);
    }
    return deviceId;
  }

  Future<void> clearSession() async {
    await _storage.clearSecureString(Constants.keyAccessToken);
    await _storage.remove(Constants.keyUserId);
    await _storage.remove(Constants.keyUserName);
    await _storage.remove(Constants.keyIsLogged);
    await clearUser();
  }
}
