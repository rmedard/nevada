import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:nevada/model/dtos/salary_pay.dart';
import 'package:nevada/model/dtos/yearly_holidays.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/transactions_service.dart';
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
    var generateWithDayStep = DTU.generateWithDayStep(selectedRange.start, selectedRange.end);
    Map<int, Set<DateTime>> groupSetsBy = generateWithDayStep.toSet().groupSetsBy((element) => element.year);
    groupSetsBy.forEach((year, days) {
      YearlyHolidays yearlyHolidays = employee.holidays[year] ?? YearlyHolidays(allowedAmount: 20);
      var holidays = yearlyHolidays.holidays;
      for (var day in days) {
        holidays.add(Holiday(dateTime: day, consumed: false));
      }
      employee.holidays[year] = yearlyHolidays;
    });
    return employee.save();
  }
}