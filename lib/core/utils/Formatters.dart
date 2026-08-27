import 'package:intl/intl.dart';

class Formatters {
  static String date(DateTime date){
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }
}
