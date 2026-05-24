import 'package:flutter/material.dart';
import 'advanced_settings_widget.dart';
import 'settings_controller.dart';
import 'notificacion_config_widget.dart';

class MyMobileBody extends StatelessWidget {
  final SettingsController controller;
  const MyMobileBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificacionConfigWidget(controller: controller),
          const SizedBox(height: 32),
          AdvancedSettingsWidget(controller: controller),
        ],
      ),
    );
  }
}
