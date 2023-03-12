import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class Product extends HiveObject {

  @HiveField(0)
  String uuid;

  @HiveField(1)
  String name;

  @HiveField(2)
  int unitBasePrice;

  @HiveField(3)
  String description;

  @HiveField(4, defaultValue: 0)
  int totalStock;

  @HiveField(5, defaultValue: true)
  bool isStockable;

  Product(
      {required this.uuid,
      required this.name,
      required this.unitBasePrice,
      required this.description, required this.totalStock, required this.isStockable});
}

extension ProductStock on Product {
  bool get hasValidStock {
    return !isStockable || totalStock >= 0;
  }
}
