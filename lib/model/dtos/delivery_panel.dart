import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/hiveDtos/delivery_line.dart';
import 'package:nevada/services/configurations_service.dart';

class DeliveryPanel {
  bool isExpanded;
  Delivery delivery;

  DeliveryPanel({required this.isExpanded, required this.delivery});

  List<DataRow> _computeRows() {
    var rows = delivery.lines.values
        .map<DataRow>((line) => DataRow(cells: [
              DataCell(Text(line.product.name)),
              DataCell(Text('${line.productQuantity}')),
              DataCell(Text('${line.productUnitPrice} MT')),
              DataCell(Text('${line.total} MT')),
            ]))
        .toList();
    rows.add(
        DataRow(
            cells: [
              const DataCell(SizedBox.shrink()),
              const DataCell(SizedBox.shrink()),
              const DataCell(SizedBox.shrink()),
              DataCell(Text(
                  '${delivery.lines.values.map((line) => line.total).reduce((value, element) => value + element)} MT',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
            color: MaterialStateColor.resolveWith((states) => Colors.grey[200]!)));
    return rows;
  }

  ExpansionPanel toPanel() {
    return ExpansionPanel(
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
              title: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(delivery.customer.names),
                          Text(
                            ConfigurationsService()
                                .getRegion(delivery.customer.location),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(DateFormat('EEEE, dd-MM-yyyy')
                          .format(delivery.date))),
                  Expanded(
                      flex: 1,
                      child: Text(
                          '${delivery.lines.values.map((line) => line.total).reduce((value, element) => value + element)} MT'))
                ],
              ),
            ),
        body: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(color: Colors.grey[100]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: DataTable(
                    showBottomBorder: false,
                    columns: const [
                  DataColumn(label: Text('Produit')),
                  DataColumn(label: Text('Quantité')),
                  DataColumn(label: Text('Prix unitaire')),
                  DataColumn(label: Text('Prix total')),
                ], rows: _computeRows()),
              )
            ],
          ),
        ),
        isExpanded: isExpanded);
  }
}
