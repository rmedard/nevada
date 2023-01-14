import 'package:flutter/material.dart';

class TableColumnTitle extends StatelessWidget {

  final String title;

  const TableColumnTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
  }
}
