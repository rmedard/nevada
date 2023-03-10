import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/services/production_service.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:uuid/uuid.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var products = ProductsService().getAll();
    var productions = ProductionService().getAllSorted();
    var stockEditorController = TextEditingController(text: '0');

    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Stock',
        actions: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Nouveau Produit'),
          style: FilledButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        ),
        body: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Produits', style: textTheme.headlineMedium),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Nom du produit')),
                      DataColumn(label: Text('Prix unitaire')),
                      DataColumn(label: Text('D??scription')),
                      DataColumn(label: Text('Stock')),
                      DataColumn(label: Text('')),
                      DataColumn(label: Text(''))
                    ],
                    rows: products
                        .mapIndexed<DataRow>((index, product) => DataRow(
                        cells: [
                              DataCell(Text('${++index}')),
                              DataCell(Text(product.name)),
                              DataCell(Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${product.unitBasePrice}'),
                                  Text('MT', style: textTheme.bodySmall),
                                ],
                              )),
                              DataCell(Text(product.description)),
                          DataCell(Row(
                            children: [
                              Text('${product.totalStock}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              product.hasValidStock ? const SizedBox.shrink() : const Icon(Icons.warning_rounded, size: 15, color: Colors.deepOrange)
                            ],
                          )),
                          DataCell(IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                ), splashRadius: 20,
                                onPressed: () {},
                              )),
                              DataCell(FilledButton.icon(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            icon: const Icon(Nevada.box_open),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                                                  child: TextField(
                                                    readOnly: true,
                                                    keyboardType: TextInputType.number,
                                                    decoration: const InputDecoration(
                                                        suffixIcon: Icon(Icons.calendar_month),
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                                    onTap: () {
                                                      showDatePicker(context: context, initialDate: DateTime.now(),
                                                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                                          lastDate: DateTime.now().add(const Duration(days: 30)));
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: TextField(
                                                  autofocus: true,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
                                                  ],
                                                  decoration: const InputDecoration(
                                                      suffixText: 'Cartons',
                                                      border: InputBorder.none,
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                                  controller: stockEditorController,
                                                ),
                                              )],
                                            ),
                                            actionsPadding: const EdgeInsets.only(bottom: 20, right: 20),
                                            actions: [
                                              DefaultButton(
                                                label: 'Sauvegarder',
                                                onSubmit: () {
                                                  var stockRefill = StockRefill(uuid: const Uuid().v4(), date: DateTime.now(), product: product, productQuantity: int.parse(stockEditorController.value.text));
                                                  ProductionService().createNew(stockRefill.uuid, stockRefill).then((created) {
                                                    setState(() {
                                                       product.totalStock += int.parse(stockEditorController.value.text);
                                                       ProductsService().update(product);
                                                    });
                                                  });
                                                  Navigator.pop(dialogContext);
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }, label: const Text('Production'),))
                            ]))
                        .toList()),
              ),
              const SizedBox(height: 20),
              Text('Production', style: textTheme.headlineMedium),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DataTable(
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Produit')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Quantit?? produite (cartons)')),
                          DataColumn(label: Text('')),
                        ],
                        rows: productions.asMap().entries.map<DataRow>((e) => DataRow(cells: [
                          DataCell(Text('${e.key + 1}')),
                          DataCell(Text(e.value.product.name)),
                          DataCell(Text(e.value.dateFormatted)),
                          DataCell(Text('${e.value.productQuantity}')),
                          DataCell(IconButton(icon: const Icon(Nevada.pencil_fill, size: 15), onPressed: () {  })),
                        ])).toList()),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
