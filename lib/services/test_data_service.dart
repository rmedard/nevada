import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:hive/hive.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/utils/constants.dart';
import 'package:uuid/uuid.dart';

class TestDataService {

  var configBox = Hive.box<dynamic>(configBoxName);
  var productsBox = Hive.box<Product>(boxNames[BoxNameKey.products]!);
  var customersBox = Hive.box<Customer>(boxNames[BoxNameKey.customers]!);
  var stockRefillsBox = Hive.box<StockRefill>(boxNames[BoxNameKey.stockRefills]!);
  var deliveryLinesBox = Hive.box<DeliveryLine>(boxNames[BoxNameKey.deliveryLines]!);
  var deliveriesBox = Hive.box<Delivery>(boxNames[BoxNameKey.deliveries]!);
  var transactionsBox = Hive.box<Transaction>(boxNames[BoxNameKey.transactions]!);

  void removeAllData() {
    transactionsBox.clear();
    deliveriesBox.clear();
    deliveryLinesBox.clear();
    stockRefillsBox.clear();
    productsBox.clear();
    customersBox.clear();
    configBox.clear();
  }

  void initTestData() {

    /** Config Regions **/
    if (configBox.isEmpty) {
      configBox.put(ConfigKey.regions.name, {
        const Uuid().v4(): 'Matola',
        const Uuid().v4(): 'Zimpeto',
        const Uuid().v4(): 'Inhambane',
        const Uuid().v4(): 'Xai Xai'
      });
    }

    /** Config products **/
    if (productsBox.isEmpty) {
      var product1 = Product(
          uuid: const Uuid().v4(),
          name: '24pcs-0.5l',
          description: 'Pack of 6 pieces of 0.5 litre',
          unitBasePrice: 250,
          totalStock: 0,
          isStockable: true,
          isActive: true);
      var product2 = Product(
          uuid: const Uuid().v4(),
          name: '12pcs-1.5l',
          description: 'Pack of 6 pieces of 1.5 litres',
          unitBasePrice: 250,
          totalStock: 0,
          isStockable: true,
          isActive: true);
      var product3 = Product(
          uuid: const Uuid().v4(),
          name: '4pcs-6l',
          description: 'Pack of 2 pieces of 5 litres',
          unitBasePrice: 200,
          totalStock: 0,
          isStockable: true,
          isActive: true);
      var product4 = Product(
          uuid: const Uuid().v4(),
          name: '1pc-20l',
          description: 'Pack of 1 piece of 20 litres',
          unitBasePrice: 900,
          totalStock: 0,
          isStockable: true,
          isActive: true);
      var product5 = Product(
          uuid: const Uuid().v4(),
          name: '1pc-20l-refill',
          description: 'Refill Pack of 1 piece of 20 litres',
          unitBasePrice: 140,
          totalStock: 0,
          isStockable: false,
          isActive: true);
      for (var product in [product1, product2, product3, product4, product5]) {
        productsBox.put(product.uuid, product);
      }
    }

    /** Config Customers **/
    if (customersBox.isEmpty) {
      var phones = [
        '+258 48 337 11 14',
        '+258 48 337 22 14',
        '+258 48 337 33 14',
        '+258 48 337 44 14'
      ];

      var listSize = 20;
      var regions = configBox.get(ConfigKey.regions.name) as Map<dynamic, dynamic>;
      for (int i = 0; i < listSize; i++) {
        var phoneIndex = Random().nextInt(phones.length);
        var regionIndex = Random().nextInt(regions.entries.length);
        var name = StringUtils.generateRandomString(10,
            alphabet: true, special: false, numeric: false);
        var client = Customer(
            uuid: const Uuid().v4(),
            names: name,
            phone: phones[phoneIndex],
            location: regions.entries.elementAt(regionIndex).key, balance: 0);
        customersBox.put(client.uuid, client);
      }
    }
  }
}