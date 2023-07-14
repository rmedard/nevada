import 'package:flutter/material.dart';

class TransactionsDateRangeNotifier extends ValueNotifier<DateTimeRange> {
  TransactionsDateRangeNotifier(DateTimeRange value) : super(value);
  
  void changeRange(DateTimeRange newRange) {
    value = newRange;
    notifyListeners();
  }
  
}