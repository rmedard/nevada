import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/services/test_data_service.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';

class Configurations extends StatefulWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  State<Configurations> createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var regions = ConfigurationsService().getRegions(hasAllOption: false);
    var products = ProductsService().getAll();
    var textTheme = Theme.of(context).textTheme;
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Configurations',
        actions: const SizedBox.shrink(),
        body: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              columns: const [
                                DataColumn(label: Text('#')),
                                DataColumn(label: Text('Nom')),
                                DataColumn(label: Text('')),
                              ],
                              rows: regions.entries.mapIndexed<DataRow>((index, element) => DataRow(cells: [
                                DataCell(Text(('${++index}'))),
                                DataCell(Text(element.value)),
                                DataCell(Row(children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      iconSize: 20,
                                      splashRadius: 20,
                                      onPressed: (){}),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 20,
                                      splashRadius: 20,
                                      onPressed: (){}),
                                ],))
                              ])).toList())
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(children: [
                  FilledButton(
                      onPressed: () {
                        TestDataService().removeAllData();
                        setState(() {});
                      },
                      style: FilledButton.styleFrom(backgroundColor: colorScheme.secondary),
                      child: const Text('Remove all data')),
                  const SizedBox(width: 10),
                  FilledButton(
                      onPressed: () {
                        TestDataService().initTestData();
                        setState(() {});
                      },
                      child: const Text('Init test data')),
                ],),
              )
            ],
          ),
        ));
  }
}
