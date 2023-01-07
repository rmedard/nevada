import 'dart:io';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/ui/layout/devices/desktop_layout.dart';
import 'package:nevada/ui/layout/devices/mobile_layout.dart';
import 'package:nevada/ui/layout/devices/tablet_layout.dart';
import 'package:nevada/ui/layout/responsive_layout.dart';
import 'package:nevada/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';

import 'model/customer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS) {
    WindowManager.instance.setMinimumSize(const Size(370, 800));
  }

  /** Init hive **/
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(DeliveryLineAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(StockRefillAdapter());
  Hive.registerAdapter(TransactionAdapter());

  /** Init Products & Stock **/
  var productsBox = await Hive.openBox<Product>(boxNames[BoxNameKey.products]!);
  if (productsBox.isEmpty) {
    var product1 = Product(uuid: const Uuid().v4(), name: '24pcs-0.5l', description: 'Pack of 6 pieces of 0.5 litre', unitBasePrice: 250, totalStock: 0);
    var product2 = Product(uuid: const Uuid().v4(), name: '12pcs-1.5l', description: 'Pack of 6 pieces of 1.5 litres', unitBasePrice: 250, totalStock: 0);
    var product3 = Product(uuid: const Uuid().v4(), name: '4pcs-6l', description: 'Pack of 2 pieces of 5 litres', unitBasePrice: 200, totalStock: 0);
    var product4 = Product(uuid: const Uuid().v4(), name: '1pc-20l', description: 'Pack of 1 piece of 20 litres', unitBasePrice: 900, totalStock: 0);
    var product5 = Product(uuid: const Uuid().v4(), name: '1pc-20l-refill', description: 'Refill Pack of 1 piece of 20 litres', unitBasePrice: 140, totalStock: 0);
    for (var product in [product1, product2, product3, product4, product5]) {
      productsBox.put(product.uuid, product);
    }
  }

  /** Init Customers **/
  var customersBox = await Hive.openBox<Customer>(boxNames[BoxNameKey.customers]!);
  if (customersBox.isEmpty) {
    var phones = ['+258 48 337 00 14', '+258 48 337 00 14', '+258 48 337 00 14', '+258 48 337 00 14'];
    var regions = ['Matola', 'Nyambani', 'Xai Xai', 'Zimpeto'];

    var listSize = 50;
    for (int i = 0; i < listSize; i++) {
      var phoneIndex = Random().nextInt(phones.length);
      var regionIndex = Random().nextInt(regions.length);
      var name = StringUtils.generateRandomString(10, alphabet: true, special: false, numeric: false);
      var client = Customer(uuid: const Uuid().v4(), names: name, phone: phones[phoneIndex], location: regions[regionIndex]);
      customersBox.put(client.uuid, client);
    }
  }
  
  runApp(const NevadaApp());
}

class NevadaApp extends StatelessWidget {
  const NevadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nevada',
      home: ResponsiveLayout(
          mobileScaffold: MobileLayout(),
          tabletScaffold: TabletLayout(),
          desktopScaffold: DesktopLayout()),
    );
  }
}
