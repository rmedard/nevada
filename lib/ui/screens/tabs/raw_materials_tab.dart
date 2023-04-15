import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/raw_material_movement.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/services/raw_materials_service.dart';
import 'package:nevada/ui/components/dialogs/raw_material_dialog.dart';
import 'package:nevada/utils/date_tools.dart';

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
    var colorScheme = Theme
        .of(context)
        .colorScheme;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                FilledButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context, builder: (context) {
                        return RawMaterialDialog(
                            title: 'Sortie de matière première',
                            rawMaterialMovement: RawMaterialMovement.empty(
                                MaterialMovementType.released),
                            bottleSizes: bottleSizes);
                      }).then((value) {
                        if (value is RawMaterialMovement) {
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
                      if (value is RawMaterialMovement) {
                        RawMaterialsService()
                            .createNew(value.uuid, value)
                            .then((value) => setState(() {}));
                      }
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Perte'),
                  style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error),)
              ],
            ),
            DataTable(
                columns: [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Quantité')),
                  DataColumn(label: Text('Date')),
                ], rows: raws.mapIndexed<DataRow>((index, rawMaterial) => DataRow(cells: [
                  DataCell(Text('${++index}.')),
                  DataCell(Text('${rawMaterial.movementType.name}')),
                  DataCell(Text('${rawMaterial.quantity}')),
                  DataCell(Text(DateTools.basicDateFormatter.format(rawMaterial.date))),
    ])).toList()),
            Center(child: raws.isEmpty ? Text('Empty') : Text('${raws.first.date} | ${raws.first.quantity}')),
          ],
        ),
      ),
    );
  }
}
