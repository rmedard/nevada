class YearlyHolidays {

  int allowedAmount;
  List<Holiday> holidays = [];

  YearlyHolidays({required this.allowedAmount});
}

class Holiday {
  DateTime dateTime;
  bool consumed;

  Holiday({required this.dateTime, required this.consumed});
}

extension ConsumedHolidaysCount on YearlyHolidays {
  int get consumedCount {
    return holidays.where((holiday) => holiday.consumed).length;
  }
}