import 'package:nevada/model/dtos/customer_search_dto.dart';
import 'package:nevada/model/product.dart';

class DeliverySearchDto extends CustomerSearchDto {
  DateTime? start = DateTime.now().subtract(const Duration(days: 30));
  DateTime? end = DateTime.now();
  Product? product;
}