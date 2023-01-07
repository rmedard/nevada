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

  Product(
      {required this.uuid,
      required this.name,
      required this.unitBasePrice,
      required this.description, required this.totalStock});
}
