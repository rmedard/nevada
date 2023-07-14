import 'package:flutter/material.dart';
import 'package:nevada/services/transactions_service.dart';
import 'package:nevada/ui/components/metric_card.dart';
import 'package:nevada/ui/components/revenues_chart.dart';
import 'package:nevada/ui/components/separator.dart';
import 'package:nevada/utils/date_tools.dart';
import 'package:nevada/utils/num_utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ValueNotifier<DateTimeRange> _transactionsDateRangeNotifier = ValueNotifier(DateTimeRange(start: DateTools.beginningOfWeek(DateTime.now()), end: DateTools.endOfWeek(DateTime.now())));

  @override
  void dispose() {
    _transactionsDateRangeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: _transactionsDateRangeNotifier,
              builder: (context, value, _) {
                var stats = TransactionsService().getTransactionStats(value);
                double fullIncome = stats[TransactionStatType.cashIncome]! + stats[TransactionStatType.debtIncome]!;
                double debtIncome = stats[TransactionStatType.debtIncome]!;
                double cashIncome = stats[TransactionStatType.cashIncome]!;
                double expenses = stats[TransactionStatType.expense]!;
                return Row(
                  children: [
                    MetricCard(
                      horizontalPadding: 40,
                      verticalPadding: 20,
                      body: Column(
                        children: [
                          Column(children: [
                            const Text(
                              'ENTREES',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                '+${fullIncome.asMoney} MT',
                                style: const TextStyle(
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
                                  const Text('CREANCES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text('+${debtIncome.asMoney} MT',
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                ],
                              ),
                              const Separator(direction: SeparatorDirection.vertical),
                              Column(
                                children: [
                                  const Text('CASH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text('+${cashIncome.asMoney} MT',
                                        style: const TextStyle(
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
                        children: [
                          const Text('DEPENSES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          Center(
                            child: Text('-${expenses.asMoney} MT',
                              style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
          const SizedBox(height: 20),
          Expanded(child: RevenuesChart(transactionsDateRangeNotifier: _transactionsDateRangeNotifier))
        ],
      ),
    );
  }

}
