import 'package:flutter/material.dart';

class BasicContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  const BasicContainer({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}
