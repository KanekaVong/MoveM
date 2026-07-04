import 'local_storage.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  final LocalStorage _storage = LocalStorage();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  String get languageCode => _storage.getString('language_code') ?? 'en';
  Future<void> setLanguage(String code) => _storage.setString('language_code', code);

  String get themeMode => _storage.getString('theme_mode') ?? 'system';
  Future<void> setThemeMode(String mode) => _storage.setString('theme_mode', mode);

  String? get userId => _storage.getString('user_id');
  bool get isLoggedIn => userId != null;
  Future<void> saveUserId(String id) => _storage.setString('user_id', id);
  String? get userName => _storage.getString('user_name');
  Future<void> saveUserName(String name) => _storage.setString('user_name', name);

  Future<String?> getToken() => _storage.getSecureString('access_token');
  Future<void> saveToken(String token) => _storage.setSecureString('access_token', token);

  Future<void> clearSession() async {
    await _storage.clearSecureString('access_token');
    await _storage.setString('user_id', '');
    await _storage.setString('user_name', '');
  }
}
