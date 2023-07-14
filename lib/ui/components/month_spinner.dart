import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/string_utils.dart';

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
  final DateFormat _monthFormat = DateFormat.MMMM();
  final TextEditingController _inputController = TextEditingController();

  late ({int month, int year}) currentMonth;

  @override
  void initState() {
    super.initState();
    currentMonth = (month: widget.initialMonth, year: widget.initialYear);
    var templateDate = DateTime(currentMonth.year, currentMonth.month, 1);
    _inputController.text = '${_monthFormat.format(templateDate).firstLetterCap} ${currentMonth.year}';
  }


  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  bool isForwardSpinnerInRange() {
    var nextMonth = getNextMonth(currentMonth);
    return nextMonth.year < DateTime.now().year || nextMonth.month <= DateTime.now().month;
  }

  bool isBackwardSpinnerInRange() {
    var previousMonth = getPreviousMonth(currentMonth);
    return previousMonth.year > 2011;
  }

  ({int month, int year}) getNextMonth(({int month, int year}) inputMonth) {
    ({int month, int year}) nextMonth;
    if (inputMonth.month == 12) {
      nextMonth = (month: 1, year: inputMonth.year + 1);
    } else {
      nextMonth = (month: inputMonth.month + 1, year: inputMonth.year);
    }
    return nextMonth;
  }

  ({int month, int year}) getPreviousMonth(({int month, int year}) inputMonth) {
    ({int month, int year}) previousMonth;
    if (inputMonth.month == 1) {
      previousMonth = (month: 12, year: inputMonth.year - 1);
    } else {
      previousMonth = (month: inputMonth.month - 1, year: inputMonth.year);
    }
    return previousMonth;
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: TextField(
        textAlign: TextAlign.center,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: isBackwardSpinnerInRange() ? () {
                setState(() => currentMonth = getPreviousMonth(currentMonth));
                var templateDate = DateTime(currentMonth.year, currentMonth.month, 1);
                _inputController.text = '${_monthFormat.format(templateDate).firstLetterCap} ${currentMonth.year}';
                widget.onChanged(currentMonth.month, currentMonth.year);
              } : null,
              icon: const Icon(Nevada.back, size: 18)),
          suffixIcon: IconButton(
              onPressed: isForwardSpinnerInRange() ? () {
                setState(() => currentMonth = getNextMonth(currentMonth));
                var templateDate = DateTime(currentMonth.year, currentMonth.month, 1);
                _inputController.text = '${_monthFormat.format(templateDate).firstLetterCap} ${currentMonth.year}';
                widget.onChanged(currentMonth.month, currentMonth.year);
              } : null,
              icon: const Icon(Nevada.forward, size: 18)),
        ),
        controller: _inputController,
      ),
    );
  }
}
