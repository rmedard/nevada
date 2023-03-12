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
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: NavigationRail(
                extended: true,
                indicatorColor: colorScheme.primary,
                leading: DrawerHeader(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('NEVADA',
                        style: textTheme.displayMedium
                            ?.copyWith(color: colorScheme.primary)),
                    Text('INDUSTRY', style: textTheme.titleLarge)
                  ],
                )),
                onDestinationSelected: (index) =>
                    setState(() => _selectedIndex = index),
                destinations: menuElements
                    .map((e) => NavigationRailDestination(
                        icon: e.icon,
                        selectedIcon: e.iconFill,
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.label),
                            e.hasWarnings
                                ? const Icon(Icons.warning_rounded,
                                    color: Colors.deepOrange)
                                : const SizedBox.shrink()
                          ],
                        )))
                    .toList(),
                useIndicator: true,
                selectedIndex: _selectedIndex),
          ),
          Expanded(child: menuElements[_selectedIndex].body)
        ],
      ),
    );
  }
}
