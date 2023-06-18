import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/providers/stock_status_notifier.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/customers_service.dart';
import 'package:nevada/services/dtos/snackbar_message.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/services/transactions_service.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/dialogs/delivery_dialog.dart';
import 'package:nevada/ui/forms/customer_edit_form.dart';
import 'package:nevada/ui/screens/entities/customer_page.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:nevada/ui/utils/ui_utils.dart';
import 'package:nevada/utils/date_tools.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CustomersList extends StatefulWidget {
  final List<Customer> customers;
  const CustomersList({Key? key, required this.customers}) : super(key: key);

  @override
  State<CustomersList> createState() => _CustomersListState();
}

Future<Uint8List> _generatePdf(PdfPageFormat format, String title, List<Customer> clients) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.nunitoExtraLight();
  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(title, style: pw.TextStyle(font: font, fontSize: 30)),
                pw.Text(DateTools.formatter.format(DateTime.now()), style: pw.TextStyle(font: font, fontSize: 20))
              ]
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
                headers: ['Noms', 'Téléphone', 'Créance', 'Livraison'],
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(2),
                },
                data: clients.map((e) => [e.names, e.phone, '${e.balance} Mt','']).toList())
          ],
        );
      },
    ),
  );
  return pdf.save();
}

class _CustomersListState extends State<CustomersList> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var stockStatusNotifier = Provider.of<StockStatusNotifier>(context);
    return DataTable(
        columns: <DataColumn>[
          const DataColumn(label: Text('#')),
          const DataColumn(label: Text('Nom')),
          const DataColumn(label: Text('Téléphone')),
          const DataColumn(label: Text('Dernière livraison')),
          const DataColumn(label: Text('Créance')),
          DataColumn(label: FilledButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('Imprimer'),
              onPressed: (){
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                      title: const Text('Imprimer'),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: PdfPreview(
                          build:  (format) => _generatePdf(format, 'Nevada', widget.customers),
                          allowSharing: false,
                          canChangeOrientation: false,
                          canChangePageFormat: false,
                          canDebug: false
                        ),
                      ));
                });
          })),
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
          DataCell(Text(customer.lastDeliveryDate != null ? DateTools.formatter.format(customer.lastDeliveryDate!) : '-')),
          DataCell(customer.balanceText),
          DataCell(Row(
            children: [
              IconButton(
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
                  tooltip: 'Modifier',
                  icon: const Icon(Nevada.pencil, size: 18),
                  splashRadius: 20),
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        var newDelivery = Delivery(uuid: const Uuid().v4(), customer: customer, date: DateTime.now());
                        return DeliveryDialog(delivery: newDelivery, isNew: true, dialogContext: context);
                      }).then((value) {
                        stockStatusNotifier.update(ProductsService().stockHasWarnings());
                        setState(() {});
                  }),
                  tooltip: 'Livraison',
                  icon: const Icon(Nevada.truck_loading, size: 18),
                  splashRadius: 20),
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context){
                      var paymentTransaction = Transaction.empty();
                      paymentTransaction.senderUuid = customer.uuid;
                      paymentTransaction.status = TransactionStatus.paid;
                      paymentTransaction.type = TransactionType.income;
                      var paymentAmountController = TextEditingController(text: '${paymentTransaction.amount}');
                      var paymentDateController = TextEditingController(text: DateTools.formatter.format(paymentTransaction.createdAt));
                      var paymentCommentController = TextEditingController(text: '${paymentTransaction.comment}');

                      paymentAmountController.addListener(() => paymentTransaction.amount = int.tryParse(paymentAmountController.value.text) ?? 0);
                      paymentDateController.addListener(() => paymentTransaction.createdAt = DateTime.parse(paymentDateController.value.text));
                      paymentCommentController.addListener(() => paymentTransaction.comment = paymentCommentController.value.text);
                      return AlertDialog(
                        title: Text('Paiement de: ${customer.names}'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BasicContainer(
                              child: TextField(
                                decoration: const InputDecoration(label: Text('Montant payé')),
                                controller: paymentAmountController,
                              ),
                            ),
                            const SizedBox(height: 20),
                            BasicContainer(
                                child: TextField(
                                  decoration: const InputDecoration(label: Text('Date de paiement')),
                                  controller: paymentDateController,
                                )),
                            const SizedBox(height: 20),
                            const BasicContainer(
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        label: Text('Commentaire')),
                                ))
                        ],),
                        actions: [
                          FilledButton(
                              onPressed: () => Navigator.pop(context, paymentTransaction),
                              child: const Text('Confirmer'))
                        ],
                      );
                    }).then((transaction) {
                      if (transaction is Transaction) {
                        TransactionsService().createNew(const Uuid().v4().toString(), transaction).then((_) {
                          customer.balance += transaction.amount;
                          CustomersService().update(customer);
                        });
                      }
                    });
                  },
                  tooltip: 'Paiement',
                  icon: const Icon(Nevada.coins, size: 18),
                  splashRadius: 20),
              const SizedBox(width: 30),
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerPage(customer: customer)));
                  },
                  tooltip: 'Détails',
                  icon: const Icon(Icons.arrow_right_rounded, size: 18),
                  splashRadius: 20),
            ],
          ))
        ]))
            .toList());
  }
}
