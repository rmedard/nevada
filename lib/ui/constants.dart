import 'package:flutter/material.dart';
import 'package:nevada/ui/screens/clients.dart';
import 'package:nevada/ui/screens/configurations.dart';
import 'package:nevada/ui/screens/dashboard.dart';
import 'package:nevada/ui/screens/debts.dart';
import 'package:nevada/ui/screens/deliveries.dart';
import 'package:nevada/ui/screens/stock.dart';
import 'package:nevada/ui/utils/menu_item.dart';

var defaultBackground = Colors.grey[300];

var defaultAppBar = AppBar(
  backgroundColor: Colors.grey[900],
);

var defaultDrawer = Drawer(
  backgroundColor: Colors.grey[300], elevation: 0,
  child: Column(
    children: [
      const DrawerHeader(child: Text('NEVADA STOCK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)),
      ...menuElements.map((e) => ListTile(leading: e.icon, title: Text(e.label))).toList(),
    ],
  ),
);

var menuElements = [
  MenuElement(label: 'DASHBOARD', icon: const Icon(Icons.home_filled), body: const Dashboard()),
  MenuElement(label: 'LIVRAISONS', icon: const Icon(Icons.airport_shuttle), body: const Deliveries()),
  MenuElement(label: 'CREANCES', icon: const Icon(Icons.attach_money), body: const Debts()),
  MenuElement(label: 'CLIENTS', icon: const Icon(Icons.people_alt), body: const Clients()),
  MenuElement(label: 'STOCK', icon: const Icon(Icons.store), body: const Stock()),
  MenuElement(label: 'CONFIGURATION', icon: const Icon(Icons.settings), body: const Configurations()),
];