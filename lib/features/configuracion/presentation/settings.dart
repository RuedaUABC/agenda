import 'package:agenda/features/configuracion/presentation/mobile.dart';
import 'package:agenda/features/configuracion/presentation/desktop.dart';
import 'package:agenda/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';

import '../preferences_helper.dart';
import 'settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final prefs = PreferencesHelper();
    await prefs.init();
    
    controller = SettingsController(prefs: prefs);
    await controller.loadSettings();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Configuración")),
      body: ResponsiveLayout(
        mobile: MyMobileBody(controller: controller), 
        desktop: MyDesktopBody(controller: controller),
      ),
    );
  }
}
