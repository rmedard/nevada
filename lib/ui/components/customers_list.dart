import 'package:flutter/material.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/table_column_title.dart';
import 'package:nevada/ui/forms/customer_delivery_form.dart';
import 'package:nevada/ui/forms/customer_edit_form.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
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
    return DataTable(
        headingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark),
        columns: const <DataColumn>[
          DataColumn(label: TableColumnTitle(title: '#')),
          DataColumn(label: TableColumnTitle(title: 'Nom')),
          DataColumn(
              label: TableColumnTitle(title: 'Téléphone')),
          DataColumn(
              label: TableColumnTitle(
                  title: 'Dernière livraison')),
          DataColumn(label: TableColumnTitle(title: 'Créance')),
          DataColumn(label: TableColumnTitle(title: '')),
        ],
        rows: widget.customers
            .asMap()
            .entries
            .map<DataRow>((e) => DataRow(cells: [
          DataCell(Text('${e.key + 1}')),
          DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(e.value.names),
              Text(
                ConfigurationsService()
                    .getRegion(e.value.location),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey[600]),
              )
            ],
          )),
          DataCell(Text(e.value.phone)),
          DataCell(Text('24/12/2022')),
          DataCell(Text(
            '3500 MT',
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold),
          )),
          DataCell(Row(
            children: [
              FilledButton.icon(
                  onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: Text('Client', style: Theme.of(context).textTheme.headlineLarge),
                          content: CustomerEditForm(
                              customer: e.value,
                              editCustomer: (Customer newCustomer) {
                                debugPrint(newCustomer.uuid);
                              }),
                          actions: const [DefaultButton(label: 'Sauvegarder')],
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
                      elevation: 0, backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        var newDelivery = Delivery(
                            uuid: const Uuid().v4(),
                            customer: e.value,
                            date: DateTime.now());
                        return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            content: CustomerDeliveryForm(delivery: newDelivery, isNew: true),
                            actionsPadding: const EdgeInsets.all(20),
                            actions: const [
                              DefaultButton(label: 'Sauvegarder')
                            ]);
                      })),
            ],
          ))
        ]))
            .toList());
  }
}