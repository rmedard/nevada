import 'package:flutter/material.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/services/clients_service.dart';
import 'package:nevada/ui/components/default_button.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/separator.dart';
import 'package:nevada/ui/components/table_column_title.dart';
import 'package:nevada/ui/forms/customer_delivery_form.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';
import 'package:uuid/uuid.dart';

class Clients extends StatelessWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var clients = CustomersService().getAll();
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Clients',
        actions: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Nouveau Client'),
          style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.all(15),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        ),
        body: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Row(
                      children: [
                        MetricCard(body: Column(
                          children: [
                            Text('Nom du client'),
                            Text('region'),
                          ],
                        )),
                        const SizedBox(width: 20),
                        MetricCard(
                          body: Row(
                            children: [
                              Icon(Icons.people_alt, color: Theme.of(context).primaryColor),
                              const Separator(direction: SeparatorDirection.vertical),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Clients'),
                                  Text(
                                    clients.length.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                  child: SingleChildScrollView(
                    child: DataTable(
                        headingTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark),
                        columns: const <DataColumn>[
                          DataColumn(label: TableColumnTitle(title: '#')),
                          DataColumn(label: TableColumnTitle(title: 'Nom')),
                          DataColumn(label: TableColumnTitle(title: 'Téléphone')),
                          DataColumn(label: TableColumnTitle(title: 'Dernière livraison')),
                          DataColumn(label: TableColumnTitle(title: 'Créance')),
                          DataColumn(label: TableColumnTitle(title: '')),
                        ],
                        rows: clients
                            .asMap()
                            .entries
                            .map<DataRow>((e) => DataRow(cells: [
                          DataCell(Text('${e.key + 1}')),
                          DataCell(Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value.names),
                              Text(e.value.location,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),)
                            ],
                          )),
                          DataCell(Text(e.value.phone)),
                          DataCell(Text('24/12/2022')),
                          DataCell(Text('3500 MT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
                          DataCell(OutlinedButton.icon(
                              icon: const Icon(Nevada.add, size: 15),
                              label: const Text('Livraison'),
                              style: OutlinedButton.styleFrom( foregroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                              ),
                              onPressed: () => showDialog(context: context, builder: (context) {
                                var newDelivery = Delivery(uuid: const Uuid().v4(), customer: e.value, date: DateTime.now());
                                return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    content: CustomerDeliveryForm(delivery: newDelivery, isNew: true),
                                    actions: const [
                                      DefaultButton(label: 'Sauvegarder')
                                    ]);
                              })))
                        ]))
                            .toList()),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
