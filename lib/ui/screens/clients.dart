import 'package:flutter/material.dart';
import 'package:nevada/services/clients_service.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/separator.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

class Clients extends StatelessWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var clients = CustomersService().getAll();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                      columns: const <DataColumn>[
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Nom')),
                        DataColumn(label: Text('Quartier')),
                        DataColumn(label: Text('Téléphone')),
                        DataColumn(label: Text('Dernière livraison')),
                        DataColumn(label: Text('Créance')),
                        DataColumn(label: Text('Livraison', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: clients
                          .asMap()
                          .entries
                          .map<DataRow>((e) => DataRow(cells: [
                                DataCell(Text('${e.key + 1}')),
                                DataCell(Text(e.value.names)),
                                DataCell(Text(e.value.location)),
                                DataCell(Text(e.value.phone)),
                                DataCell(Text('24/12/2022')),
                                DataCell(Text('3500 MT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
                                DataCell(OutlinedButton.icon(
                                    icon: const Icon(Nevada.add, size: 15),
                                    label: const Text('Livraison'),
                                    style: OutlinedButton.styleFrom( foregroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 6),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                    ),
                                    onPressed: (){}))
                              ]))
                          .toList()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
