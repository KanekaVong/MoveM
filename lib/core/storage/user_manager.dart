import 'local_storage.dart';
import 'package:uuid/uuid.dart';
import '../utils/Constants.dart';
import 'dart:convert';

import '../../features/auth/data/dto/response/user_response.dart';


class UserManager {
  static final UserManager _instance = UserManager._internal();
  final LocalStorage _storage = LocalStorage();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  // ─── Language ───
  String get languageCode => _storage.getString(Constants.keyLanguageCode) ?? Constants.defaultLanguage;
  Future<void> setLanguage(String code) => _storage.setString(Constants.keyLanguageCode, code);

  // ─── Theme ───
  String get themeMode => _storage.getString(Constants.keyThemeMode) ?? Constants.defaultTheme;
  Future<void> setThemeMode(String mode) => _storage.setString(Constants.keyThemeMode, mode);

  // ─── User Session ───
  String? get userId => _storage.getString(Constants.keyUserId);
  bool get isLoggedIn => _storage.getBool(Constants.keyIsLogged) ?? false;
  Future<void> setLogged(bool value) => _storage.setBool(Constants.keyIsLogged, value);
  Future<void> saveUserId(String id) => _storage.setString(Constants.keyUserId, id);
  String? get userName => _storage.getString(Constants.keyUserName);
  Future<void> saveUserName(String name) => _storage.setString(Constants.keyUserName, name);
  Future<void> saveUser(UserResponse user) async {await _storage.setString(Constants.keyUserData, jsonEncode(user.toJson()),);}
  UserResponse? getUser() {
    final userJson = _storage.getString(Constants.keyUserData);

    if (userJson == null || userJson.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(userJson);

      if (decoded is Map<String, dynamic>) {
        return UserResponse.fromJson(decoded);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  Future<void> clearUser() async {
    await _storage.setString(Constants.keyUserData, '');
  }

  // ─── Token (Secure) ───
  Future<String?> getToken() => _storage.getSecureString(Constants.keyAccessToken);
  Future<void> saveToken(String token) => _storage.setSecureString(Constants.keyAccessToken, token);

  // ─── Trust Token (Secure) ───
  Future<String?> getTrustToken() => _storage.getSecureString(Constants.keyTrustToken);
  Future<void> saveTrustToken(String token) => _storage.setSecureString(Constants.keyTrustToken, token);

  // ─── Device ID (Secure, generated once, persists forever) ───
  Future<String> getOrCreateDeviceId() async {
    String? deviceId = await _storage.getSecureString(Constants.keyDeviceId);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      await _storage.setSecureString(Constants.keyDeviceId, deviceId);
    }
    return deviceId;
  }

  // ─── Clear Session (Logout) — keeps trustToken so this device stays trusted ───
  Future<void> clearSession() async {
    await _storage.clearSecureString(Constants.keyAccessToken);
    await _storage.setString(Constants.keyUserId, '');
    await _storage.setString(Constants.keyUserName, '');
    await _storage.setBool(Constants.keyIsLogged, false);
    // trustToken intentionally NOT cleared — device stays trusted for next login
  }
}
