import 'local_storage.dart';
import 'package:uuid/uuid.dart';
import '../utils/Constants.dart';
import 'dart:convert';

import 'saved_account.dart';

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

  Future<List<SavedAccount>> getSavedAccounts() async {
    final jsonString =
    _storage.getString(Constants.keySavedAccounts);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .map(
            (item) => SavedAccount.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAccount(SavedAccount account) async {
    final accounts = await getSavedAccounts();

    accounts.removeWhere(
          (saved) => saved.user.id == account.user.id,
    );

    accounts.add(account);

    await _storage.setString(
      Constants.keySavedAccounts,
      jsonEncode(
        accounts.map((account) => account.toJson()).toList(),
      ),
    );
  }

  Future<bool> isAccountSaved(String userId) async {
    final accounts = await getSavedAccounts();

    return accounts.any(
          (account) => account.user.id == userId,
    );
  }

  Future<void> removeSavedAccount(String userId) async {
    final accounts = await getSavedAccounts();

    accounts.removeWhere(
          (account) => account.user.id == userId,
    );

    await _storage.setString(
      Constants.keySavedAccounts,
      jsonEncode(
        accounts.map((account) => account.toJson()).toList(),
      ),
    );
  }

  Future<void> saveCurrentAccountToSavedAccounts() async {
    final user = getUser();
    final accessToken = await getToken();
    final trustToken = await getTrustToken();

    if (user == null ||
        accessToken == null ||
        trustToken == null) {
      return;
    }

    await saveAccount(
      SavedAccount(
        accessToken: accessToken,
        trustToken: trustToken,
        user: user,
      ),
    );
  }

  Future<void> activateAccount(SavedAccount account) async {
    await saveUser(account.user);
    await saveToken(account.accessToken);
    await saveTrustToken(account.trustToken);

    await saveUserId(account.user.id.toString());
    await saveUserName(account.user.username);

    await setLogged(true);
  }

  // ─── Token (Secure) ───
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
