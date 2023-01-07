import 'package:flutter/material.dart';
import 'package:nevada/services/clients_service.dart';

class Clients extends StatelessWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var clients = CustomersService().getAll();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: SizedBox(height: MediaQuery.of(context).size.height * 0.2, child: Card(
            color: Colors.blueGrey,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Icon(Icons.people_alt),
                ),
                const VerticalDivider(thickness: 2, color: Colors.white, indent: 20, endIndent: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Clients'),
                      Text(clients.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Quartier')),
                  DataColumn(label: Text('Téléphone')),
                ],
                rows: clients.asMap().entries.map<DataRow>((e) => DataRow(cells: [
                  DataCell(Text('${e.key + 1}')),
                  DataCell(Text(e.value.names)),
                  DataCell(Text(e.value.location)),
                  DataCell(Text(e.value.phone))
                ])).toList()),
          ),
        ),
      ],
    );
  }
}
