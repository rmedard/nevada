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

  final int stepSize = 7;
  final TextEditingController _inputController = TextEditingController();
  late DateTime from;
  late DateTime to;
  bool isForwardSpinnerInRange = true;
  bool isBackwardSpinnerInRange = true;

  @override
  void initState() {
    super.initState();
    from = DateTools.beginningOfWeek(widget.initialWeekDate);
    to = DateTools.endOfWeek(widget.initialWeekDate);
    isForwardSpinnerInRange = from.add(Duration(days: stepSize)).isBefore(DateTime.now());
    _inputController.text = '${DateTools.formatter.format(from)} - ${DateTools.formatter.format(to)}';
    _inputController.addListener(() {
      widget.onChanged(from, to);
      var nextForwardFrom = from.add(Duration(days: stepSize));
      if (nextForwardFrom.isAfter(DateTime.now()) && isForwardSpinnerInRange) {
        setState(() => isForwardSpinnerInRange = false);
      }
      if (nextForwardFrom.isBefore(DateTime.now()) && !isForwardSpinnerInRange) {
        setState(() => isForwardSpinnerInRange = true);
      }
    });
  }


  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: TextField(
        textAlign: TextAlign.center,
        controller: _inputController,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: () {
                from = from.subtract(const Duration(days: 7));
                to = to.subtract(const Duration(days: 7));
                _inputController.text = '${DateTools.formatter.format(from)} - ${DateTools.formatter.format(to)}';
              },
              icon: const Icon(Nevada.back, size: 18)),
          suffixIcon: IconButton(
              onPressed: isForwardSpinnerInRange ? () {
                from = from.add(Duration(days: stepSize));
                to = to.add(Duration(days: stepSize));
                _inputController.text = '${DateTools.formatter.format(from)} - ${DateTools.formatter.format(to)}';
              } : null,
              icon: const Icon(Nevada.forward, size: 18))
        ),
      ),
    );
  }
}
