import 'package:hive/hive.dart';
import 'package:nevada/model/dtos/salary_pay.dart';
import 'package:nevada/model/dtos/yearly_holidays.dart';
import 'package:uuid/uuid.dart';

part 'employee.g.dart';

@HiveType(typeId: 8)
class Employee extends HiveObject {

  @HiveField(0)
  String uuid;

  @HiveField(1)
  String names;

  @HiveField(2)
  DateTime entryDate;

  @HiveField(3)
  int baseSalary;

  @HiveField(4)
  List<SalaryPay> salaryPayments = [];

  @HiveField(5)
  Map<int, YearlyHolidays> holidays = {};

  Employee({required this.uuid, required this.names, required this.entryDate, required this.baseSalary});

  static Employee empty() => Employee(
      uuid: const Uuid().v4(),
      names: '',
      entryDate: DateTime.now(),
      baseSalary: 0);
}

extension EmployeeHolidays on Employee {
  int get holidaysLeft {
    int currentYear = DateTime.now().year;
    if (holidays.keys.contains(currentYear)) {
      var yearlyHolidays = holidays[currentYear];
      return yearlyHolidays!.allowedAmount - yearlyHolidays.consumedCount;
    }
    return 0;
  }
}