import 'package:flutter/material.dart';
import 'package:nevada/ui/screens/tabs/raw_materials_tab.dart';
import 'package:nevada/ui/screens/tabs/stock_tab.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var tabController = TabController(length: 2, vsync: this);
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        children: [
          TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: 'Stock et Production'),
                Tab(text: 'Matière Première')]),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: TabBarView(
                  controller: tabController,
                  children: const [
                    StockTab(),
                    RawMaterialsTab(),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
