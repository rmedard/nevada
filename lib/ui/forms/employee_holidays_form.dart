import 'package:flutter/material.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/utils/date_tools.dart';

class EmployeeHolidaysForm extends StatefulWidget {
  final Function(DateTimeRange) onNewSelection;
  const EmployeeHolidaysForm({super.key, required this.onNewSelection});

  @override
  State<EmployeeHolidaysForm> createState() => _EmployeeHolidaysFormState();
}

class _EmployeeHolidaysFormState extends State<EmployeeHolidaysForm> {
  final _holidayPeriodEditController = TextEditingController();
  DateTimeRange selectedRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1)));

  @override
  Widget build(BuildContext context) {
    _holidayPeriodEditController.text = '${selectedRange.start.toBasicDateStr} - ${selectedRange.end.toBasicDateStr}';
    int workingDays = DateTools.countWorkingDays(selectedRange);
    return BasicContainer(
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
                builder: (dialogContext, builder) {
                  var screenSize = MediaQuery.of(context).size;
                  return Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.05, horizontal: screenSize.width * 0.3),
                      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: builder));
                }).then((range) {
                  if (range != null) {
                    setState(() => selectedRange = range);
                    _holidayPeriodEditController.text = '${range.start.toBasicDateStr} - ${range.end.toBasicDateStr}';
                    widget.onNewSelection(range);
                  }
            });
          },
        ),
      ),
    );
  }
}
