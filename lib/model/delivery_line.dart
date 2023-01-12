import 'package:hive/hive.dart';
import 'package:nevada/model/product.dart';

part 'delivery_line.g.dart';

@HiveType(typeId: 4)
class DeliveryLine extends HiveObject {

  @HiveField(0)
  String uuid;

  @HiveField(1)
  String deliveryUuid;

  @HiveField(2)
  Product product;

  @HiveField(3)
  int productQuantity;

  @HiveField(4)
  int productUnitPrice;

  DeliveryLine(
      {required this.uuid,
      required this.deliveryUuid,
      required this.product,
      required this.productQuantity,
      required this.productUnitPrice});
}
