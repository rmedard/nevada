import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTools {

  static DateFormat formatter = DateFormat('dd/MM/yyyy');

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

  static DateTime plusMonths(DateTime dateTime, int monthsCount) {
    if (monthsCount > 0) {
      int month = dateTime.month;
      int year = dateTime.year;
      int day = dateTime.day;
      if (month == 12) {
        month = 1;
        ++year;
      } else {
        ++month;
      }
      --monthsCount;
      return plusMonths(DateTime(year, month, day), monthsCount);
    }
    return dateTime;
  }

  static DateTime minusMonths(DateTime dateTime, int monthsCount) {
    if (monthsCount > 0) {
      int month = dateTime.month;
      int year = dateTime.year;
      int day = 1;
      if (month == 1) {
        month = 12;
        --year;
      } else {
        --month;
      }
      --monthsCount;
      return minusMonths(DateTime(year, month, day), monthsCount);
    }
    return dateTime;
  }

  static int countWorkingDays(DateTimeRange dateTimeRange) {
    List<DateTime> dateTimes = [];
    for (int i = 0; i <= dateTimeRange.duration.inDays; i++) {
      dateTimes.add(dateTimeRange.start.add(Duration(days: i)));
    }
    return dateTimes
        .where((dateTime) => dateTime.day != DateTime.saturday && dateTime.day != DateTime.sunday)
        .length;
  }

  static DateTime beginningOfWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime endOfWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: 7 - dateTime.weekday));
  }

}

extension DateTimeExtra on DateTime {
  int get toInt {
    var value = '$year$month$day';
    return int.parse(value);
  }
}