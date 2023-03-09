import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    var productions = ProductionService().getAll();
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
                      DataColumn(label: Text('Déscription')),
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('Stock')),
                      DataColumn(label: Text(''))
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
                                  Text('MT', style: textTheme.bodySmall),
                                ],
                              )),
                              DataCell(Text(e.value.description)),
                              DataCell(IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.deepOrange,
                                ), splashRadius: 20,
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
                ),
              )
            ],
          ),
        ));
  }
}
