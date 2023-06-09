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
      dateOfBirth: DateTime(1900),
      placeOfBirth: '',
      contractType: ContractType.contractor,
      jobTitle: JobTitle.machinist);
}

@HiveType(typeId: 81)
enum ContractType {
  @HiveField(0, defaultValue: true)
  permanent('Par an'),
  @HiveField(1)
  contractor('Par préstation');

  final String label;

  const ContractType(this.label);
}

@HiveType(typeId: 82)
enum JobTitle {

  @HiveField(0, defaultValue: true)
  machinist('Machiniste'),

  @HiveField(1)
  assistant('Auxiliaire'),

  @HiveField(2)
  seller('Vendeur'),

  @HiveField(3)
  guard('Gardien');

  final String label;
  const JobTitle(this.label);

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