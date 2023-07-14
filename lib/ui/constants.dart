import 'package:flutter/material.dart';
import 'package:nevada/ui/screens/clients.dart';
import 'package:nevada/ui/screens/configurations.dart';
import 'package:nevada/ui/screens/deliveries.dart';
import 'package:nevada/ui/screens/employees.dart';
import 'package:nevada/ui/screens/home.dart';
import 'package:nevada/ui/screens/stock.dart';
import 'package:nevada/ui/screens/transactions.dart';
import 'package:nevada/ui/utils/menu_item.dart';
import 'package:nevada/ui/utils/nevada_icons.dart';

var defaultAppBar = AppBar(
  backgroundColor: Colors.blue[900],
);

var defaultDrawer = Drawer(
  backgroundColor: Colors.grey[300], elevation: 0,
  child: Column(
    children: [
      const DrawerHeader(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('NEVADA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
          Text('STOCKs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)
        ],
      )),
      ...menuElements.map((e) => ListTile(leading: e.icon, title: Text(e.label))).toList(),
    ],
  ),
);

var menuElements = [
  MenuElement(menuLabel: MenuItemLabel.dashboard, icon: const Icon(Nevada.dashboard), iconFill: const Icon(Nevada.dashboardFill), body: const Home()),
  MenuElement(menuLabel: MenuItemLabel.deliveries, icon: const Icon(Nevada.truck), iconFill: const Icon(Nevada.truckFill), body: const Deliveries()),
  MenuElement(menuLabel: MenuItemLabel.transactions, icon: const Icon(Nevada.coins), iconFill: const Icon(Nevada.coinsFill), body: const Transactions()),
  MenuElement(menuLabel: MenuItemLabel.customers, icon: const Icon(Nevada.users), iconFill: const Icon(Nevada.usersFill), body: const Clients()),
  MenuElement(menuLabel: MenuItemLabel.employees, icon: const Icon(Nevada.workers), iconFill: const Icon(Nevada.workersFill), body: const Employees()),
  MenuElement(menuLabel: MenuItemLabel.stock, icon: const Icon(Nevada.stock), iconFill: const Icon(Nevada.stockFill), body: const Stock()),
  MenuElement(menuLabel: MenuItemLabel.configuration, icon: const Icon(Nevada.settings), iconFill: const Icon(Nevada.settingsFill), body: const Configurations()),
];