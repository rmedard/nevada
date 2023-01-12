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
      backgroundColor: const Color(0xFFF1FAFE),
      body: Row(
        children: [
          NavigationRail(
              extended: true,
              leading: DrawerHeader(child: Text('NEVADA STOCK', style: Theme.of(context).textTheme.headline1)),
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: menuElements
                  .map((e) => NavigationRailDestination(icon: e.icon, selectedIcon: e.iconFill, label: Text(e.label)))
                  .toList(),
              useIndicator: true,
              selectedIndex: _selectedIndex),
          menuElements[_selectedIndex].body
        ],
      ),
    );
  }
}
