import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/services/deliveries_service.dart';
import 'package:nevada/ui/components/time_period_picker.dart';
import 'package:nevada/utils/date_tools.dart';

import 'charts/revenue_bar_graph.dart';
import 'metric_card.dart';

class RevenuesChart extends StatefulWidget {
  const RevenuesChart({Key? key}) : super(key: key);

  @override
  State<RevenuesChart> createState() => _RevenuesChartState();
}

class _RevenuesChartState extends State<RevenuesChart> {

  DateTime from = DateTools.beginningOfWeek(DateTime.now());
  DateTime to = DateTools.endOfWeek(DateTime.now());

  Map<String, double> data = {};

  @override
  void initState() {
    super.initState();
    data = weeklyData();
  }

  Map<String, double> weeklyData() {
    var countSales = DeliveriesService().countSales(from, to);
    Map<String, double> dd = {};
    DateTime countingFrom = from;
    while(!countingFrom.isAfter(to)) {
      var key = DateTools.formatter.format(countingFrom);
      dd.putIfAbsent(key, () => (countSales[key] ?? 0).toDouble());
      countingFrom = countingFrom.add(const Duration(days: 1));
    }

    return dd.map((key, value) {
      var date = DateTools.formatter.parse(key);
      return MapEntry('${DateFormat('EE').format(date).replaceAll('.', '')} ${date.day}', value.toDouble());
    });
  }

  Map<String, double> monthlyData() {
    List<double> month = List.generate(31, (index) => Random().nextInt(100).toDouble());
    return {for (var index = 0; index < month.length; index++) '$index' : month[index]};
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return MetricCard(
      horizontalPadding: 20,
      verticalPadding: 20,
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 60,
                      child: TimePeriodPicker(onChanged: (from, to) {
                        debugPrint('From: ${DateTools.formatter.format(from)} | To: ${DateTools.formatter.format(to)}');
                        if (to.difference(from).inDays < 10) {
                          setState(() {
                            data = weeklyData();
                          });
                        } else {
                          setState(() {
                            data = monthlyData();
                          });
                        }
                        },)),
                  Text('Ventes', style: textTheme.headlineSmall),
                  Expanded(child: RevenueBarGraph(revenues: data))
                ],
              )),
        ],
      ));
  }
}
