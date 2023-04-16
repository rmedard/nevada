import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/raw_material_movement.dart';
import 'package:nevada/utils/date_tools.dart';
import 'package:nevada/utils/num_utils.dart';

class RawMaterialDialog extends StatelessWidget {
  final String title;
  final RawMaterialMovement rawMaterialMovement;
  final Set<String> bottleSizes;
  const RawMaterialDialog({Key? key, required this.title, required this.rawMaterialMovement, required this.bottleSizes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var dateController = TextEditingController(text: DateTools.formatter.format(rawMaterialMovement.date));
    var quantityController = TextEditingController(text: '${rawMaterialMovement.quantity}');
    quantityController.addListener(() {
      rawMaterialMovement.quantity = int.tryParse(quantityController.value.text) ?? 0;
    });

    if (rawMaterialMovement.unitSize == 0) {
      rawMaterialMovement.unitSize = double.parse(bottleSizes.first);
    }

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: dateController,
              decoration: const InputDecoration(label: Text('Date')),
              readOnly: true,
              onTap: () {
                showDatePicker(
                    context: context,
                    initialDate: rawMaterialMovement.date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(3020)
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    rawMaterialMovement.date = selectedDate;
                    dateController.text = DateTools.formatter.format(rawMaterialMovement.date);
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(10)),
            child: DropdownButtonFormField(
                value: NumUtils.stringify(rawMaterialMovement.unitSize),
                items: bottleSizes
                    .map<DropdownMenuItem<String>>((size) => DropdownMenuItem(value: size, child: Text('$size litres')))
                    .toList(),
                onChanged: (size){
                  if (StringUtils.isNotNullOrEmpty(size)) {
                    rawMaterialMovement.unitSize = double.parse(size!);
                  }
                }),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(label: Text('Quantité')),
            ),
          )
        ],),
      actions: [
        FilledButton.tonal(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler')),
        FilledButton(
            onPressed: () => Navigator.pop(context, rawMaterialMovement),
            child: const Text('Enregistrer'))
      ],
    );
  }
}
