import 'package:flutter/foundation.dart';

import '../../../core/services/fcm_service.dart';
import '../../../core/storage/user_manager.dart';
import 'repositories/auth_repository_impl.dart';
import 'services/auth_service.dart';

/// Sends the Firebase token to POST /api/auth/device after a session exists.
class DeviceRegistration {
  static String? _registeredToken;
  static Future<void> _queue = Future.value();

  static void reset() {
    _registeredToken = null;
  }

  static String get platform {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return defaultTargetPlatform.name;
    }
  }

  /// Does not throw. Login continues even when this request fails.
  static Future<void> registerIfLoggedIn() {
    final run = _queue.then((_) => _register());
    _queue = run.catchError((_) {});
    return run;
  }

  static Future<void> _register() async {
    try {
      if (!UserManager().isLoggedIn) return;

      final token = await FcmService().getToken();
      if (token == null || token.isEmpty) return;
      if (token == _registeredToken) return;

      final result = await AuthRepositoryImpl(authService: AuthService()).registerDevice(
        deviceToken: token,
        platform: platform,
      );
      if (result.isSuccess) {
        _registeredToken = token;
      }
    } catch (_) {}
  }
}
