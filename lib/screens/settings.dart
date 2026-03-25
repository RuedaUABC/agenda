import 'package:agenda/screens/mobile/mobile_body.dart';
import 'package:agenda/screens/desktop/desktop_body.dart';
import 'package:agenda/utils/responsive_layout.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(mobile: MyMobileBody(), desktop: MyDesktopBody()),
    );
  }
}
