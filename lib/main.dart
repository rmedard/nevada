import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loggy/loggy.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/delivery_line.dart';
import 'package:nevada/model/dtos/salary_pay.dart';
import 'package:nevada/model/dtos/yearly_holidays.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/raw_material_movement.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/providers/stock_status_notifier.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/text_scheme.g.dart';
import 'package:nevada/ui/layout/devices/desktop_layout.dart';
import 'package:nevada/ui/layout/devices/mobile_layout.dart';
import 'package:nevada/ui/layout/devices/tablet_layout.dart';
import 'package:nevada/ui/layout/responsive_layout.dart';
import 'package:nevada/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';

import 'color_schemes.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow().then((value) async {
    await windowManager.setTitle('NEVADA Industries');
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setBackgroundColor(const Color(0xff4282E7));
    await windowManager.show();
  });
  if (Platform.isWindows || Platform.isMacOS) {
    WindowManager.instance.setMinimumSize(const Size(570, 800));
  }

  /** Init Loggy **/
  Loggy.initLoggy(
      logPrinter: const PrettyPrinter(showColors: true),
      logOptions:
          const LogOptions(LogLevel.all, stackTraceLevel: LogLevel.off));

  /** Init hive **/

  await Hive.initFlutter('../db');
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(DeliveryLineAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(StockRefillAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionStatusAdapter());
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(ContractTypeAdapter());
  Hive.registerAdapter(JobTitleAdapter());
  Hive.registerAdapter(SalaryPayAdapter());
  Hive.registerAdapter(YearlyHolidaysAdapter());
  Hive.registerAdapter(HolidayAdapter());
  Hive.registerAdapter(RawMaterialMovementAdapter());
  Hive.registerAdapter(MaterialMovementTypeAdapter());

  /** Init Regions **/
  Box configBox = await Hive.openBox<dynamic>(configBoxName);
  bool regionsEmpty = false;
  if (configBox.isEmpty) {
    regionsEmpty = true;
  } else {
    var map = configBox.get(ConfigKey.regions.name, defaultValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>;
    if (map.isEmpty) {
      regionsEmpty = true;
    }
  }
  
  if (regionsEmpty) {
    configBox.put(ConfigKey.regions.name, <String, String>{
      const Uuid().v4().toString(): 'Zimpeto'
    });
  }
  
  /** Init Products & Stock **/
  await Hive.openBox<Product>(boxNames[BoxNameKey.products]!);
  await Hive.openBox<StockRefill>(boxNames[BoxNameKey.stockRefills]!);
  await Hive.openBox<RawMaterialMovement>(boxNames[BoxNameKey.rawMaterials]!);

  /** Init Customers **/
  await Hive.openBox<Customer>(boxNames[BoxNameKey.customers]!);

  /** Init Employees **/
  await Hive.openBox<Employee>(boxNames[BoxNameKey.employees]!);

  /** Init Delivery **/
  await Hive.openBox<Delivery>(boxNames[BoxNameKey.deliveries]!);

  /** Init Transactions **/
  await Hive.openBox<Transaction>(boxNames[BoxNameKey.transactions]!);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) {
      var stockStatusNotifier = StockStatusNotifier();
      stockStatusNotifier.update(ProductsService().stockHasWarnings());
      return stockStatusNotifier;
    })
  ], child: const NevadaApp()));
}

class NevadaApp extends StatelessWidget {
  const NevadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting().then((value) => Intl.defaultLocale = 'fr-FR');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nevada',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: defaultTextTheme,
          navigationRailTheme: NavigationRailThemeData(
              elevation: 0,
              selectedIconTheme: IconThemeData(color: lightColorScheme.primary),
              indicatorColor: lightColorScheme.surface,
              indicatorShape: Border(left: BorderSide(color: lightColorScheme.primary, width: 2)),
              selectedLabelTextStyle: TextStyle(color: lightColorScheme.primary, fontSize: 20),
              unselectedLabelTextStyle: const TextStyle(color: kColorDark, fontSize: 20)
          ),
          dataTableTheme: DataTableThemeData(
              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: lightColorScheme.primary),
              headingRowColor: MaterialStatePropertyAll<Color>(lightColorScheme.primary.withOpacity(0.1)),
              dividerThickness: 1,
              columnSpacing: 3),
          inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none)
      ),
      home: const ResponsiveLayout(
          mobileScaffold: MobileLayout(),
          tabletScaffold: TabletLayout(),
          desktopScaffold: DesktopLayout()),
    );
  }
}
