import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/dtos/snackbar_message.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/deliveries_service.dart';
import 'package:nevada/services/delivery_lines_service.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/delivery_payment_status.dart';
import 'package:nevada/ui/components/products_delivery_table.dart';
import 'package:nevada/ui/utils/ui_utils.dart';

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
    DateTime? paymentDueDate;
    TransactionStatus paymentStatus = TransactionStatus.pending;
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date de livraison', style: textTheme.titleMedium?.copyWith(color: Colors.grey[500])),
                  Text(DateFormat('EEEE, dd/MM/yyyy').format(DateTime.now()), style: textTheme.titleMedium),
                ]),
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
                ])
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDeliveryTable(deliveryUuid: delivery.uuid, deliveryLines: deliveryLines),
                Visibility(visible: isNew,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: DeliveryPaymentStatus(
                        onPaymentStatusChanged: (TransactionStatus status) => paymentStatus = status,
                        onPaymentDueDateChanged: (DateTime? dueDate) => paymentDueDate = dueDate)),
                )
              ]),
        ),
        actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
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
                    .createNewDelivery(delivery, paymentStatus, paymentDueDate)
                    .then((_) => UiUtils().showSnackBar(context, SnackbarMessage(messageType: MessageType.success, title: 'Création de livraison', message: 'Livraison enregistrée')));
              } else {
                DeliveriesService()
                    .update(delivery)
                    .then((updated) => UiUtils().showSnackBar(context, SnackbarMessage(messageType: MessageType.success, title: 'Modification de livraison', message: 'Livraison modifiée avec succès')));
              }
            }
          })
        ]);
  }
}
