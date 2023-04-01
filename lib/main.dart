import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loggy/loggy.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery.dart';
import 'package:nevada/model/dtos/delivery_line.dart';
import 'package:nevada/model/dtos/salary_pay.dart';
import 'package:nevada/model/dtos/yearly_holidays.dart';
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
    WindowManager.instance.setMinimumSize(const Size(370, 800));
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
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionStatusAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(SalaryPayAdapter());
  Hive.registerAdapter(YearlyHolidaysAdapter());

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
          dialogBackgroundColor: Colors.white,
          hoverColor: Colors.transparent,
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white, side: BorderSide(color: kColorPrimary.withOpacity(0.2))
            )
          ),
          dialogTheme: DialogTheme(
              shadowColor: kColorPrimary.withOpacity(0.1)),
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
                fontWeight: FontWeight.bold, fontSize: 14, color: kColorDark),
            labelMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.bold, fontSize: 12, color: kColorDark),
            labelSmall: GoogleFonts.nunito(
                fontWeight: FontWeight.bold, fontSize: 11, color: kColorDark),
            bodyLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 16, color: kColorDark),
            bodyMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 14, color: kColorDark),
            bodySmall: GoogleFonts.nunito(
                fontWeight: FontWeight.normal, fontSize: 12, color: kColorDark),
          ),
          colorScheme: const ColorScheme.light(
            primary: kColorPrimary,
            secondary: kColorInputBackgroundColor,
            error: Colors.redAccent,
            background: kColorDefaultBackground,
            surface: kColorPrimary,
            onSecondary: Colors.white,
          ),
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
          dataTableTheme: DataTableThemeData(
              headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: kColorPrimary),
              headingRowColor: MaterialStatePropertyAll<Color>(kColorPrimary.withOpacity(0.1)),
              dividerThickness: 1,
              columnSpacing: 3)),
      home: const ResponsiveLayout(
          mobileScaffold: MobileLayout(),
          tabletScaffold: TabletLayout(),
          desktopScaffold: DesktopLayout()),
    );
  }
}
