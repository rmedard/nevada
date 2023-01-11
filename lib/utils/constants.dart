
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/model/transaction.dart';

enum BoxNameKey {
  customers, deliveries, deliveryLines, products, stockRefills, transactions
}

var boxNames = {
  BoxNameKey.customers: (Customer).toString(),
  BoxNameKey.deliveries: (Delivery).toString(),
  BoxNameKey.deliveryLines: (DeliveryLine).toString(),
  BoxNameKey.products: (Product).toString(),
  BoxNameKey.stockRefills: (StockRefill).toString(),
  BoxNameKey.transactions: (Transaction).toString(),
};

const configBoxName = 'config';

enum ConfigKey {
  regions, languages
}