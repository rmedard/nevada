import 'package:nevada/ui/components/charts/single_chart_bar.dart';

class DaysOfWeekData {
  final double monAmount;
  final double tueAmount;
  final double wenAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  DaysOfWeekData(
      {required this.monAmount,
      required this.tueAmount,
      required this.wenAmount,
      required this.thurAmount,
      required this.friAmount,
      required this.satAmount,
      required this.sunAmount});

  List<SingleChartBar> barData = [];

  void initializeBarData() {
    barData = [
      SingleChartBar(x: 0, y: sunAmount),
      SingleChartBar(x: 1, y: monAmount),
      SingleChartBar(x: 2, y: tueAmount),
      SingleChartBar(x: 3, y: wenAmount),
      SingleChartBar(x: 4, y: thurAmount),
      SingleChartBar(x: 5, y: friAmount),
      SingleChartBar(x: 6, y: satAmount),
    ];
  }
}
