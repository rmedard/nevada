import 'package:nevada/model/product.dart';
import 'package:nevada/services/base_service.dart';

class ProductsService extends BaseService<Product> {

  bool stockHasWarnings() {
    return dataBox.values.any((product) => !product.hasValidStock);
  }
}