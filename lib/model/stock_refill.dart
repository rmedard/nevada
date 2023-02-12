import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nevada/model/product.dart';

part 'stock_refill.g.dart';

@HiveType(typeId: 6)
class StockRefill extends HiveObject {

  @HiveField(0)
  String uuid;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  Product product;

  @HiveField(3)
  int productQuantity;

  StockRefill(
      {required this.uuid,
      required this.date,
      required this.product,
      required this.productQuantity});

  String get dateFormatted {
    return DateFormat('EEEE, dd-MM-yyyy').format(date);
  }
}
