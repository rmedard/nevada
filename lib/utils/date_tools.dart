import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/services/configurations_service.dart';

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

  static DateTime beginningOfWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime endOfWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: 7 - dateTime.weekday));
  }

  static String toDayName(int day) {
    switch(day) {
      case 1:
        return 'Lundi';
      case 2:
        return 'Mardi';
      case 3:
        return 'Mercredi';
      case 4:
        return 'Jeudi';
      case 5:
        return 'Vendredi';
      case 6:
        return 'Samedi';
      case 7:
        return 'Dimanche';
      default:
        throw Exception('Invalid day');
    }
  }

  static bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.toInt == dateTime2.toInt;
  }
}

extension DateTimeExtra on DateTime {
  int get toInt {
    var value = '$year$month$day';
    return int.parse(value);
  }

  String get toBasicDateStr {
    return DateFormat('dd/MM/y').format(this);
  }

  DateTime get dayAfter {
    return add(const Duration(days: 1));
  }

  DateTime get dayBefore {
    return subtract(const Duration(days: 1));
  }
}

extension DateTimeRangeExtra on DateTimeRange {
  List<DateTime> get toListOfDates {
    List<DateTime> dates = [];
    for (int i = 0; i <= duration.inDays; i++) {
      dates.add(start.add(Duration(days: i)));
    }
    return dates;
  }

  int get workingDaysCount {
    return toListOfDates
        .where((element) => !ConfigurationsService().getWeekendDays().contains(element.weekday))
        .length;
  }
}