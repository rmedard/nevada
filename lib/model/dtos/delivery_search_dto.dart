import 'package:nevada/model/dtos/customer_search_dto.dart';

class DeliverySearchDto extends CustomerSearchDto {
  DateTime start = DateTime.now().subtract(const Duration(days: 30));
  DateTime end = DateTime.now();
}