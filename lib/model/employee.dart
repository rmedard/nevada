import 'package:hive/hive.dart';
import 'package:nevada/model/dtos/holiday_span.dart';
import 'package:nevada/model/dtos/salary_pay.dart';

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
  Map<int, List<HolidaySpan>> holidays = {};

  Employee(this.uuid, this.names, this.entryDate, this.baseSalary);
}