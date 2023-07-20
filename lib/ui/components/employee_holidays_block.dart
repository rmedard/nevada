import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:nevada/model/dtos/yearly_holidays.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/services/employees_service.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/components/dialogs/new_holiday_dialog.dart';
import 'package:nevada/ui/components/spinners/year_spinner.dart';
import 'package:nevada/utils/date_tools.dart';

class EmployeeHolidaysBlock extends StatefulWidget {
  final Employee employee;

  const EmployeeHolidaysBlock({Key? key, required this.employee})
      : super(key: key);

  @override
  State<EmployeeHolidaysBlock> createState() => _EmployeeHolidaysBlockState();
}

class _EmployeeHolidaysBlockState extends State<EmployeeHolidaysBlock> {
  List<DateTime> holidayDates = [];

  late YearlyHolidays selectedYearlyHolidays;
  late int selectedYear = DateTime.now().year;

  var holidayD = [
    DateTime(2023, 1, 1),
    DateTime(2023, 1, 5),
    DateTime(2023, 1, 12),
    DateTime(2023, 1, 20),
    DateTime(2023, 2, 15),
    DateTime(2023, 2, 18),
    DateTime(2023, 3, 16),
  ];

  Map<DateTime, List<Event>> holidays = {};
  EventList<Event> markedDates = EventList(events: {});

  @override
  void initState() {
    super.initState();
    selectedYearlyHolidays = EmployeesService().getYearlyHolidays(widget.employee, DateTime.now().year);
    if (widget.employee.holidays.isNotEmpty) {
      holidayDates = widget.employee.holidays.values
          .map((e) => e.holidays)
          .reduce((value, element) {
            value.addAll(element);
            return value;
          })
          .map((e) => e.dateTime)
          .toList();
    }

    for (var holiday in holidayD) {
      markedDates.events
          .putIfAbsent(holiday, () => [Event(date: holiday, title: 'ff')]);
    }

    //Fix
    var ff = Map.fromIterable(widget
        .employee
        .holidays
        .values
        .expand((e) => e.holidays)
        .map((e) => e.dateTime)
        .map((e) => MapEntry(e, [Event(date: e)])));

    widget.employee.holidays.forEach((key, value) {
      debugPrint('### Year: $key => count: ${value.holidays.length}');
      value.holidays.forEach((element) {
        debugPrint(element.dateTime.toBasicDateStr);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Congés', style: textTheme.titleLarge),
              OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) => NewHolidayDialog(employee: widget.employee))
                        .then((range) {
                          if (range is DateTimeRange) {
                            EmployeesService()
                                .createEmployeeHolidays(widget.employee, range)
                                .then((value) => setState((){}));
                          }
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nouveau congé'))
            ],
          ),
          const SizedBox(height: 20),
          BasicContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  YearSpinner(
                    initialYear: DateTime.now().year,
                    onChanged: (int year) => setState(() {
                      selectedYearlyHolidays = EmployeesService().getYearlyHolidays(widget.employee, year);
                      selectedYear = year;
                    }),
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.fiber_manual_record, size: 13),
                            Text('Total des congés annuels:'),
                          ],
                        ),
                        Text('${selectedYearlyHolidays.allowedAmount}')
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(
                      children: [
                        Icon(Icons.fiber_manual_record, size: 13, color: colorScheme.primary),
                        const Text('Congés consommés:'),
                      ],
                    ),
                    Text('${EmployeesService().countYearlyHolidaysDates(widget.employee, selectedYear)}')
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(
                      children: [
                        Icon(Icons.fiber_manual_record, size: 13, color: colorScheme.error),
                        const Text('Congés restants:'),
                      ],
                    ),
                    Text('${selectedYearlyHolidays.allowedAmount - selectedYearlyHolidays.holidays.length}')
                  ]),
                  ...EmployeesService()
                      .computeHolidaySpans(widget.employee, selectedYear)
                      .entries
                      .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${e.key.start.toBasicDateStr} - ${e.key.end.toBasicDateStr}'),
                          Text('${e.value} jours')
                        ],
                      ))
                      .toList()
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          BasicContainer(
            child: SizedBox(
              width: double.infinity,
              height: 400,
              child: CalendarCarousel<Event>(
                customGridViewPhysics: const NeverScrollableScrollPhysics(),
                markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: colorScheme.error)),
                headerTextStyle: textTheme.labelLarge,
                locale: 'fr',
                thisMonthDayBorderColor: Colors.green,
                markedDatesMap: markedDates,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
