import 'package:flutter/material.dart';
import 'package:nevada/model/dtos/salary_pay.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/services/employees_service.dart';
import 'package:nevada/ui/forms/employee_salary_form.dart';
import 'package:nevada/utils/date_tools.dart';
import 'package:nevada/utils/num_utils.dart';

class EmployeeSalariesBlock extends StatefulWidget {
  final Employee employee;
  const EmployeeSalariesBlock({Key? key, required this.employee}) : super(key: key);

  @override
  State<EmployeeSalariesBlock> createState() => _EmployeeSalariesBlockState();
}

class _EmployeeSalariesBlockState extends State<EmployeeSalariesBlock> {

  List<SalaryPay> salaryPayments = [];

  @override
  void initState() {
    super.initState();
    salaryPayments = widget.employee.salaryPayments;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Salaires payés', style: textTheme.titleLarge),
              OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          SalaryPay salaryPay = SalaryPay(amount: 0);
                          return AlertDialog(
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(widget.employee.names, style: textTheme.titleMedium,),
                                  EmployeeSalaryForm(salaryPay: salaryPay),
                                ]),
                            actions: [
                              FilledButton.tonal(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annuler')),
                              FilledButton(
                                  onPressed: (){
                                    if (salaryPay.isValid) {
                                      EmployeesService()
                                          .paySalary(widget.employee, salaryPay)
                                          .then((value) => Navigator.pop(context));
                                    }
                                  },
                                  child: const Text('Sauvegarder'))
                            ],
                          );
                        }).then((value) => setState(() {}));
                  },
                  icon: const Icon(Icons.add, size: 15),
                  label: const Text('Nouveau salaire')
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
              children: [
                Expanded(
                    flex:1,
                    child: Align(alignment: Alignment.centerLeft, child: Text('Date', style: textTheme.labelLarge))),
                Expanded(
                    flex: 1,
                    child: Center(child: Text('Pour le mois', style: textTheme.labelLarge))),
                Expanded(
                    flex: 1,
                    child: Align(alignment: Alignment.centerRight, child: Text('Montant', style: textTheme.labelLarge))),
              ]
          ),
          ...salaryPayments.map<Row>((payment) => Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Align(alignment: Alignment.centerLeft, child: Text(DateTools.formatter.format(payment.paymentDate)))),
              Expanded(
                  flex: 1,
                  child: Center(child: Text('${payment.month}/${payment.year}'))),
              Expanded(
                  flex: 1,
                  child: Align(alignment: Alignment.centerRight, child: Text('${NumUtils.currencyFormat().format(payment.amount)} Mt')))
            ],)).toList()
        ],
      ),
    );
  }
}
