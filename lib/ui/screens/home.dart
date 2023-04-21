import 'package:flutter/material.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/revenues_chart.dart';
import 'package:nevada/ui/components/separator.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
          children: [
            MetricCard(
              horizontalPadding: 40,
              verticalPadding: 20,
              body: Column(
                children: [
                  Column(children: [
                    Text(
                      'ENTREES',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        '+350.000 MT',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ]),
                  const Separator(direction: SeparatorDirection.horizontal),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('CREANCES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('+100.000 MT',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                        ],
                      ),
                      const Separator(direction: SeparatorDirection.vertical),
                      Column(
                        children: [
                          Text('CASH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('+250.000 MT',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 20),
            MetricCard(
              horizontalPadding: 40,
              verticalPadding: 20,
              body: Column(
                children: const [
                  Text('DEPENSES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Center(
                    child: Text(
                      '-125.500 MT',
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          ],
          ),
          const SizedBox(height: 20),
          const Expanded(child: RevenuesChart())
        ],
      ),
    );
  }
}
