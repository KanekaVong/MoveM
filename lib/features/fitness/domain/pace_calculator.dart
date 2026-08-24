class PaceCalculator {

  static double paceMinPerKm(double totalMeters, Duration elapsed) {
    if (totalMeters <= 0) return 0;
    final km = totalMeters / 1000;
    return elapsed.inSeconds / 60 / km;
  }

  static String formatPace(double minPerKm) {
    if (minPerKm <= 0 || minPerKm.isNaN || minPerKm.isInfinite) return '--:-- /km';
    final minutes = minPerKm.floor();
    final seconds = ((minPerKm - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
  }
}
