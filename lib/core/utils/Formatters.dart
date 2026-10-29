import 'package:intl/intl.dart';

class Formatters {
  static String date(DateTime date){
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }

  /// Workout distance: meters under 1 km, otherwise km with at most one decimal.
  static String distanceKm(double km) {
    if (km >= 1) {
      return km % 1 == 0 ? '${km.toInt()}KM' : '${km.toStringAsFixed(1)}KM';
    }
    return '${(km * 1000).round()}M';
  }
}
