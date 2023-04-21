import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nevada/ui/components/charts/single_chart_bar.dart';

class RevenueBarGraph extends StatelessWidget {
  final Map<String, double> revenues;

  const RevenueBarGraph({Key? key, required this.revenues }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var bars = revenues.values
        .mapIndexed((index, amount) => SingleChartBar(x: index, y: amount))
        .toList();

    return BarChart(BarChartData(
        maxY: 100,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (index, value) {
            return Text(revenues.keys.elementAt(index.toInt()));
          })),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: bars.map((data) =>
            BarChartGroupData(
                x: data.x,
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
