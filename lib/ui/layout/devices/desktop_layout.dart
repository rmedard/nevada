import 'package:flutter/material.dart';
import 'package:nevada/providers/stock_status_notifier.dart';
import 'package:nevada/ui/constants.dart';
import 'package:nevada/ui/utils/menu_item.dart';
import 'package:provider/provider.dart';

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
          NavigationRail(
              extended: true,
              leading: DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('NEVADA', style: textTheme.displayMedium?.copyWith(color: colorScheme.primary)),
                  Text('Industries', style: textTheme.titleLarge)
                ],
              )),
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: menuElements
                  .map((item) => NavigationRailDestination(
                      icon: item.icon,
                      selectedIcon: item.iconFill,
                  padding: const EdgeInsets.only(bottom: 20),
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.label),
                          Consumer<StockStatusNotifier>(builder: (context, notifier, _) => item.menuLabel == MenuItemLabel.stock && notifier.isValidState
                              ? const Icon(Icons.warning_rounded, color: Colors.deepOrange)
                              : const SizedBox.shrink())
                        ],
                      )))
                  .toList(),
              selectedIndex: _selectedIndex),
          Expanded(child: menuElements[_selectedIndex].body)
        ],
      ),
    );
  }
}
