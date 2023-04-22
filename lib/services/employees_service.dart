import 'package:nevada/model/dtos/salary_pay.dart';
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
          sender: 'Nevada',
          deliveryUuid: '',
          status: TransactionStatus.paid,
          createdAt: DateTime.now());
      return TransactionsService().createNew(transaction.uuid, transaction);
    });
  }
}