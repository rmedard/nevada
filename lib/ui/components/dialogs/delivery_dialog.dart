import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/dtos/snackbar_message.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/deliveries_service.dart';
import 'package:nevada/services/delivery_lines_service.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/delivery_payment_status.dart';
import 'package:nevada/ui/components/products_delivery_table.dart';
import 'package:nevada/ui/utils/utils_display.dart';

class DeliveryDialog extends StatelessWidget {

  final Delivery delivery;
  final bool isNew;
  final BuildContext dialogContext;

  const DeliveryDialog({Key? key, required this.delivery, required this.isNew, required this.dialogContext}) : super(key: key);

  List<DeliveryLine> _cleanUpDeliveryLines(List<DeliveryLine> lines) {
    lines.removeWhere((line) {
      if (line.productQuantity == 0) {
        if (line.isInBox) {
          DeliveryLinesService().delete(line.uuid);
        }
        return true;
      }
      return false;
    });
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    List<DeliveryLine> deliveryLines = _cleanUpDeliveryLines(delivery.lines.toList());

    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Livraison'),
        content: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date de livraison', style: textTheme.titleMedium?.copyWith(color: Colors.grey[500])),
                            Text(DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()), style: textTheme.titleMedium),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Client', style: textTheme.titleMedium?.copyWith(color: Colors.grey[500])),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(delivery.customer.names, style: textTheme.titleMedium),
                                Text(ConfigurationsService().getRegion(delivery.customer.location), style: textTheme.labelSmall),
                              ],
                            )
                          ]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ProductDeliveryTable(deliveryUuid: delivery.uuid, deliveryLines: deliveryLines),
                Visibility(visible: isNew,
                  child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: DeliveryPaymentStatus()),
                )
              ]),
        ),
        actionsPadding: const EdgeInsets.all(20),
        actions: [
          DefaultButton(label: 'Sauvegarder', onSubmit: () {
            _cleanUpDeliveryLines(deliveryLines).forEach((line) {
              if (line.isInBox) {
                line.save();
              } else {
                DeliveryLinesService().createNew(line.uuid, line);
              }
              delivery.lines.add(line);
            });
            if (DeliveriesService().isValidDelivery(delivery)) {
              if (isNew) {
                DeliveriesService()
                    .createNew(delivery.uuid, delivery)
                    .then((created) => UtilsDisplay().showSnackBar(context, SnackbarMessage(messageType: MessageType.success, title: 'Création de livraison', message: 'Livraison enregistrée')));
              } else {
                DeliveriesService()
                    .update(delivery)
                    .then((updated) => UtilsDisplay().showSnackBar(context, SnackbarMessage(messageType: MessageType.success, title: 'Modification de livraison', message: 'Livraison modifiée avec succès')));
              }
              Navigator.of(dialogContext).pop();
            }
          })
        ]);
  }
}
