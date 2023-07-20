import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/dtos/salary_pay.dart';
import 'package:nevada/model/dtos/yearly_holidays.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/transactions_service.dart';
import 'package:nevada/utils/date_tools.dart';
import 'package:uuid/uuid.dart';

class EmployeesService extends BaseService<Employee> {
  Future<bool> paySalary(Employee employee, SalaryPay salaryPay) {
    if (!salaryPay.isValid) {
      return Future.value(false);
    }
    employee.salaryPayments.add(salaryPay);
    return employee.save().then((value) {
      var transaction = Transaction(
          uuid: const Uuid().v4(),
          amount: salaryPay.amount,
          type: TransactionType.expense,
          senderUuid: 'Nevada',
          deliveryUuid: '',
          status: TransactionStatus.paid,
          createdAt: DateTime.now());
      return TransactionsService().createNew(transaction.uuid, transaction);
    });
  }

  Future<void> createEmployeeHolidays(Employee employee, DateTimeRange selectedRange) {
    var generateWithDayStep = selectedRange.toListOfDates;
    Map<int, Set<DateTime>> groupSetsBy = generateWithDayStep.toSet().groupSetsBy((date) => date.year);
    int defaultMaxYearlyHolidays = ConfigurationsService().maximumYearlyHolidays();
    groupSetsBy.forEach((year, days) {
      YearlyHolidays yearlyHolidays = employee.holidays[year] ?? YearlyHolidays(allowedAmount: defaultMaxYearlyHolidays);
      List<Holiday> holidays = yearlyHolidays.holidays;
      days.removeWhere((newHoliday) => holidays.any((existingHoliday) =>
          existingHoliday.dateTime.toInt == newHoliday.toInt));
      for (var day in days) {
        holidays.add(Holiday(dateTime: day, consumed: false));
      }
      employee.holidays[year] = yearlyHolidays;
    });
    return employee.save();
  }

  YearlyHolidays getYearlyHolidays(Employee employee, int year) {
    return employee.holidays[year] ?? YearlyHolidays(allowedAmount: 20);
  }

  int countYearlyHolidaysDates(Employee employee, int year) {
    var holidaySpans = computeHolidaySpans(employee, year);
    if (holidaySpans.isEmpty) {
      return 0;
    }
    return holidaySpans.values.reduce((span1, span2) => span1 + span2);
  }

  Map<DateTimeRange, int> computeHolidaySpans(Employee employee, int year) {
    YearlyHolidays yearlyHolidays = getYearlyHolidays(employee, year);
    Map<DateTimeRange, int> holidaysCount = {};

    if (yearlyHolidays.holidays.isNotEmpty) {
      var holidayDates = yearlyHolidays.holidays.sortedBy((holiday) => holiday.dateTime).map((holiday) => holiday.dateTime);
      DateTime startDate = holidayDates.first;
      if (holidayDates.length == 1) {
        var range = DateTimeRange(start: startDate, end: startDate);
        holidaysCount.putIfAbsent(range, () => DateTools.countWorkingDays(range));
      } else {
        for (int i = 1; i < holidayDates.length; i++) {
          var previousDate = holidayDates.elementAt(i - 1);
          var currentDate = holidayDates.elementAt(i);
          if (currentDate.subtract(const Duration(days: 1)).toInt == previousDate.toInt) {
            continue;
          } else {
            var range = DateTimeRange(start: startDate, end: previousDate);
            holidaysCount.putIfAbsent(range, () => DateTools.countWorkingDays(range));
            startDate = currentDate;
          }
        }
      }
    }
    return holidaysCount;
  }
}
