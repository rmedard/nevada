import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loggy/loggy.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/model/employee.dart';
import 'package:nevada/model/product.dart';
import 'package:nevada/model/stock_refill.dart';
import 'package:nevada/model/transaction.dart';
import 'package:nevada/providers/stock_status_notifier.dart';
import 'package:nevada/services/products_service.dart';
import 'package:nevada/ui/layout/devices/desktop_layout.dart';
import 'package:nevada/ui/layout/devices/mobile_layout.dart';
import 'package:nevada/ui/layout/devices/tablet_layout.dart';
import 'package:nevada/ui/layout/responsive_layout.dart';
import 'package:nevada/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'model/customer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS) {
    WindowManager.instance.setMinimumSize(const Size(370, 800));
  }

  /** Init Loggy **/
  Loggy.initLoggy(
      logPrinter: const PrettyPrinter(showColors: true),
      logOptions:
          const LogOptions(LogLevel.all, stackTraceLevel: LogLevel.off));

  /** Init hive **/
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(DeliveryLineAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(StockRefillAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionStatusAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(EmployeeAdapter());

  /** Init Regions **/
  await Hive.openBox<dynamic>(configBoxName);

  /** Init Products & Stock **/
  await Hive.openBox<Product>(boxNames[BoxNameKey.products]!);
  await Hive.openBox<StockRefill>(boxNames[BoxNameKey.stockRefills]!);

  /** Init Customers **/
  await Hive.openBox<Customer>(boxNames[BoxNameKey.customers]!);

  /** Init Employees **/
  await Hive.openBox<Employee>(boxNames[BoxNameKey.employees]!);

  /** Init Delivery **/
  await Hive.openBox<DeliveryLine>(boxNames[BoxNameKey.deliveryLines]!);
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
    const kColorPrimary = Color(0xff4282E7);
    const kColorDark = Color(0xff181818);
    const kColorDefaultBackground = Color(0xffF9FAFE);
    const kColorInputBackgroundColor = Color(0xffF7FBFE);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nevada',
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          dialogTheme: const DialogTheme(backgroundColor: Colors.white),
          inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
          textTheme: TextTheme(
            displayLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 57, color: kColorDark),
            displayMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 45, color: kColorDark),
            displaySmall: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 36, color: kColorDark),
            headlineLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 32, color: kColorDark),
            headlineMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 28, color: kColorDark),
            headlineSmall: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 24, color: kColorDark),
            titleLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 22, color: kColorDark),
            titleMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 16, color: kColorDark),
            titleSmall: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 14, color: kColorDark),
            labelLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 14, color: kColorDark),
            labelMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 12, color: kColorDark),
            labelSmall: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 11, color: kColorDark),
            bodyLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 16, color: kColorDark),
            bodyMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 14, color: kColorDark),
            bodySmall: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 12, color: kColorDark),
          ),
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: MaterialColor(kColorPrimary.value, <int, Color>{
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
              }),
              accentColor: kColorInputBackgroundColor,
              errorColor: Colors.redAccent,
              backgroundColor: kColorDefaultBackground),
          switchTheme: SwitchThemeData(
            splashRadius: 20,
            thumbColor: const MaterialStatePropertyAll<Color>(kColorPrimary),
            trackColor: MaterialStatePropertyAll<Color>(kColorPrimary.withOpacity(0.2)),
          ),
          navigationRailTheme: const NavigationRailThemeData(
              backgroundColor: Colors.white,
              elevation: 0,
              selectedIconTheme: IconThemeData(color: kColorPrimary),
              indicatorColor: Colors.white,
              indicatorShape: Border(left: BorderSide(color: kColorPrimary, width: 2)),
              selectedLabelTextStyle: TextStyle(color: kColorPrimary, fontSize: 20),
              unselectedLabelTextStyle: TextStyle(color: kColorDark, fontSize: 20)
          ),
          dataTableTheme: const DataTableThemeData(
              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: kColorPrimary),
              columnSpacing: 3)),
      home: const ResponsiveLayout(
          mobileScaffold: MobileLayout(),
          tabletScaffold: TabletLayout(),
          desktopScaffold: DesktopLayout()),
    );
  }
}
