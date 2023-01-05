import 'package:flutter/material.dart';
import 'package:nevada/ui/constants.dart';
import 'package:nevada/ui/screens/clients.dart';
import 'package:nevada/ui/screens/configurations.dart';
import 'package:nevada/ui/screens/credits.dart';
import 'package:nevada/ui/screens/dashboard.dart';
import 'package:nevada/ui/screens/deliveries.dart';
import 'package:nevada/ui/screens/stock.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  var _selectedIndex = 0;

  final _pages = const {
    0: Dashboard(),
    1: Clients(),
    2: Deliveries(),
    3: Credits(),
    4: Stock(),
    5: Configurations(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackground,
      appBar: defaultAppBar,
      body: Row(
        children: [
          NavigationRail(
              extended: true,
              leading: const DrawerHeader(child: Text('NEVADA STOCK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)),
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
            NavigationRailDestination(icon: Icon(Icons.home_filled), label: Text('DASHBOARD')),
            NavigationRailDestination(icon: Icon(Icons.people_alt), label: Text('CLIENTS')),
            NavigationRailDestination(icon: Icon(Icons.airport_shuttle), label: Text('LIVRAISONS')),
            NavigationRailDestination(icon: Icon(Icons.attach_money), label: Text('CREANCES')),
            NavigationRailDestination(icon: Icon(Icons.store), label: Text('STOCK')),
            NavigationRailDestination(icon: Icon(Icons.settings), label: Text('CONFIGURATION')),
          ], selectedIndex: _selectedIndex),
          _pages[_selectedIndex]!
        ],
      ),
    );
  }
}
