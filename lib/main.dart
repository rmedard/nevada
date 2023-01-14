import 'dart:io';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/ui/constants.dart';
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

  /** Init Regions **/

  var configBox = await Hive.openBox<dynamic>(configBoxName);
  if (configBox.isEmpty) {
    configBox.put(ConfigKey.regions.name,
        ['regions', 'Matola', 'Zimpeto', 'Nyambane', 'Xai Xai']);
  }

  /** Init Products & Stock **/
  var productsBox = await Hive.openBox<Product>(boxNames[BoxNameKey.products]!);
  if (productsBox.isEmpty) {
    var product1 = Product(
        uuid: const Uuid().v4(),
        name: '24pcs-0.5l',
        description: 'Pack of 6 pieces of 0.5 litre',
        unitBasePrice: 250,
        totalStock: 0);
    var product2 = Product(
        uuid: const Uuid().v4(),
        name: '12pcs-1.5l',
        description: 'Pack of 6 pieces of 1.5 litres',
        unitBasePrice: 250,
        totalStock: 0);
    var product3 = Product(
        uuid: const Uuid().v4(),
        name: '4pcs-6l',
        description: 'Pack of 2 pieces of 5 litres',
        unitBasePrice: 200,
        totalStock: 0);
    var product4 = Product(
        uuid: const Uuid().v4(),
        name: '1pc-20l',
        description: 'Pack of 1 piece of 20 litres',
        unitBasePrice: 900,
        totalStock: 0);
    var product5 = Product(
        uuid: const Uuid().v4(),
        name: '1pc-20l-refill',
        description: 'Refill Pack of 1 piece of 20 litres',
        unitBasePrice: 140,
        totalStock: 0);
    for (var product in [product1, product2, product3, product4, product5]) {
      productsBox.put(product.uuid, product);
    }
  }

  /** Init Customers **/
  var customersBox = await Hive.openBox<Customer>(boxNames[BoxNameKey.customers]!);
  if (customersBox.isEmpty) {
    var phones = [
      '+258 48 337 11 14',
      '+258 48 337 22 14',
      '+258 48 337 33 14',
      '+258 48 337 44 14'
    ];
    var regions = ['Matola', 'Nyambani', 'Xai Xai', 'Zimpeto'];

    var listSize = 50;
    for (int i = 0; i < listSize; i++) {
      var phoneIndex = Random().nextInt(phones.length);
      var regionIndex = Random().nextInt(regions.length);
      var name = StringUtils.generateRandomString(10,
          alphabet: true, special: false, numeric: false);
      var client = Customer(
          uuid: const Uuid().v4(),
          names: name,
          phone: phones[phoneIndex],
          location: regions[regionIndex]);
      customersBox.put(client.uuid, client);
    }
  }

  /** Init Delivery **/
  await Hive.openBox<DeliveryLine>(boxNames[BoxNameKey.deliveryLines]!);
  await Hive.openBox<Delivery>(boxNames[BoxNameKey.deliveries]!);


  runApp(const NevadaApp());
}

class NevadaApp extends StatelessWidget {
  const NevadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const kColorPrimary = Color(0xff4261EC);
    const kColorPrimaryLight = Color(0xff8fb7ee);
    const kColorAccent = Color(0xffe80013);
    const kColorOrange = Colors.deepOrangeAccent;
    const kColorRed = Colors.red;
    const kColorGreen = Color(0xff00e861);
    const kColorLightGray = Color(0xffecf0fa);
    const kColorDark = Color(0xff181818);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nevada',
      theme: ThemeData(
          primarySwatch: MaterialColor(
            kColorPrimary.value, <int, Color>{
              50: kColorPrimary.withOpacity(0.1),
              100: kColorPrimary.withOpacity(0.2),
              200: kColorPrimary.withOpacity(0.3),
              300: kColorPrimary.withOpacity(0.4),
              400: kColorPrimary.withOpacity(0.5),
              500: kColorPrimary.withOpacity(0.6),
              600: kColorPrimary.withOpacity(0.7),
              700: kColorPrimary.withOpacity(0.8),
              800: kColorPrimary.withOpacity(0.9),
              900: kColorPrimary.withOpacity(1),
            },
          ),
          backgroundColor: defaultBackground,
          textTheme: TextTheme(
              headline1: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 32, color: kColorDark),
              headline2: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 26, color: kColorDark),
              headline3: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20, color: kColorDark),
              headline4: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 14, color: kColorDark),
              headline5: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 10, color: kColorDark.withOpacity(0.6)),
              headline6: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 6, color: kColorDark.withOpacity(0.6)),
              bodyText1: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16, color: kColorDark),
              bodyText2: GoogleFonts.nunito(fontWeight: FontWeight.normal, fontSize: 14, color: kColorDark),
              subtitle1: GoogleFonts.nunito(fontWeight: FontWeight.normal, fontSize: 16, color: kColorDark),
              subtitle2: GoogleFonts.nunito(fontWeight: FontWeight.w400, fontSize: 14, color: kColorDark),
              button: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              caption: GoogleFonts.nunito(fontWeight: FontWeight.normal, fontSize: 12, color: kColorDark))),
      home: const ResponsiveLayout(
          mobileScaffold: MobileLayout(),
          tabletScaffold: TabletLayout(),
          desktopScaffold: DesktopLayout()),
    );
  }
}
