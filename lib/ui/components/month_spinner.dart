import 'package:flutter/material.dart';
import 'package:nevada/model/dtos/salary_pay.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class MonthSpinner extends StatefulWidget {

  final SalaryPay salaryPay;
  const MonthSpinner({Key? key, required this.salaryPay}) : super(key: key);

  @override
  State<MonthSpinner> createState() => _MonthSpinnerState();
}

class _MonthSpinnerState extends State<MonthSpinner> {

  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputController.text = '${widget.salaryPay.month}/${widget.salaryPay.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        textAlign: TextAlign.center,
        readOnly: true,
        decoration: InputDecoration(
            prefixIcon: IconButton(
                onPressed: () {
                  if(widget.salaryPay.month == 1) {
                    widget.salaryPay.month = 12;
                    --widget.salaryPay.year;
                  } else {
                    --widget.salaryPay.month;
                  }
                  inputController.text = '${widget.salaryPay.month}/${widget.salaryPay.year}';
                },
                icon: const Icon(Nevada.back, size: 18)),
            suffixIcon: IconButton(
                onPressed: () {
                  if (widget.salaryPay.month == 12) {
                    widget.salaryPay.month = 1;
                    ++widget.salaryPay.year;
                  } else {
                    ++widget.salaryPay.month;
                  }
                  inputController.text = '${widget.salaryPay.month}/${widget.salaryPay.year}';
                },
                icon: const Icon(Nevada.forward, size: 18)),
        ), controller: inputController,
      ),
    );
  }
}
