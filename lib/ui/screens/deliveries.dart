import 'package:flutter/material.dart';
import 'package:nevada/services/deliveries_service.dart';

class Deliveries extends StatelessWidget {
  const Deliveries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deliveries = DeliveriesService().getAll();
    return Expanded(
        child: Padding(padding: EdgeInsets.all(20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Livraisons', style: Theme.of(context).textTheme.headline1),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Nouvelle Livraison'),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all(15),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                )
              ],
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              child: deliveries.isEmpty ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('Pas de livraisons', style: Theme.of(context).textTheme.headline4,)),
              ) : DataTable(
                headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark),
                columns: const [
                  DataColumn(label: Text('Client')),
                  DataColumn(label: Text('Quartier')),
                  DataColumn(label: Text('Date'))
                ],
                rows: deliveries.map((e) => DataRow(cells: [
                  DataCell(Text(e.customer.names)),
                  DataCell(Text(e.customer.location)),
                  DataCell(Text(e.date.toString())),
                ])).toList()),
            )
          ],)));
  }
}
