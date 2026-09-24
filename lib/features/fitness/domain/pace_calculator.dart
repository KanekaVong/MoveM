class PaceCalculator {

  static double paceMinPerKm(double totalMeters, Duration elapsed) {
    if (totalMeters <= 0) return 0;
    final km = totalMeters / 1000;
    return elapsed.inSeconds / 60 / km;
  }

  static double strideMeters({double heightCm = 0}) {
    if (heightCm >= 120 && heightCm <= 230) {
      return (heightCm / 100) * 0.415;
    }
    return 0.762;
  }

  static int stepsForDistance(double meters, {double heightCm = 0}) {
    if (meters <= 0) return 0;
    return (meters / strideMeters(heightCm: heightCm)).round();
  }

  /// About 1.036 kcal per kg per km, the usual level-ground running estimate.
  static int caloriesForRun(double meters, {double weightKg = 0}) {
    if (meters <= 0) return 0;
    final kg = (weightKg >= 30 && weightKg <= 250) ? weightKg : 70.0;
    return ((meters / 1000) * kg * 1.036).round();
  }

  static String formatPace(double minPerKm) {
    if (minPerKm <= 0 || minPerKm.isNaN || minPerKm.isInfinite) return '--:-- /km';
    final minutes = minPerKm.floor();
    final seconds = ((minPerKm - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
  }
}
