import 'package:intl/intl.dart';

class NumUtils {

  static String stringify(double value) {
    var regex = RegExp(r'([.]*0)(?!.*\d)');
    return value.toString().replaceAll(regex, '');
  }
}

extension NumberExtras on num {
  String get asMoney {
    return NumberFormat.decimalPattern('en_US').format(this);
  }
}