import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/services/delivery_lines_service.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/components/table_column_title.dart';
import 'package:uuid/uuid.dart';

class ProductDeliveryTable extends StatefulWidget {

  final Delivery delivery;

  const ProductDeliveryTable({Key? key, required this.delivery}) : super(key: key);

  @override
  State<ProductDeliveryTable> createState() => _ProductDeliveryTableState();
}

class _ProductDeliveryTableState extends State<ProductDeliveryTable> {

  late List<Product> products;
  late Map<String, TextEditingController> quantityEditControllers;

  @override
  void initState() {
    super.initState();
    products = ProductsService().getAll();
    quantityEditControllers = Map.fromEntries(products.map((product) => MapEntry(product.uuid, TextEditingController())));
  }

  @override
  void dispose() {
    for (var controller in quantityEditControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var rowTotals = {};
    var totalPrice = 0;
    for (var product in products) {
      var line = widget.delivery.lines.firstWhereOrNull((line) => line.product.uuid == product.uuid);
      if (line != null) {
        var lineTotal = line.productQuantity * line.productUnitPrice;
        totalPrice += lineTotal;
        rowTotals.putIfAbsent(line.product.uuid, () => lineTotal);
      } else {
        var newLine = DeliveryLine(
            uuid: const Uuid().v4(),
            deliveryUuid: widget.delivery.uuid,
            product: product,
            productQuantity: 0,
            productUnitPrice: product.unitBasePrice
        );
        DeliveryLinesService().createNew(newLine.uuid, newLine);
        newLine.save().then((_) => widget.delivery.lines.add(newLine));
        rowTotals.putIfAbsent(product.uuid, () => 0);
      }
    }

    return Column(
      children: [
        DataTable(
            headingTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark),
            columns: const [
          DataColumn(label: TableColumnTitle(title: 'Produit')),
          DataColumn(label: TableColumnTitle(title: 'Quantité')),
          DataColumn(label: TableColumnTitle(title: 'Prix unitaire')),
          DataColumn(label: TableColumnTitle(title: 'Prix total')),
        ], rows: products.map((product) => DataRow(cells: <DataCell>[
          DataCell(Text(product.description)),
          DataCell(Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                controller: quantityEditControllers[product.uuid],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))],
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (value) {
                  setState(() {
                    widget.delivery.lines
                        .firstWhere((line) => line.product.uuid == product.uuid)
                        .productQuantity = int.tryParse(value) ?? 0;
                  });
                }))),
          DataCell(Text('${product.unitBasePrice}'), showEditIcon: true, onTap: () {
            debugPrint('edit clicked...');
          }),
          DataCell(Text('${rowTotals[product.uuid]}')),
        ])).toList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Prix Total', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 20),
            Text('$totalPrice', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
