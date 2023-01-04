import 'package:flutter/material.dart';
import 'package:nevada/ui/layout/devices/desktop_layout.dart';
import 'package:nevada/ui/layout/devices/mobile_layout.dart';
import 'package:nevada/ui/layout/devices/tablet_layout.dart';
import 'package:nevada/ui/layout/responsive_layout.dart';

void main() {
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
