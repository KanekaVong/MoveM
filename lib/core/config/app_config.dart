import 'app_environment.dart';

class AppConfig {
  static String get baseUrl {
    switch (AppEnvironment.current) {
      case Environment.dev:
        return 'http://35.225.7.128/api/';
      case Environment.release:
        return 'http://35.225.7.128/api/';
    }
  }

  static String get appTitle {
    switch (AppEnvironment.current) {
      case Environment.dev:
        return 'MoveM Dev';
      case Environment.release:
        return 'MoveM';
    }
  }

  static bool get enableDetailedLogging {
    return AppEnvironment.isDev;
  }

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  /// Turns a stored path such as `profile-pics/photo.jpg` into a loadable URL.
  static String resolveMediaUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final root = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    var relative = path.startsWith('/') ? path.substring(1) : path;
    if (!relative.startsWith('uploads/')) {
      relative = 'uploads/$relative';
    }
    return '$root/$relative';
  }

  static const String storageEncryptionKey = 'MoveM_Secure_Storage_Key_2026_01';
}
