import 'package:flutter/material.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/separator.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              MetricCard(
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
              MetricCard(
                body: Column(
                  children: [
                    Text('DEPENSES',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
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
        )
      ],
    );
  }
}
