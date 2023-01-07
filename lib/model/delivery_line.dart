import 'package:hive/hive.dart';

part 'delivery_line.g.dart';

@HiveType(typeId: 4)
class DeliveryLine extends HiveObject {

  @HiveField(0)
  String uuid;

  @HiveField(1)
  String deliveryUuid;

  @HiveField(2)
  String productUuid;

  @HiveField(3)
  int productQuantity;

  @HiveField(4)
  int productUnitPrice;

  DeliveryLine(
      {required this.uuid,
      required this.deliveryUuid,
      required this.productUuid,
      required this.productQuantity,
      required this.productUnitPrice});
}
