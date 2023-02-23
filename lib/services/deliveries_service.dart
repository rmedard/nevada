import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/customer_search_dto.dart';
import 'package:nevada/services/base_service.dart';

class DeliveriesService extends BaseService<Delivery> {

  bool isValidDelivery(Delivery? delivery) {
    return delivery != null && delivery.lines.isNotEmpty && delivery.lines.none((line) => line.productQuantity < 1);
  }

  List<Delivery> find({required CustomerSearchDto customerSearchDto}) {
    var location = customerSearchDto.region == 'all' ? '' : customerSearchDto.region;
    return dataBox.values
        .where((delivery) => delivery.customer.names.toLowerCase().contains(customerSearchDto.name.toLowerCase()))
        .where((delivery) => StringUtils.isNotNullOrEmpty(location) ? delivery.customer.location == location : true)
        .toList();
  }
}