import 'package:flutter/material.dart';

class ProductsDropDown extends StatelessWidget {
  final List<DropdownMenuItem<String>> menuItems;
  final String selectedValue;
  final Function(String?) onChanged;
  const ProductsDropDown({Key? key, required this.menuItems, required this.onChanged, required this.selectedValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(items: menuItems, onChanged: onChanged, value: selectedValue);
  }
}
