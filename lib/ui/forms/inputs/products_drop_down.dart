import 'package:flutter/material.dart';

class ProductsDropDown extends StatelessWidget {
  final List<DropdownMenuItem<String>> menuItems;
  final String selectedValue;
  final Function(String?) onChanged;
  const ProductsDropDown({Key? key, required this.menuItems, required this.onChanged, required this.selectedValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedValue.isEmpty) {
      return DropdownButton<String>(key: UniqueKey(), items: menuItems, onChanged: onChanged);
    } else {
      return DropdownButton<String>(key: UniqueKey(), items: menuItems, onChanged: onChanged, value: selectedValue);
    }
  }
}
