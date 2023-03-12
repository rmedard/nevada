import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/dtos/delivery_line_edit_dto.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/services/products_service.dart';
import 'package:uuid/uuid.dart';

class ProductDeliveryTable extends StatefulWidget {

  final String deliveryUuid;
  final List<DeliveryLine> deliveryLines;

  const ProductDeliveryTable({Key? key, required this.deliveryUuid, required this.deliveryLines}) : super(key: key);

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
    deliveryLineEditDtos = _constructDeliveryLines(products);
  }

  @override
  void dispose() {
    for (var lineEditDto in deliveryLineEditDtos) {
      lineEditDto.quantityEditController.dispose();
      lineEditDto.unitPriceEditController.dispose();
    }
    super.dispose();
  }

  List<DeliveryLineEditDto> _constructDeliveryLines(List<Product> products) {
    List<DeliveryLineEditDto> deliveryLineDtos = [];
    for (var product in products) {
      var line = widget.deliveryLines.firstWhere(
              (deliveryLine) => deliveryLine.product.uuid == product.uuid,
          orElse: () {
                var newLine = DeliveryLine(
                    uuid: const Uuid().v4(),
                    deliveryUuid: widget.deliveryUuid,
                    product: product,
                    productQuantity: 0,
                    productUnitPrice: product.unitBasePrice);
                widget.deliveryLines.add(newLine);
                return newLine;
              });
      var quantityEditCtlr = TextEditingController();
      quantityEditCtlr.text = '${line.productQuantity}';
      quantityEditCtlr.addListener(() => line.productQuantity = int.parse(quantityEditCtlr.value.text));

      var unitPriceEditCtlr = TextEditingController();
      unitPriceEditCtlr.text = '${product.unitBasePrice}';
      unitPriceEditCtlr.addListener(() => line.productUnitPrice = int.parse(unitPriceEditCtlr.value.text));

      var lineEditDto = DeliveryLineEditDto(
          deliveryLine: line,
          quantityEditController: quantityEditCtlr,
          unitPriceEditController: unitPriceEditCtlr,
          editUnitPriceFocusNode: FocusNode());
      deliveryLineDtos.add(lineEditDto);
    }
    return deliveryLineDtos;
  }

  int deliveryTotalPrice() {
    return deliveryLineEditDtos
        .map((lineEditDto) => lineEditDto.deliveryLine)
        .map((e) => e.productQuantity * e.productUnitPrice)
        .reduce((value, element) => value + element);
  }

  int lineTotalPrice(String productUuid) {
    var line = deliveryLineEditDtos
        .firstWhere((line) => line.deliveryLine.product.uuid == productUuid)
        .deliveryLine;
    return line.productUnitPrice * line.productQuantity;
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
            rows: products.map((product) {
              var lineEditDto = deliveryLineEditDtos.firstWhere((lineDto) => lineDto.deliveryLine.product.uuid == product.uuid);
              return DataRow(cells: <DataCell>[
                DataCell(Text(product.description)),
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
                        decoration: const InputDecoration(border: InputBorder.none),
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
                        decoration: const InputDecoration(border: InputBorder.none),
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
                    Text('${lineTotalPrice(product.uuid)}'),
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
