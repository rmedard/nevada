import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/providers/stock_status_notifier.dart';
import 'package:nevada/services/production_service.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/components/dialogs/production_dialog.dart';
import 'package:nevada/ui/forms/product_edit_form.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/num_utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StockTab extends StatefulWidget {
  const StockTab({Key? key}) : super(key: key);

  @override
  State<StockTab> createState() => _StockTabState();
}

class _StockTabState extends State<StockTab> {
  @override
  Widget build(BuildContext context) {
    var stockStatusNotifier = Provider.of<StockStatusNotifier>(context);
    var textTheme = Theme.of(context).textTheme;

    var products = ProductsService().getAll();
    var productions = ProductionService().getAllSorted();
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Produits', style: textTheme.headlineMedium),
                FilledButton.icon(
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ProductEditForm(product: Product.empty(), isNew: true),
                            );
                          }).then((_) => setState(() {}));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nouveau Produit'))
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Produit')),
                    DataColumn(label: Text('Taille de bouteille')),
                    DataColumn(label: Text('Prix unitaire')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text(''))
                  ],
                  rows: products
                      .mapIndexed<DataRow>((index, product) => DataRow(
                      cells: [
                        DataCell(Text('${++index}.')),
                        DataCell(Text(product.name)),
                        DataCell(Text('${NumUtils.stringify(product.unitSize)} L')),
                        DataCell(Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${product.unitBasePrice}'),
                            Text('MT', style: textTheme.bodySmall),
                          ],
                        )),
                        DataCell(Row(
                          children: [
                            Text(product.totalStockLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                            product.hasValidStock ? const SizedBox.shrink() : const Icon(Icons.warning_rounded, size: 15, color: Colors.deepOrange)
                          ],
                        )),
                        DataCell(Row(children: [
                          IconButton(
                            icon: const Icon(Icons.edit), splashRadius: 20,
                            tooltip: 'Modifier',
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: ProductEditForm(product: product, isNew: false),
                                    );
                                  }).then((_) => setState(() {}));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.red,), splashRadius: 20,
                            tooltip: 'Supprimer',
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Supprimer le produit'), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Êtes-vous sûr de vouloir supprimer ce produit ?'),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Text('${product.name} | ${product.description}', style: textTheme.titleLarge),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Annuler')),
                                        FilledButton(
                                            onPressed: () => ProductsService().deleteProduct(product).then((_) => setState(() {})),
                                            child: const Text('Confimer')),
                                      ],
                                    );
                                  });
                            },
                          )
                        ],)),
                        DataCell(FilledButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Production'),
                            onPressed: product.isStockable ? () {
                              var stockRefill = StockRefill(uuid: const Uuid().v4(), date: DateTime.now(), product: product, productQuantity: 0);
                              showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return ProductionDialog(stockRefill: stockRefill);
                                  }).then((value) {
                                    if (value is StockRefill) {
                                      ProductionService()
                                          .createNew(value.uuid, value)
                                          .then((value) => stockStatusNotifier.update(ProductsService().stockHasWarnings()))
                                          .then((value) => setState((){}));
                                    }
                              });
                            } : null))
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
                      rows: productions.mapIndexed((index, stockRefill) => DataRow(cells: [
                        DataCell(Text('${index + 1}.')),
                        DataCell(Text(stockRefill.product.name)),
                        DataCell(Text(stockRefill.dateFormatted)),
                        DataCell(Text('${stockRefill.productQuantity}')),
                        DataCell(
                            IconButton(
                                icon: const Icon(Nevada.pencilFill, size: 15),
                                splashRadius: 20,
                                onPressed: () {  })),
                      ])).toList()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
