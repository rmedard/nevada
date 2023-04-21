import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/raw_material_movement.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/services/raw_materials_service.dart';
import 'package:nevada/ui/components/dialogs/raw_material_dialog.dart';
import 'package:nevada/utils/date_tools.dart';
import 'package:nevada/utils/num_utils.dart';

class RawMaterialsTab extends StatefulWidget {
  const RawMaterialsTab({Key? key}) : super(key: key);

  @override
  State<RawMaterialsTab> createState() => _RawMaterialsTabState();
}

class _RawMaterialsTabState extends State<RawMaterialsTab> {

  var bottleSizes = ProductsService().bottleSizes();

  @override
  Widget build(BuildContext context) {
    var raws = RawMaterialsService().getAll();
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FilledButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context, builder: (context) {
                        return RawMaterialDialog(
                            title: 'Sortie de matière première',
                            rawMaterialMovement: RawMaterialMovement.empty(MaterialMovementType.released),
                            bottleSizes: bottleSizes);
                      }).then((value) {
                        if (value is RawMaterialMovement && value.isValid) {
                          RawMaterialsService()
                              .createNew(value.uuid, value)
                              .then((value) => setState(() {}));
                        }
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Sortie de matière première')),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context, builder: (context) {
                      return RawMaterialDialog(title: 'Perte',
                          rawMaterialMovement: RawMaterialMovement.empty(
                              MaterialMovementType.defect),
                          bottleSizes: bottleSizes);
                    }).then((value) {
                      if (value is RawMaterialMovement && value.isValid) {
                        RawMaterialsService()
                            .createNew(value.uuid, value)
                            .then((value) => setState(() {}));
                      }
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Perte'),
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.error),)
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 10,
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Taille')),
                      DataColumn(label: Text('Qté')),
                      DataColumn(label: Text('')),
                    ], rows: raws.mapIndexed<DataRow>((index, rawMaterial) => DataRow(cells: [
                      DataCell(Text('${++index}.')),
                  DataCell(Text(DateTools.formatter.format(rawMaterial.date))),
                      DataCell(Text(rawMaterial.label,
                          style: textTheme.labelMedium?.copyWith(
                              color: rawMaterial.movementType == MaterialMovementType.defect ? colorScheme.error : colorScheme.primary))),
                      DataCell(Text('${NumUtils.stringify(rawMaterial.unitSize)} l')),
                      DataCell(Text('${rawMaterial.quantity}')),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text('Voulez-vous supprimer la ligne?'),
                                  actions: [
                                    FilledButton.tonal(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Non')),
                                    FilledButton(
                                        onPressed: () => RawMaterialsService()
                                            .delete(rawMaterial.uuid)
                                            .then((value) => Navigator.pop(context, true)),
                                        child: const Text('Oui')),
                                  ],
                                );
                              }).then((done) {
                            if (done) {
                              setState((){});
                            }});
                        }))
    ])).toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
