import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';

class Configurations extends StatelessWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var regions = ConfigurationsService().getRegions(hasAllOption: false);
    var products = ProductsService().getAll();
    var textTheme = Theme.of(context).textTheme;
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Configurations',
        actions: const SizedBox.shrink(),
        body: Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text('Quartiers', style: textTheme.displaySmall),
                          DataTable(
                            headingTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark),
                              columns: const [
                                DataColumn(label: Text('#')),
                                DataColumn(label: Text('Nom')),
                              ],
                              rows: regions.entries.mapIndexed<DataRow>((index, element) => DataRow(cells: [
                                DataCell(Text(('${++index}'))),
                                DataCell(Text(element.value))
                              ])).toList())
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
