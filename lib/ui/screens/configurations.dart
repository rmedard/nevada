import 'package:flutter/material.dart';
import 'package:nevada/services/test_data_service.dart';
import 'package:nevada/ui/components/decor/basic_container.dart';
import 'package:nevada/ui/screens/config/holidays_config_block.dart';
import 'package:nevada/ui/screens/config/regions_config_block.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';

class Configurations extends StatefulWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  State<Configurations> createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  @override
  Widget build(BuildContext context) {
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Configurations',
        actions: const SizedBox.shrink(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BasicContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: RegionsConfigBlock(),
                  ),
                  SizedBox(width: 20),
                  HolidaysConfigBlock()
                ],
              ),
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
        ));
  }
}
