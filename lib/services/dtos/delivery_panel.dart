import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/delivery_line.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/utils/num_utils.dart';

class DeliveryPanel {
  bool isExpanded;
  Delivery delivery;

  DeliveryPanel({required this.isExpanded, required this.delivery});

  List<DataRow> _computeRows() {
    var rows = delivery.lines.values
        .map<DataRow>((line) => DataRow(cells: [
              DataCell(Text(line.product.name)),
              DataCell(Text('${line.productQuantity}')),
              DataCell(Text('${line.productUnitPrice.asMoney} MT')),
              DataCell(Text('${line.total.asMoney} MT')),
            ]))
        .toList();
    var totalAmount = delivery.lines.values.map((line) => line.total).reduce((value, element) => value + element);
    rows.add(
        DataRow(
            cells: [
              const DataCell(SizedBox.shrink()),
              const DataCell(SizedBox.shrink()),
              const DataCell(SizedBox.shrink()),
              DataCell(Text(
                  '${totalAmount.asMoney} MT',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
            color: MaterialStateColor.resolveWith((states) => Colors.grey[200]!)));
    return rows;
  }

  ExpansionPanel toPanel() {
    var deliveryTotalPrice = delivery.lines.values.map((line) => line.total).reduce((value, element) => value + element);
    return ExpansionPanel(
        backgroundColor: Colors.white,
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
                            ConfigurationsService().getRegion(delivery.customer.location),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                          '${deliveryTotalPrice.asMoney} MT'))
                ],
              ), style: ListTileStyle.list,
            ),
        body: Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(color: Colors.white),
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
