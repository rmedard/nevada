import 'package:flutter/material.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/utils/date_tools.dart';

class NewHolidayDialog extends StatefulWidget {
  
  final Employee employee;
  const NewHolidayDialog({Key? key, required this.employee}) : super(key: key);

  @override
  State<NewHolidayDialog> createState() => _NewHolidayDialogState();
}

class _NewHolidayDialogState extends State<NewHolidayDialog> {

  final _holidayPeriodEditController = TextEditingController();
  DateTimeRange selectedRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1)));

  @override
  void initState() {
    super.initState();
    _holidayPeriodEditController.text = '${selectedRange.start.toBasicDateStr} - ${selectedRange.end.toBasicDateStr}';
  }

  @override
  Widget build(BuildContext context) {
    int workingDays = selectedRange.workingDaysCount;
    return AlertDialog(
      title: Text('Congé de: ${widget.employee.names}'),
      content: BasicContainer(
        child: SizedBox(
          width: 300,
          child: TextField(
            decoration: InputDecoration(
                label: const Text('Période'),
                suffix: Text('$workingDays jour${workingDays == 1 ? "" : "s"}')),
            controller: _holidayPeriodEditController,
            onTap: () {
              showDateRangePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  firstDate: DateTools.minusMonths(DateTime.now(), 1),
                  lastDate: DateTools.plusMonths(DateTime.now(), 1),
                  initialDateRange: selectedRange,
                  saveText: 'Sauvegarder',
                  builder: (context, builder) {
                    var screenSize = MediaQuery.of(context).size;
                    return Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.05, horizontal: screenSize.width * 0.3),
                        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: builder));
                  }).then((range) {
                    if (range != null) {
                      setState(() {
                        selectedRange = range;
                        _holidayPeriodEditController.text = '${range.start.toBasicDateStr} - ${range.end.toBasicDateStr}';
                      });
                    }
              });
            },
          ),
        ),
      ),
      actions: [
        FilledButton.tonal(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler')),
        FilledButton(
            onPressed: () => Navigator.pop(context, selectedRange),
            child: const Text('Sauvegarder'))
      ],
    );
  }
}
