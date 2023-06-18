import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final Widget body;
  final double horizontalPadding;
  final double verticalPadding;
  const MetricCard({Key? key, required this.body, required this.horizontalPadding, required this.verticalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Card(
        color: colorScheme.surface,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          child: body
        ),
    );
  }
}
