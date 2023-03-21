import 'package:flutter/material.dart';

class MenuElement {
  MenuItemLabel menuLabel;
  Icon icon;
  Icon iconFill;
  Widget body;

  MenuElement({required this.menuLabel, required this.icon, required this.iconFill,  required this.body});
}

extension MenuLabel on MenuElement {
  String get label {
    switch (menuLabel) {
      case MenuItemLabel.dashboard:
        return 'Dashboard';
      case MenuItemLabel.deliveries:
        return 'Livraisons';
      case MenuItemLabel.transactions:
        return 'Transactions';
      case MenuItemLabel.customers:
        return 'Clients';
      case MenuItemLabel.stock:
        return 'Stock';
      case MenuItemLabel.configuration:
        return 'Configuration';
    }
  }
}

enum MenuItemLabel {
  dashboard, deliveries, transactions, customers, stock, configuration;
}