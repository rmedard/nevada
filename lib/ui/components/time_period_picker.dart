import 'package:flutter/material.dart';
import 'package:nevada/ui/components/month_spinner.dart';
import 'package:nevada/ui/components/week_spinner.dart';
import 'package:nevada/utils/date_tools.dart';

class TimePeriodPicker extends StatefulWidget {
  final Function(DateTime from, DateTime to) onChanged;
  const TimePeriodPicker({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<TimePeriodPicker> createState() => _TimePeriodPickerState();
}

class _TimePeriodPickerState extends State<TimePeriodPicker> {

  var timePeriod = 'weekly';
  late Widget timePeriodSelector;
  late DateTime from;
  late DateTime to;

  Widget weeklySelector() {
    var initialDate = DateTime.now();
    from = DateTools.beginningOfWeek(initialDate);
    to = DateTools.endOfWeek(initialDate);
    return WeekSpinner(initialWeekDate: initialDate, onChanged: widget.onChanged);
  }

  Widget monthlySelector() {
    var initialDate = DateTime.now();
    from = DateTime(initialDate.year, initialDate.month, 1);
    to = DateTime(initialDate.year, initialDate.month, DateUtils.getDaysInMonth(initialDate.year, initialDate.month));
    return MonthSpinner(
        initialMonth: DateTime.now().month,
        initialYear: DateTime.now().year,
        onChanged: (month, year) {
          var from = DateTime(year, month, 1);
          var to = DateTime(year, month, DateUtils.getDaysInMonth(year, month));
          widget.onChanged(from, to);
        });
  }

  @override
  void initState() {
    super.initState();
    timePeriodSelector = weeklySelector();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Expanded(
            child: RadioListTile(
                value: 'weekly',
                groupValue: timePeriod,
                hoverColor: Colors.red,
                title: const Text('Par Semaine'),
                onChanged: (value) {
                  if (timePeriod != 'weekly') {
                    setState(() {
                      timePeriod = 'weekly';
                      timePeriodSelector = weeklySelector();
                      widget.onChanged(from, to);
                    });
                  }
                }),
          ),
          Expanded(
              child: RadioListTile(
                  value: 'monthly',
                  groupValue: timePeriod,
                  title: const Text('Par Mois'),
                  onChanged: (value) {
                    if (timePeriod != 'monthly') {
                      setState(() {
                        timePeriod = 'monthly';
                        timePeriodSelector = monthlySelector();
                        widget.onChanged(from, to);
                      });
                    }
                  }))
        ],),
      ),
      Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: timePeriodSelector)),
    ],);
  }
}
