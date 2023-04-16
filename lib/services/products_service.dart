import 'package:nevada/model/product.dart';
import 'package:nevada/services/base_service.dart';
import 'package:nevada/utils/num_utils.dart';

class ProductsService extends BaseService<Product> {

  @override
  List<Product> getAll() {
    return dataBox.values.where((product) => product.isActive).toList();
  }

  bool stockHasWarnings() {
    return dataBox.values.any((product) => !product.hasValidStock);
  }

  Future<void> deleteProduct(Product product) {
    product.isActive = false;
    return product.save();
  }

  Set<String> bottleSizes() {
    return getAll()
        .where((product) => product.isStockable)
        .map((product) => NumUtils.stringify(product.unitSize)).toSet();
  }
}