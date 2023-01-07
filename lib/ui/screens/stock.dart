import 'package:flutter/material.dart';
import 'package:nevada/services/products_service.dart';

class Stock extends StatelessWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var products = ProductsService().getAll();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Produits',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('')),
                DataColumn(label: Text('Nom du produit')),
                DataColumn(label: Text('Prix unitaire')),
                DataColumn(label: Text('Déscription')),
                DataColumn(label: Text('Stock')),
                DataColumn(label: Text('Actions'))
              ],
              rows: products
                  .asMap()
                  .entries
                  .map<DataRow>((e) => DataRow(cells: [
                        DataCell(Text('#${e.key + 1}')),
                        DataCell(Text(e.value.name)),
                        DataCell(Text('${e.value.unitBasePrice} MZN')),
                        DataCell(Text(e.value.description)),
                        DataCell(Text('${e.value.totalStock}')),
                        DataCell(Row(
                          children: [
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.redAccent,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 20),
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.green,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            )
                          ],
                        ))
                      ]))
                  .toList())
        ],
      ),
    );
  }
}
