import 'package:intl/intl.dart';

class DateTools {

  static DateFormat basicDateFormatter = DateFormat('dd/MM/yyyy');

  static DateTime toEndOfDay(DateTime dateTime) {
    return dateTime
        .subtract(Duration(hours: dateTime.hour, minutes: dateTime.minute, seconds: dateTime.second))
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
  }

  static DateTime toStartOfDay(DateTime dateTime) {
    return dateTime
        .subtract(Duration(hours: dateTime.hour, minutes: dateTime.minute, seconds: dateTime.second))
        .add(const Duration(hours: 00, minutes: 00, seconds: 00));
  }
}