enum Environment { dev, release }

class AppEnvironment {
  static Environment _current = Environment.dev;

  static Environment get current => _current;

  static bool get isDev => _current == Environment.dev;
  static bool get isRelease => _current == Environment.release;

  static void setEnvironment(Environment environment) {
    _current = environment;
  }
}
