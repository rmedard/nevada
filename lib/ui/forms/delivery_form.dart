import 'package:flutter/material.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/forms/inputs/products_drop_down.dart';
import 'package:uuid/uuid.dart';

class DeliveryForm extends StatefulWidget {
  final Delivery delivery;
  final bool isNew;

  const DeliveryForm({Key? key, required this.delivery, required this.isNew}) : super(key: key);

  @override
  State<DeliveryForm> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  var products = ProductsService().getAll();
  var dropDowns = <ProductsDropDown>[];

  @override
  Widget build(BuildContext context) {
    var selectedProducts = widget.isNew ? <Product>[] : widget.delivery.lines.map((e) => e.product).toList();
    products.removeWhere((p) => selectedProducts.map((s) => s.uuid).any((uuid) => p.uuid == uuid));
    if (selectedProducts.isNotEmpty) {
      for (var product in selectedProducts) {
        dropDowns.add(
            ProductsDropDown(
              menuItems: products.map((p) => DropdownMenuItem<String>(key: UniqueKey(), value: p.uuid,child: Text(p.name))).toList(),
              onChanged: (value) {},
              selectedValue: product.uuid));
      }
    }
    var menuItems = products.map((p) => DropdownMenuItem<String>(key: UniqueKey(), value: p.uuid, child: Text(p.name))).toList();
    dropDowns.add(ProductsDropDown(
        menuItems: menuItems,
        onChanged: (value) {
          debugPrint('Selected product: $value');
          setState(() {
            products.removeWhere((p) => selectedProducts.map((s) => s.uuid).any((uuid) => p.uuid == uuid));
          });
        }, selectedValue: ''));
    return Container(child: Column(children: dropDowns));
  }
}
