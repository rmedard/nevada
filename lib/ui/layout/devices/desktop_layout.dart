import 'package:flutter/material.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/constants.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackground,
      appBar: defaultAppBar,
      body: Row(
        children: [
          defaultDrawer,
          Expanded(
            flex: 2,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 4,
                  child: SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                        itemCount: 4,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                        itemBuilder: (context, index) {
                          return const MetricCard();
                        }),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(tileColor: Colors.red),
                  );
                }),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.pink))
              ],
            ),
          )
        ],
      ),
    );
  }
}
