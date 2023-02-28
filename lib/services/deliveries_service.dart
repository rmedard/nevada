import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/delivery_search_dto.dart';
import 'package:nevada/services/base_service.dart';

class DeliveriesService extends BaseService<Delivery> {

  bool isValidDelivery(Delivery? delivery) {
    return delivery != null && delivery.lines.isNotEmpty && delivery.lines.none((line) => line.productQuantity < 1);
  }

  List<Delivery> find({required DeliverySearchDto deliverySearchDto}) {
    var location = deliverySearchDto.region == 'all' ? '' : deliverySearchDto.region;
    return dataBox.values
        .where((delivery) => delivery.customer.names.toLowerCase().contains(deliverySearchDto.name.toLowerCase()))
        .where((delivery) => StringUtils.isNotNullOrEmpty(location) ? delivery.customer.location == location : true)
        .where((delivery) => delivery.date.isAfter(deliverySearchDto.start) && delivery.date.isBefore(deliverySearchDto.end))
        .toList();
  }
}