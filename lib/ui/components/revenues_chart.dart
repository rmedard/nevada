import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/services/deliveries_service.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/time_period_picker.dart';
import 'package:nevada/utils/date_tools.dart';

import 'charts/revenue_bar_graph.dart';

class RevenuesChart extends StatefulWidget {
  final ValueNotifier<DateTimeRange> transactionsDateRangeNotifier;
  const RevenuesChart({Key? key, required this.transactionsDateRangeNotifier}) : super(key: key);

  @override
  State<RevenuesChart> createState() => _RevenuesChartState();
}

class _RevenuesChartState extends State<RevenuesChart> {

  Map<String, double> data = {};

  @override
  void initState() {
    super.initState();
    data = weeklyData();
  }

  Map<String, double> weeklyData() {
    var from = widget.transactionsDateRangeNotifier.value.start;
    var to = widget.transactionsDateRangeNotifier.value.end;
    var countSales = DeliveriesService().countSales(from, to);
    Map<String, double> chartData = {};
    DateTime countingFrom = from;
    while(!countingFrom.isAfter(to)) {
      var key = DateTools.formatter.format(countingFrom);
      double salesCount = (countSales[key] ?? 0).toDouble();
      debugPrint('Sales count on $key: $salesCount');
      chartData.putIfAbsent(key, () => salesCount);
      countingFrom = countingFrom.add(const Duration(days: 1));
    }

    return chartData.map((key, value) {
      var date = DateTools.formatter.parse(key);
      return MapEntry('${DateFormat('EE').format(date).replaceAll('.', '')} ${date.day}', value.toDouble());
    });
  }

  Map<String, double> monthlyData() {
    var from = widget.transactionsDateRangeNotifier.value.start;
    var to = widget.transactionsDateRangeNotifier.value.end;
    var countSales = DeliveriesService().countSales(from, to);
    Map<String, double> chartData = {};
    DateTime countingFrom = from;
    while(!countingFrom.isAfter(to)) {
      var key = DateTools.formatter.format(countingFrom);
      double salesCount = (countSales[key] ?? 0).toDouble();
      debugPrint('Sales count on $key: $salesCount');
      chartData.putIfAbsent('${countingFrom.day}', () => salesCount);
      countingFrom = countingFrom.add(const Duration(days: 1));
    }
    return chartData;
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
                      child: TimePeriodPicker(onChanged: (newFrom, newTo) {
                        widget.transactionsDateRangeNotifier.value = DateTimeRange(start: newFrom, end: newTo);
                        debugPrint('From: ${DateTools.formatter.format(newFrom)} | To: ${DateTools.formatter.format(newTo)}');
                        if (newTo.difference(newFrom).inDays < 10) {
                          setState(() => data = weeklyData());
                        } else {
                          setState(() => data = monthlyData());
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
