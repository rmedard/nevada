import 'package:flutter/material.dart';

class MenuElement {
  String label;
  Icon icon;
  Icon iconFill;
  Widget body;
  bool hasWarnings;

  MenuElement({required this.label, required this.icon, required this.iconFill,  required this.body, required this.hasWarnings});
}