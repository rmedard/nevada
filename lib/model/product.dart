import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

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

  @HiveField(6, defaultValue: true)
  bool isActive;

  Product(
      {
        required this.uuid,
        required this.name,
        required this.unitBasePrice,
        required this.description,
        required this.totalStock,
        required this.isStockable,
        required this.isActive
      });

  static Product empty() => Product(uuid: const Uuid().v4(), name: '', unitBasePrice: 0, description: '', totalStock: 0, isStockable: true, isActive: true);
}

extension ProductStock on Product {
  bool get hasValidStock {
    return !isStockable || totalStock >= 0;
  }
}
