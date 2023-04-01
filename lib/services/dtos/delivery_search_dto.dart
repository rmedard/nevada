import 'package:nevada/model/product.dart';
import 'package:nevada/services/dtos/customer_search_dto.dart';

class DeliverySearchDto extends CustomerSearchDto {
  DateTime? start = DateTime.now().subtract(const Duration(days: 30));
  DateTime? end = DateTime.now();
  Product? product;
}