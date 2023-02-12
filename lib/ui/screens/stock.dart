import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/services/production_service.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/table_column_title.dart';
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
    var products = ProductsService().getAll();
    var productions = ProductionService().getAll();
    var stockEditorController = TextEditingController(text: '0');

    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Produits',
        actions: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Nouveau Produit'),
          style: FilledButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DataTable(
                  headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark),
                  columns: const <DataColumn>[
                    DataColumn(label: Text('#')),
                    DataColumn(label: TableColumnTitle(title: 'Nom du produit')),
                    DataColumn(label: TableColumnTitle(title: 'Prix unitaire')),
                    DataColumn(label: TableColumnTitle(title: 'Déscription')),
                    DataColumn(label: TableColumnTitle(title: '')),
                    DataColumn(label: TableColumnTitle(title: 'Stock')),
                    DataColumn(label: TableColumnTitle(title: ''))
                  ],
                  rows: products
                      .asMap()
                      .entries
                      .map<DataRow>((e) => DataRow(cells: [
                            DataCell(Text('${e.key + 1}')),
                            DataCell(Text(e.value.name)),
                            DataCell(Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${e.value.unitBasePrice}'),
                                Text('MT', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            )),
                            DataCell(Text(e.value.description)),
                            DataCell(IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {},
                            )),
                            DataCell(Text('${e.value.totalStock}')),
                            DataCell(FilledButton.icon(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return AlertDialog(
                                          icon: const Icon(Nevada.box_open),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          content: Container(
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
                                          ),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actionsPadding: const EdgeInsets.only(bottom: 20),
                                          actions: [
                                            DefaultButton(
                                              label: 'Sauvegarder',
                                              onSubmit: () {
                                                var stockRefill = StockRefill(uuid: const Uuid().v4(), date: DateTime.now(), product: e.value, productQuantity: int.parse(stockEditorController.value.text));
                                                ProductionService().createNew(stockRefill.uuid, stockRefill).then((created) {
                                                  setState(() {
                                                     e.value.totalStock += int.parse(stockEditorController.value.text);
                                                     ProductsService().update(e.value);
                                                  });
                                                });
                                                Navigator.pop(dialogContext);
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }, label: Text('Production'),))
                          ]))
                      .toList()),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DataTable(
                    headingTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Produit')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Quantité produite (cartons)')),
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
            )
          ],
        ));
  }
}
