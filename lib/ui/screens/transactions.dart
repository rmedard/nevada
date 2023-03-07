import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/services/transactions_service.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var transactions = TransactionsService().getAll();
    return ScreenElements().defaultBodyFrame(
        context: context, 
        title: 'Transactions',
        actions: Row(
          children: [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_downward),
              label: const Text('Nouvelle Dépense'),
              style: FilledButton.styleFrom(
                  elevation: 0,
                  backgroundColor: colorScheme.error,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(width: 20),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_upward),
              label: const Text('Nouvelle Entrée'),
              style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: DataTable(
              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Client')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Statut')),
              ],
              rows: transactions
                  .mapIndexed<DataRow>((index, transaction) => DataRow(cells: [
                    DataCell(Text('${++index}')),
                    DataCell(Text(DateFormat('dd-MM-yyyy').format(transaction.createdAt))),
                    DataCell(Text(TransactionsService().getCustomerName(transaction))),
                    DataCell(Text('${transaction.amount} MT')),
                    DataCell(transaction.type.icon),
                    DataCell(transaction.status.label)
                    ]))
                  .toList()
          ),
        ));
  }
}
