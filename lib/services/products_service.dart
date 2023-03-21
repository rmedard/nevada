import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/delivery_search_dto.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/services/deliveries_service.dart';

class ProductsService extends BaseService<Product> {

  bool stockHasWarnings() {
    return dataBox.values.any((product) => !product.hasValidStock);
  }

  Future<bool> deleteProduct(Product product) {
    var deliverySearchDto2 = DeliverySearchDto();
    deliverySearchDto2.product = product;
    List<Delivery> deliveries = DeliveriesService().search(deliverySearchDto: deliverySearchDto2);
    for (var delivery in deliveries) {
      DeliveriesService().deleteDelivery(delivery);
    }
    return delete(product.uuid);
  }
}