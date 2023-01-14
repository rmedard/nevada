import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/table_column_title.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class Stock extends StatelessWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var products = ProductsService().getAll();
    var stockEditorController = TextEditingController(text: '0');
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Produits', style: Theme.of(context).textTheme.headline1),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Nouveau Produit'),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all(15),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                )
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DataTable(
                headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark),
                  columns: const <DataColumn>[
                    DataColumn(label: Text('')),
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
                            DataCell(Text('#${e.key + 1}')),
                            DataCell(Text(e.value.name)),
                            DataCell(Text('${e.value.unitBasePrice} MZN')),
                            DataCell(Text(e.value.description)),
                            DataCell(IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {},
                            )),
                            DataCell(Text('${e.value.totalStock}')),
                            DataCell(IconButton(
                                icon: const Icon(Icons.add, color: Colors.green),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: const Icon(Nevada.box_open),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          content: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: TextField(
                                              autofocus: true,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))],
                                              decoration: const InputDecoration(
                                                  suffixText: 'Cartons',
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                              controller: stockEditorController,
                                            ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actionsPadding: const EdgeInsets.only(bottom: 20),
                                          actions: const [
                                            DefaultButton(label: 'Sauvegarder')
                                          ],
                                        );
                                      });
                                }))
                          ]))
                      .toList()),
            )
          ],
        ),
      ),
    );
  }
}
