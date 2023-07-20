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
  late YearlyHolidays selectedYearlyHolidays;
  late int selectedYear = DateTime.now().year;

  Map<DateTime, List<Event>> holidays = {};
  EventList<Event> markedDates = EventList(events: {});

  @override
  void initState() {
    super.initState();
    selectedYearlyHolidays = EmployeesService().getYearlyHolidays(widget.employee, DateTime.now().year);

    selectedYearlyHolidays
        .holidays
        .map((holiday) => holiday.dateTime)
        .forEach((holidayDate) => markedDates.events.putIfAbsent(holidayDate, () => [Event(date: holidayDate, dot: const SizedBox.shrink())]));
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    int totalMaxYearlyHolidays = selectedYearlyHolidays.allowedAmount;
    int totalTakenHolidays = EmployeesService().countYearlyHolidaysDates(widget.employee, selectedYear);
    int totalRemainingHolidays = totalMaxYearlyHolidays - totalTakenHolidays;

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
                        Text('$totalMaxYearlyHolidays')
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(
                      children: [
                        Icon(Icons.fiber_manual_record, size: 13, color: colorScheme.primary),
                        const Text('Congés consommés:'),
                      ],
                    ),
                    Text('$totalTakenHolidays')
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(
                      children: [
                        Icon(Icons.fiber_manual_record, size: 13, color: colorScheme.error),
                        const Text('Congés restants:'),
                      ],
                    ),
                    Text('$totalRemainingHolidays')
                  ]),
                  const SizedBox(height: 20),
                  ...EmployeesService()
                      .computeHolidaySpans(widget.employee, selectedYear)
                      .map((range) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${range.start.toBasicDateStr} - ${range.end.toBasicDateStr}'),
                      Text('${range.workingDaysCount} jour${range.workingDaysCount > 1 ? "s" : ""}')
                    ],
                  )).toList()
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
                todayButtonColor: colorScheme.background,
                todayTextStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                customGridViewPhysics: const NeverScrollableScrollPhysics(),
                markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: colorScheme.primary)),
                headerTextStyle: textTheme.labelLarge,
                locale: 'fr',
                markedDatesMap: markedDates,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
