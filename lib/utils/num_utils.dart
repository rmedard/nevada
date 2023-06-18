import 'package:intl/intl.dart';

class NumUtils {

  static String stringify(double value) {
    var regex = RegExp(r'([.]*0)(?!.*\d)');
    return value.toString().replaceAll(regex, '');
  }

  static NumberFormat currencyFormat() {
    return NumberFormat.decimalPattern('en_US');
  }
}