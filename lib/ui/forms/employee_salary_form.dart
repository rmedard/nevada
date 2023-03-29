import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/hiveDtos/salary_pay.dart';
import 'package:nevada/ui/components/month_spinner.dart';
import 'package:nevada/ui/utils/thousand_separator_input_formatter.dart';

class EmployeeSalaryForm extends StatelessWidget {

  final SalaryPay salaryPay;

  const EmployeeSalaryForm({Key? key, required this.salaryPay}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var textTheme = Theme.of(context).textTheme;

    TextEditingController amountEditController = TextEditingController(text: '${salaryPay.amount}');
    amountEditController.addListener(() {
      String currentValue = amountEditController.value.text.replaceAll(ThousandSeparatorInputFormatter.separator, '');
      int? amount = int.tryParse(currentValue);
      if (amount != null) {
        salaryPay.amount = amount;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mois', style: textTheme.labelMedium),
          MonthSpinner(salaryPay: salaryPay),
          const SizedBox(height: 20),
          Text('Montant', style: textTheme.labelMedium),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: amountEditController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                ThousandSeparatorInputFormatter()
              ],
              decoration: const InputDecoration(suffix: Text('MT')),
            ),
          )
    ]);
  }
}
