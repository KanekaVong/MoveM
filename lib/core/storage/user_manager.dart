import 'local_storage.dart';
import 'package:uuid/uuid.dart';
import '../utils/Constants.dart';

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
  bool get isLoggedIn => userId != null && userId!.isNotEmpty;
  Future<void> saveUserId(String id) => _storage.setString(Constants.keyUserId, id);
  String? get userName => _storage.getString(Constants.keyUserName);
  Future<void> saveUserName(String name) => _storage.setString(Constants.keyUserName, name);

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
    // trustToken intentionally NOT cleared — device stays trusted for next login
  }
}
