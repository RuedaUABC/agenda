import 'package:agenda/screens/mobile/mobile_body.dart';
import 'package:agenda/screens/desktop/desktop_body.dart';
import 'package:agenda/utils/responsive_layout.dart';
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
