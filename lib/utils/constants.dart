
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/model/transaction.dart';

enum BoxNameKey {
  customers, deliveries, products, stockRefills, transactions, employees
}

var boxNames = {
  BoxNameKey.customers: (Customer).toString(),
  BoxNameKey.deliveries: (Delivery).toString(),
  BoxNameKey.products: (Product).toString(),
  BoxNameKey.stockRefills: (StockRefill).toString(),
  BoxNameKey.transactions: (Transaction).toString(),
  BoxNameKey.employees: (Employee).toString(),
};

const configBoxName = 'config';

enum ConfigKey {
  regions, languages
}