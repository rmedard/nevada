import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class Stock extends StatelessWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var products = ProductsService().getAll();
    var stockEditorController = TextEditingController(text: '0');
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Produits',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
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
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('Nom du produit')),
                    DataColumn(label: Text('Prix unitaire')),
                    DataColumn(label: Text('Déscription')),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text(''))
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
                                icon:
                                    const Icon(Icons.add, color: Colors.green),
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
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Text('Sauvegarder'),
                                              ),
                                            )
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
