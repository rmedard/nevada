import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/services/test_data_service.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';

class Configurations extends StatefulWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  State<Configurations> createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  @override
  Widget build(BuildContext context) {
    var regions = ConfigurationsService().getRegions(hasAllOption: false);
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
                  MetricCard(
                    horizontalPadding: 20,
                    verticalPadding: 20,
                    body: Column(
                      children: [
                        Text('Quartiers', style: textTheme.displaySmall),
                        DataTable(
                            columns: const [
                              DataColumn(label: Text('#')),
                              DataColumn(label: Text('Nom')),
                              DataColumn(label: Text('')),
                            ],
                            rows: regions.entries.mapIndexed<DataRow>((index, element) => DataRow(cells: [
                              DataCell(Text(('${++index}.'))),
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
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(children: [
                  FilledButton.tonal(
                      onPressed: () {
                        TestDataService().removeAllData();
                        setState(() {});
                      },
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
