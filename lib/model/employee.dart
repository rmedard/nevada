import 'package:flutter/material.dart';
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
  DateTime dateOfBirth;

  @HiveField(3)
  String placeOfBirth;

  @HiveField(4)
  DateTime entryDate;

  @HiveField(5)
  ContractType contractType;

  @HiveField(6)
  JobTitle jobTitle;

  @HiveField(7)
  int baseSalary;

  @HiveField(8)
  List<SalaryPay> salaryPayments = [];

  @HiveField(9)
  Map<int, YearlyHolidays> holidays = {};

  Employee({required this.uuid, required this.names, required this.dateOfBirth, required this.placeOfBirth, required this.entryDate, required this.contractType, required this.jobTitle, required this.baseSalary});

  static Employee empty() => Employee(
      uuid: const Uuid().v4(),
      names: '',
      entryDate: DateTime.now(),
      baseSalary: 0,
      dateOfBirth: DateTime(1960),
      placeOfBirth: '',
      contractType: ContractType.contractor,
      jobTitle: JobTitle.machinist);
}

@HiveType(typeId: 85)
enum ContractType {
  @HiveField(0, defaultValue: true)
  permanent('Permanent', Colors.blue),
  @HiveField(1)
  contractor('Contractuel', Colors.deepOrange);

  final String label;
  final Color labelColor;

  const ContractType(this.label, this.labelColor);
}

@HiveType(typeId: 86)
enum JobTitle {
  @HiveField(0, defaultValue: true)
  machinist('Machiniste', Colors.green, Color(0xFFD6F4D7)),

  @HiveField(1)
  assistant('Auxiliaire', Colors.deepOrange, Color(0xFFFFE5DB)),

  @HiveField(2)
  seller('Vendeur', Colors.blue, Color(0xFFCDEAFF)),

  @HiveField(3)
  guard('Gardien', Colors.black, Colors.black12);

  final String label;
  final Color labelColor;
  final Color labelContainerColor;
  const JobTitle(this.label, this.labelColor, this.labelContainerColor);

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

  Widget get labelBadge {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: jobTitle.labelContainerColor,
      ),
      child: Center(
        child: Text(jobTitle.label, style: TextStyle(color: jobTitle.labelColor),),
      ),
    );
  }
}