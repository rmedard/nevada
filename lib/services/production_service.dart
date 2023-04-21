import 'package:collection/collection.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/services/base_service.dart';

class ProductionService  extends BaseService<StockRefill> {

  List<StockRefill> getAllSorted() {
    return dataBox.values.sorted((a, b) => b.date.compareTo(a.date)).toList();
  }

  @override
  Future<bool> createNew(String uuid, StockRefill t) async {
    loggy.info("Creating entity: ${t.runtimeType.toString()}");
    t.product.totalStock += t.productQuantity;
    return await dataBox.put(uuid, t).then((_) {
      loggy.info('Entity $uuid of type ${t.runtimeType.toString()} created successfully!');
      return true;
    }, onError: (error) {
      loggy.error(error);
      return false;
    });
  }
}