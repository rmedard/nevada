import 'package:flutter/material.dart';
import 'package:nevada/ui/constants.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  var _selectedIndex = 0;

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
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: menuElements
                  .map((e) => NavigationRailDestination(icon: e.icon, label: Text(e.label)))
                  .toList(),
              selectedIndex: _selectedIndex),
          menuElements[_selectedIndex].body
        ],
      ),
    );
  }
}
