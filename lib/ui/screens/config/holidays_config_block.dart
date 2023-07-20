import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';

class HolidaysConfigBlock extends StatefulWidget {
  const HolidaysConfigBlock({super.key});

  @override
  State<HolidaysConfigBlock> createState() => _HolidaysConfigBlockState();
}

class _HolidaysConfigBlockState extends State<HolidaysConfigBlock> {

  final TextEditingController maxAllowedDaysPerYearController = TextEditingController();
  late bool editMode = false;
  late List<int> weekendDays = [];

  @override
  void initState() {
    super.initState();
    maxAllowedDaysPerYearController.text = '${ConfigurationsService().maximumYearlyHolidays()}';
    weekendDays = ConfigurationsService().getWeekendDays();
  }

  @override
  void dispose() {
    maxAllowedDaysPerYearController.dispose();
    super.dispose();
  }

  Widget _toCheckBox(int day) {
    bool isChecked = weekendDays.contains(day);
    return Row(
      children: [
        Text(DateTools.toDayName(day), style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
        Checkbox(
          checkColor: Colors.white,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              if (isChecked) {
                weekendDays = ConfigurationsService().removeWeekendDay(day);
              } else {
                weekendDays = ConfigurationsService().addWeekendDay(day);
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return MetricCard(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Text('Congés', style: textTheme.displaySmall),
            SizedBox(
              width: 250,
              child: BasicContainer(
                color: editMode ? colorScheme.background : colorScheme.surface,
                child: TextField(
                  controller: maxAllowedDaysPerYearController,
                  readOnly: !editMode,
                  decoration: InputDecoration(
                    label: const Text('Jours de congé maximum par an'),
                    suffixIcon: IconButton(
                        onPressed: (){
                          if (editMode) {
                            ConfigurationsService()
                                .updateMaximumYearlyHolidays(int.tryParse(maxAllowedDaysPerYearController.text) ?? 0)
                                .then((value) => setState(() => editMode = false));
                          } else {
                            setState(() => editMode = true);
                          }
                        },
                        icon: editMode ? Icon(Icons.check, color: colorScheme.primary) : const Icon(Nevada.pencil, size: 18))
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          Text('Jours de repos de la semaine', style: textTheme.bodySmall),
          Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [1, 2, 3, 4, 5, 6, 7].map((e) => _toCheckBox(e)).toList())
          ],
        ), horizontalPadding: 20, verticalPadding: 20,
    );
  }
}
