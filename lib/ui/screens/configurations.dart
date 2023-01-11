import 'package:flutter/material.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/products_service.dart';

class Configurations extends StatelessWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var regions = ConfigurationsService().getRegions();
    return Expanded(child: Row(children: [
      Container(child: Column(children: [
        Text('Régions'),
        DataTable(columns: [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Nom')),
        ], rows: regions
            .asMap()
            .entries.map<DataRow>((e) => DataRow(cells: [
              DataCell(Text('${e.key}')),
              DataCell(Text(e.value))
        ])).toList())
      ],),)
    ],),);
  }
}
