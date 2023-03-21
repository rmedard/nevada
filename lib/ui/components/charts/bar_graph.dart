import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nevada/ui/components/charts/days_week_data.dart';

class BarGraph extends StatelessWidget {
  final List<double> weeklyRevenues;

  const BarGraph({Key? key, required this.weeklyRevenues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var daysOfWeekData = DaysOfWeekData(
        monAmount: weeklyRevenues[0],
        tueAmount: weeklyRevenues[1],
        wenAmount: weeklyRevenues[2],
        thurAmount: weeklyRevenues[3],
        friAmount: weeklyRevenues[4],
        satAmount: weeklyRevenues[5],
        sunAmount: weeklyRevenues[6]);
    daysOfWeekData.initializeBarData();

    return BarChart(BarChartData(
        maxY: 100,
        minY: 0,
        barGroups: daysOfWeekData.barData
            .map((data) => BarChartGroupData(
                x: data.x, barRods: [
                  BarChartRodData(toY: data.y, color: Colors.green),
          BarChartRodData(toY: data.y, color: Colors.redAccent)
        ]))
            .toList()));
  }
}
