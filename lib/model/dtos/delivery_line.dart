import 'package:hive/hive.dart';
import 'package:nevada/model/product.dart';

part 'delivery_line.g.dart';

@HiveType(typeId: 33)
class DeliveryLine {

  @HiveField(0)
  Product product;

  @HiveField(1)
  int productQuantity;

  @HiveField(2)
  int productUnitPrice;

  DeliveryLine({required this.product, required this.productQuantity, required this.productUnitPrice});
}

extension DeliveryLineExtension on DeliveryLine {
  int get total {
    return productQuantity * productUnitPrice;
  }
}
