import 'package:flutter/material.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';

class WeekSpinner extends StatefulWidget {

  final DateTime initialWeekDate;
  final Function(DateTime from, DateTime to) onChanged;

  const WeekSpinner({Key? key, required this.initialWeekDate, required this.onChanged}) : super(key: key);

  @override
  State<WeekSpinner> createState() => _WeekSpinnerState();
}

class _WeekSpinnerState extends State<WeekSpinner> {

  TextEditingController inputController = TextEditingController();
  late DateTime from;
  late DateTime to;


  @override
  void initState() {
    super.initState();
    from = DateTools.beginningOfWeek(widget.initialWeekDate);
    to = DateTools.endOfWeek(widget.initialWeekDate);
    inputController.text = '${DateTools.formatter.format(from)} - ${DateTools.formatter.format(to)}';
    inputController.addListener(() => widget.onChanged(from, to));
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: TextField(
        textAlign: TextAlign.center,
        controller: inputController,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: () {
                from = from.subtract(const Duration(days: 7));
                to = to.subtract(const Duration(days: 7));
                inputController.text = '${DateTools.formatter.format(from)} - ${DateTools.formatter.format(to)}';
              },
              icon: const Icon(Nevada.back, size: 18)),
          suffixIcon: IconButton(
              onPressed: () {
                from = from.add(const Duration(days: 7));
                to = to.add(const Duration(days: 7));
                inputController.text = '${DateTools.formatter.format(from)} - ${DateTools.formatter.format(to)}';
              },
              icon: const Icon(Nevada.forward, size: 18))
        ),
      ),
    );
  }
}
