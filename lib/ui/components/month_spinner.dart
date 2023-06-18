import 'package:flutter/material.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class MonthSpinner extends StatefulWidget {
  final int initialMonth;
  final int initialYear;
  final Function(int month, int year) onChanged;

  const MonthSpinner(
      {Key? key,
      required this.initialMonth,
      required this.initialYear,
      required this.onChanged})
      : super(key: key);

  @override
  State<MonthSpinner> createState() => _MonthSpinnerState();
}

class _MonthSpinnerState extends State<MonthSpinner> {
  TextEditingController inputController = TextEditingController();

  late int month;
  late int year;

  @override
  void initState() {
    super.initState();
    month = widget.initialMonth;
    year = widget.initialYear;
    inputController.text = '${widget.initialMonth}/${widget.initialYear}';
    inputController.addListener(() => widget.onChanged(month, year));
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: TextField(
        textAlign: TextAlign.center,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: () {
                if (month == 1) {
                  month = 12;
                  --year;
                } else {
                  --month;
                }
                inputController.text = '$month/$year';
              },
              icon: const Icon(Nevada.back, size: 18)),
          suffixIcon: IconButton(
              onPressed: () {
                if (month == 12) {
                  month = 1;
                  ++year;
                } else {
                  ++month;
                }
                inputController.text = '$month/$year';
              },
              icon: const Icon(Nevada.forward, size: 18)),
        ),
        controller: inputController,
      ),
    );
  }
}
