import 'package:flutter/material.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/screens/clients.dart';
import 'package:nevada/ui/screens/configurations.dart';
import 'package:nevada/ui/screens/transactions.dart';
import 'package:nevada/ui/screens/deliveries.dart';
import 'package:nevada/ui/screens/home.dart';
import 'package:nevada/ui/screens/stock.dart';
import 'package:nevada/ui/utils/menu_item.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

var defaultAppBar = AppBar(
  backgroundColor: Colors.blue[900],
);

var defaultDrawer = Drawer(
  backgroundColor: Colors.grey[300], elevation: 0,
  child: Column(
    children: [
      DrawerHeader(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('NEVADA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
          Text('STOCKs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)
        ],
      )),
      ...menuElements.map((e) => ListTile(leading: e.icon, title: Text(e.label), trailing: e.hasWarnings ? const Icon(Icons.warning_rounded, color: Colors.deepOrange) : const SizedBox.shrink())).toList(),
    ],
  ),
);

var menuElements = [
  MenuElement(label: 'DASHBOARD', icon: const Icon(Nevada.home), iconFill: const Icon(Nevada.home_fill, color: Colors.white), body: const Home(), hasWarnings: false),
  MenuElement(label: 'LIVRAISONS', icon: const Icon(Nevada.truck), iconFill: const Icon(Nevada.truck_fill, color: Colors.white), body: const Deliveries(), hasWarnings: false),
  MenuElement(label: 'TRANSACTIONS', icon: const Icon(Nevada.coins), iconFill: const Icon(Nevada.coins_fill, color: Colors.white), body: const Transactions(), hasWarnings: false),
  MenuElement(label: 'CLIENTS', icon: const Icon(Nevada.users), iconFill: const Icon(Nevada.users_fill, color: Colors.white), body: const Clients(), hasWarnings: false),
  MenuElement(label: 'STOCK', icon: const Icon(Nevada.stock), iconFill: const Icon(Nevada.stock_fill, color: Colors.white), body: const Stock(), hasWarnings: ProductsService().stockHasWarnings()),
  MenuElement(label: 'CONFIGURATION', icon: const Icon(Nevada.settings), iconFill: const Icon(Nevada.settings_fill, color: Colors.white), body: const Configurations(), hasWarnings: false),
];