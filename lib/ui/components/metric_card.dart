import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final Widget body;
  const MetricCard({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: body,
        ),
    );
  }
}
