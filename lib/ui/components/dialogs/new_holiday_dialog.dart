import 'package:flutter/material.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/utils/date_tools.dart';

class NewHolidayDialog extends StatefulWidget {
  
  final Employee employee;
  const NewHolidayDialog({Key? key, required this.employee}) : super(key: key);

  @override
  State<NewHolidayDialog> createState() => _NewHolidayDialogState();
}

class _NewHolidayDialogState extends State<NewHolidayDialog> {

  final _holidayPeriodEditController = TextEditingController();
  DateTimeRange? selectedRange;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text('Congé de: ${widget.employee.names}'),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          decoration: InputDecoration(
              label: const Text('Période'),
              suffix: Text('${selectedRange == null ? 0 : DateTools.countWorkingDays(selectedRange!)} jours')),
          controller: _holidayPeriodEditController,
          onTap: () {
            showDateRangePicker(
                context: context,
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                firstDate: DateTools.minusMonths(DateTime.now(), 1),
                lastDate: DateTools.plusMonths(DateTime.now(), 1),
                builder: (context, builder) {
                  var screenSize = MediaQuery.of(context).size;
                  return Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.05, horizontal: screenSize.width * 0.3),
                      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: builder));
                }).then((range) {
              if (range != null) {
                var formatter = DateTools.formatter;
                selectedRange = range;
                setState(() {
                  _holidayPeriodEditController.text = '${formatter.format(range.start)} - ${formatter.format(range.end)}';
                });
              }
            });
          },
        ),
      ),
      actions: [
        FilledButton(onPressed: (){}, child: const Text('Annuler')),
        FilledButton(onPressed: (){
          selectedRange?.duration.inDays;
        }, child: const Text('Sauvegarder'))
      ],
    );
  }
}
