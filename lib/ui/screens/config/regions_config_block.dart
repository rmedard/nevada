import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nevada/services/configurations_service.dart';
import 'package:nevada/ui/components/metric_card.dart';

class RegionsConfigBlock extends StatefulWidget {
  const RegionsConfigBlock({Key? key}) : super(key: key);

  @override
  State<RegionsConfigBlock> createState() => _RegionsConfigBlockState();
}

class _RegionsConfigBlockState extends State<RegionsConfigBlock> {

  late TextEditingController newRegionEditController;
  late bool newRegionHasText = false;


  @override
  void initState() {
    super.initState();
    newRegionEditController = TextEditingController();
    newRegionEditController.addListener(() {
      if (StringUtils.isNotNullOrEmpty(newRegionEditController.value.text) != newRegionHasText) {
       setState(() {
         newRegionHasText = StringUtils.isNotNullOrEmpty(newRegionEditController.value.text);
       });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var regions = ConfigurationsService().getRegions(hasAllOption: false);
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return MetricCard(
      horizontalPadding: 20,
      verticalPadding: 20,
      body: Column(
        mainAxisSize: MainAxisSize.min,
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
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: Text('Voulez-vous supprimer la région: ${element.value}'),
                                actions: [
                                  FilledButton.tonal(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Non')),
                                  FilledButton(onPressed: () => ConfigurationsService().deleteRegion(element.key).then((value) => Navigator.pop(context, true)), child: const Text('Oui')),
                                ],
                              );
                            }).then((done) {
                              if (done) {
                                setState((){});
                              }});
                      }),
                ],))
              ])).toList()),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: newRegionHasText ? (){
                        ConfigurationsService().createNewRegion(newRegionEditController.value.text).then((value) {
                          setState(() {
                            newRegionEditController.clear();
                          });
                        });
                      } : null,
                      color: colorScheme.primary,
                      icon: const Icon(Icons.check))),
              controller: newRegionEditController
            ),
          )
        ],
      ),
    );
  }
}
