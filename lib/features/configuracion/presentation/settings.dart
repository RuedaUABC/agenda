import 'package:agenda/core/utils/responsive_layout.dart';
import 'package:agenda/features/configuracion/presentation/desktop.dart';
import 'package:agenda/features/configuracion/presentation/mobile.dart';
import 'package:flutter/material.dart';

import '../preferences_helper.dart';
import 'settings_controller.dart';

class SettingsPage extends StatefulWidget {
  final SettingsController? controller;

  const SettingsPage({super.key, this.controller});

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
    if (widget.controller != null) {
      controller = widget.controller!;
      setState(() => isLoading = false);
      return;
    }

    final prefs = PreferencesHelper();
    await prefs.init();

    controller = SettingsController(prefs: prefs);
    await controller.loadSettings();

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configuracion')),
      body: ResponsiveLayout(
        mobile: MyMobileBody(controller: controller),
        desktop: MyDesktopBody(controller: controller),
      ),
    );
  }
}
