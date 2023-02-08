import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/dtos/delivery_line_edit_dto.dart';
import 'package:nevada/model/product.dart';
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
  List<DeliveryLineEditDto> deliveryLineEditDtos = [];

  @override
  void initState() {
    super.initState();
    products = ProductsService().getAll();

    for (var product in products) {
      var line = widget.delivery.lines.firstWhere(
          (deliveryLine) => deliveryLine.product.uuid == product.uuid,
          orElse: () => DeliveryLine(
              uuid: const Uuid().v4(),
              deliveryUuid: widget.delivery.uuid,
              product: product,
              productQuantity: 0,
              productUnitPrice: product.unitBasePrice));
      var quantityEditCtlr = TextEditingController();
      quantityEditCtlr.text = '${line.productQuantity}';

      var unitPriceEditCtlr = TextEditingController();
      unitPriceEditCtlr.text = '${product.unitBasePrice}';

      var lineEditDto = DeliveryLineEditDto(
          deliveryLine: line,
          quantityEditController: quantityEditCtlr,
          unitPriceEditController: unitPriceEditCtlr,
          editUnitPriceFocusNode: FocusNode());
      deliveryLineEditDtos.add(lineEditDto);
    }
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
            ],
            rows: products.map((product) {
              var lineEditDto = deliveryLineEditDtos.firstWhere((element) => element.deliveryLine.product.uuid == product.uuid);
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
                    Text('MT', style: textTheme.headlineSmall)
                  ],
                )),
              ]);
            }).toList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Prix Total', style: textTheme.headlineMedium),
            const SizedBox(width: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${deliveryTotalPrice()}', style: textTheme.displaySmall),
                Text('MT', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))
              ],
            ),
          ],
        )
      ],
    );
  }
}
