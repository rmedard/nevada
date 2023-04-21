import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/utils/date_tools.dart';

class ProductionDialog extends StatelessWidget {

  final StockRefill stockRefill;

  const ProductionDialog({Key? key, required this.stockRefill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stockEditorController = TextEditingController(text: '${stockRefill.productQuantity}');
    var productionDateController = TextEditingController(text: DateTools.formatter.format(stockRefill.date));
    stockEditorController.addListener(() {
      stockRefill.productQuantity = int.tryParse(stockEditorController.text) ?? 0;
    });

    return AlertDialog(
      icon: const Icon(Nevada.box_open),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              readOnly: true,
              controller: productionDateController,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_month),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
              onTap: () {
                showDatePicker(
                    context: context,
                    initialDate: stockRefill.date,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 30))
                ).then((value) {
                  if (value != null) {
                    stockRefill.date = value;
                    productionDateController.text = DateTools.formatter.format(value);
                  }
                });
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
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*'))
              ],
              decoration: const InputDecoration(
                  suffixText: 'Cartons',
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
            if (stockRefill.isValid) {
              Navigator.of(context).pop(stockRefill);
            }
          },
        )
      ],
    );
  }
}
