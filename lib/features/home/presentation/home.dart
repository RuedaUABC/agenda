import 'package:agenda/features/home/presentation/desktop.dart';
import 'package:agenda/features/home/presentation/mobile.dart';
import 'package:agenda/core/utils/responsive_layout.dart';
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
      body: ResponsiveLayout(mobile: MyMobileHome(), desktop: MyDesktopHome()),
    );
  }
}
