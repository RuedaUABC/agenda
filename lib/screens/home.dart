import 'package:agenda/screens/mobile/mobile_body.dart';
import 'package:agenda/screens/desktop/desktop_body.dart';
import 'package:agenda/utils/responsive_layout.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(mobile: MyMobileBody(), desktop: MyDesktopBody()),
    );
  }
}
