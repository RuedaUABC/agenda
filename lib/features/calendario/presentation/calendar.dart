import 'package:agenda/features/calendario/presentation/mobile.dart';
import 'package:agenda/features/calendario/presentation/desktop.dart';
import 'package:agenda/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(mobile: MyMobileBody(), desktop: MyDesktopBody()),
    );
  }
}
