import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/snackbar_message.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/customers_service.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/dialogs/delivery_dialog.dart';
import 'package:nevada/ui/forms/customer_edit_form.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/ui/utils/ui_utils.dart';
import 'package:uuid/uuid.dart';

class CustomersList extends StatefulWidget {
  final List<Customer> customers;
  const CustomersList({Key? key, required this.customers}) : super(key: key);

  @override
  State<CustomersList> createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Nom')),
          DataColumn(label: Text('Téléphone')),
          DataColumn(label: Text('Dernière livraison')),
          DataColumn(label: Text('Créance')),
          DataColumn(label: Text('')),
        ],
        rows: widget.customers.mapIndexed<DataRow>((index, customer) => DataRow(cells: [
          DataCell(Text('${++index}')),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(customer.names),
              Text(
                ConfigurationsService().getRegion(customer.location),
                style: textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
              )
            ],
          )),
          DataCell(Text(customer.phone)),
          DataCell(Text(customer.lastDeliveryDate != null ? DateFormat('dd/MM/yyyy').format(customer.lastDeliveryDate!) : '-')),
          DataCell(customer.balanceText),
          DataCell(Row(
            children: [
              FilledButton.icon(
                  onPressed: () {
                    showDialog(context: context, builder: (dialogContext) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: Text('Client', style: Theme.of(dialogContext).textTheme.headlineLarge),
                          content: CustomerEditForm(
                              customer: customer,
                              editCustomer: (Customer newCustomer) {
                                debugPrint(newCustomer.uuid);
                              }),
                          actions: [
                            DefaultButton(
                                label: 'Supprimer',
                                buttonStyle: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: colorScheme.error),
                                onSubmit: () {
                                  CustomersService().delete(customer.uuid).then((deleted) {
                                    const String title = 'Suppression de client';
                                    String message;
                                    MessageType messageType;
                                    if (deleted) {
                                      message = 'Client supprimé avec succès';
                                      messageType =  MessageType.success;
                                      setState(() => widget.customers.removeWhere((customer) => customer.uuid == customer.uuid));
                                    } else {
                                      message = 'Suppression du client échouée';
                                      messageType = MessageType.error;
                                    }
                                    UiUtils().showSnackBar(dialogContext, SnackbarMessage(messageType: messageType, title: title, message: message));
                                  });
                                }),
                            DefaultButton(
                                label: 'Sauvegarder',
                                onSubmit: () {
                                  CustomersService().update(customer).then((updated) {
                                    const String title = 'Mise à jour du client';
                                    String message;
                                    MessageType messageType;
                                    if (updated) {
                                      message = 'Détails du client mis à jour avec succès';
                                      messageType =  MessageType.success;
                                      setState((){});
                                    } else {
                                      message = 'Mise à jour du client échouée';
                                      messageType = MessageType.error;
                                    }
                                    UiUtils().showSnackBar(dialogContext, SnackbarMessage(messageType: messageType, title: title, message: message));
                                  });
                                })
                          ],
                          actionsPadding: const EdgeInsets.all(20));
                    });
                  },
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
                  icon: const Icon(Nevada.pencil_fill, size: 15),
                  label: const Text('Modifier')),
              const SizedBox(width: 10),
              FilledButton.icon(
                  icon: const Icon(Nevada.truck_loading, size: 15),
                  label: const Text('Livraison'),
                  style: FilledButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (dialogContext) {
                        var newDelivery = Delivery(uuid: const Uuid().v4(), customer: customer, date: DateTime.now());
                        return DeliveryDialog(delivery: newDelivery, isNew: true, dialogContext: dialogContext);
                      })),
            ],
          ))
        ]))
            .toList());
  }
}
