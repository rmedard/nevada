import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/delivery_line.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/services/dtos/delivery_line_edit_dto.dart';
import 'package:nevada/services/products_service.dart';

class ProductDeliveryTable extends StatefulWidget {

  final Delivery delivery;

  const ProductDeliveryTable({Key? key, required this.delivery}) : super(key: key);

  @override
  State<ProductDeliveryTable> createState() => _ProductDeliveryTableState();
}

class _ProductDeliveryTableState extends State<ProductDeliveryTable> {
  late List<Product> products;
  late List<DeliveryLineEditDto> deliveryLineEditDtos;

  @override
  void initState() {
    super.initState();
    products = ProductsService().getAll();
    for (var product in products) {
      if (!widget.delivery.lines.keys.contains(product.uuid)) {
        widget.delivery.lines.putIfAbsent(product.uuid, () => DeliveryLine(
            product: product,
            productQuantity: 0,
            productUnitPrice: product.unitBasePrice));
      }
    }

    deliveryLineEditDtos = widget.delivery.lines.entries.map<DeliveryLineEditDto>((entry) {
      DeliveryLine line = entry.value;
      var quantityEditCtlr = TextEditingController();
      quantityEditCtlr.text = '${entry.value.productQuantity}';
      quantityEditCtlr.addListener(() => line.productQuantity = int.parse(quantityEditCtlr.value.text));

      var unitPriceEditCtlr = TextEditingController();
      unitPriceEditCtlr.text = '${line.productUnitPrice}';
      unitPriceEditCtlr.addListener(() => line.productUnitPrice = int.parse(unitPriceEditCtlr.value.text));

      return DeliveryLineEditDto(
          deliveryLine: line,
          quantityEditController: quantityEditCtlr,
          unitPriceEditController: unitPriceEditCtlr,
          editUnitPriceFocusNode: FocusNode());
    }).toList();
  }

  @override
  void dispose() {
    for (var lineEditDto in deliveryLineEditDtos) {
      lineEditDto.quantityEditController.dispose();
      lineEditDto.unitPriceEditController.dispose();
    }
    super.dispose();
  }

  int deliveryTotalPrice() {
    return deliveryLineEditDtos
        .map((lineEditDto) => lineEditDto.deliveryLine)
        .map((e) => e.productQuantity * e.productUnitPrice)
        .reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DataTable(
            columns: const [
              DataColumn(label: Text('Produit')),
              DataColumn(label: Text('Quantité')),
              DataColumn(label: Text('Prix unitaire')),
              DataColumn(label: Text('Prix total')),
            ],
            rows: deliveryLineEditDtos.map((lineEditDto) {
              return DataRow(cells: <DataCell>[
                DataCell(Text(lineEditDto.deliveryLine.product.description)),
                DataCell(Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                        controller: lineEditDto.quantityEditController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                        ],
                        onChanged: (value) {
                          setState(() {
                            lineEditDto.deliveryLine.productQuantity = int.tryParse(value) ?? 0;
                            deliveryTotalPrice();
                          });
                        }))),
                DataCell(
                    TextField(
                        controller: lineEditDto.unitPriceEditController,
                        focusNode: lineEditDto.editUnitPriceFocusNode,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                        ],
                        onChanged: (value) {
                          setState(() {
                            lineEditDto.deliveryLine.productUnitPrice = int.tryParse(value) ?? 0;
                            deliveryTotalPrice();
                          });
                        }),
                    showEditIcon: true,
                    onTap: () => setState(() => lineEditDto.editUnitPriceFocusNode.requestFocus())),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${lineEditDto.deliveryLine.total}'),
                    Text('MT', style: textTheme.labelSmall)
                  ],
                )),
              ]);
            }).toList()),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Prix Total', style: textTheme.headlineSmall),
              const SizedBox(width: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${deliveryTotalPrice()}', style: textTheme.headlineMedium),
                  Text('MT', style: textTheme.titleMedium)
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
