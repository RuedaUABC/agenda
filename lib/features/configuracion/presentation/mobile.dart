import 'package:flutter/material.dart';
import 'advanced_settings_widget.dart';
import 'settings_controller.dart';
import 'notificacion_config_widget.dart';

class MyMobileBody extends StatelessWidget {
  final SettingsController controller;
  const MyMobileBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 24 + bottomInset),
      children: [
        NotificacionConfigWidget(controller: controller),
        const SizedBox(height: 16),
        AdvancedSettingsWidget(controller: controller, scrollable: false),
      ],
    );
  }
}
