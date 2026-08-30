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

  static const String storageEncryptionKey = 'MoveM_Secure_Storage_Key_2026_01';
}
