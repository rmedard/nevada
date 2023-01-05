import 'package:flutter/material.dart';

var defaultBackground = Colors.grey[300];

var defaultAppBar = AppBar(
  backgroundColor: Colors.grey[900],
);

var defaultDrawer = Drawer(
  backgroundColor: Colors.grey[300], elevation: 0,
  child: Column(
    children: const [
      DrawerHeader(child: Text('NEVADA STOCK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)),
      ListTile(leading: Icon(Icons.home_filled), title: Text('DASHBOARD'),),
      ListTile(leading: Icon(Icons.people_alt), title: Text('CLIENTS'),),
      ListTile(leading: Icon(Icons.airport_shuttle), title: Text('LIVRAISONS'),),
      ListTile(leading: Icon(Icons.attach_money), title: Text('CREANCES'),),
      ListTile(leading: Icon(Icons.store), title: Text('STOCK'),),
      ListTile(leading: Icon(Icons.settings), title: Text('CONFIGURATION'),)
    ],
  ),
);