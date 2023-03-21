import 'package:flutter/widgets.dart';

class StockStatusNotifier with ChangeNotifier {
  bool isValidState = true;

  void update(bool isValid) {
    if (isValid != isValidState) {
      isValidState = isValid;
      notifyListeners();
    }
  }
}