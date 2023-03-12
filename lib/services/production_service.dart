import 'package:collection/collection.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/services/base_service.dart';

class ProductionService  extends BaseService<StockRefill> {

  List<StockRefill> getAllSorted() {
    return dataBox.values.sorted((a, b) => b.date.compareTo(a.date)).toList();
  }
}