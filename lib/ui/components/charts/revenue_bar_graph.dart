import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nevada/ui/components/charts/days_week_data.dart';

class RevenueBarGraph extends StatelessWidget {
  final List<double> weeklyRevenues;

  const RevenueBarGraph({Key? key, required this.weeklyRevenues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
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
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: daysOfWeekData.barData.map((data) =>
            BarChartGroupData(
                x: data.x + 1,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Colors.green,
                    width: 20,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: colorScheme.background
                    )
                  )
                ])
        ).toList()));
  }
}
