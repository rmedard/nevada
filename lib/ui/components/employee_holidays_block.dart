import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:nevada/model/employee.dart';

class EmployeeHolidaysBlock extends StatefulWidget {

  final Employee employee;

  const EmployeeHolidaysBlock({Key? key, required this.employee}) : super(key: key);

  @override
  State<EmployeeHolidaysBlock> createState() => _EmployeeHolidaysBlockState();
}

class _EmployeeHolidaysBlockState extends State<EmployeeHolidaysBlock> {

  List<DateTime> holidayDates = [];

  var holidayD = [
    DateTime(2023, 1, 1),
    DateTime(2023, 1, 5),
    DateTime(2023, 1, 12),
    DateTime(2023, 1, 20),
    DateTime(2023, 2, 15),
    DateTime(2023, 2, 18),
    DateTime(2023, 3, 16),
  ];

  EventList<Event> markedDates = EventList(events: {});

  @override
  void initState() {
    super.initState();
    if (widget.employee.holidays.isNotEmpty) {
      holidayDates = widget.employee.holidays.values
          .map((e) => e.holidays)
          .reduce((value, element) {
            value.addAll(element);
            return value;
          }).map((e) => e.dateTime).toList();
    }

    for (var holiday in holidayD) {
      markedDates.events.putIfAbsent(holiday, () => [Event(date: holiday, title: 'ff')]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Congés', style: textTheme.titleLarge),
              OutlinedButton.icon(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(

                          );
                        });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nouveau congé'))
            ],
          ),
          const SizedBox(height: 10),
          Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.fiber_manual_record, size: 13),
                      Text('Total des congés annuels:'),
                    ],
                  ),
                  Text('20')
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fiber_manual_record, size: 13, color: colorScheme.primary),
                      const Text('Congés consommés:'),
                    ],
                  ),
                  Text('8')
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fiber_manual_record, size: 13, color: colorScheme.error),
                      const Text('Congés restants:'),
                    ],
                  ),
                  Text('12')
                ])
          ],),
          // SizedBox(
          //   width: double.infinity,
          //   height: 400,
          //   child: CalendarCarousel<Event>(
          //     customGridViewPhysics: const NeverScrollableScrollPhysics(),
          //     markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: colorScheme.error)),
          //     headerTextStyle: textTheme.labelLarge,
          //     locale: 'fr',
          //     thisMonthDayBorderColor: Colors.green,
          //     markedDatesMap: markedDates,
          //   ),
          // ),
        ],
      ),
    );
  }
}
