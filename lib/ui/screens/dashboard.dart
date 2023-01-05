import 'package:flutter/material.dart';
import 'package:nevada/ui/components/metric_card.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Row(children: [
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
      ],),
    );
  }
}
