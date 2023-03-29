
import 'package:hive/hive.dart';

part 'salary_pay.g.dart';

@HiveType(typeId: 81)
class SalaryPay {

  @HiveField(0)
  DateTime paymentDate = DateTime.now();

  @HiveField(1)
  int month = DateTime.now().month;

  @HiveField(2)
  int year = DateTime.now().year;

  @HiveField(3)
  int amount;

  SalaryPay({required this.amount});

  SalaryPay.init({
    required this.paymentDate,
    required this.month,
    required this.year,
    required this.amount});
}

extension SalaryValidation on SalaryPay {
  bool get isValid {
    return month > 0 && year > 0 && amount > 0;
  }
}