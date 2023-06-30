
import 'package:hive/hive.dart';

part 'yearly_holidays.g.dart';

@HiveType(typeId: 89)
class YearlyHolidays {

  @HiveField(0)
  int allowedAmount;

  @HiveField(1)
  List<Holiday> holidays = [];

  YearlyHolidays({required this.allowedAmount});
}

@HiveType(typeId: 90)
class Holiday {

  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  bool consumed;

  Holiday({required this.dateTime, required this.consumed});
}

extension ConsumedHolidaysCount on YearlyHolidays {
  int get consumedCount {
    return holidays.where((holiday) => holiday.consumed).length;
  }
}