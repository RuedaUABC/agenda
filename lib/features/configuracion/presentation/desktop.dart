import 'package:flutter/material.dart';
import 'advanced_settings_widget.dart';
import 'settings_controller.dart';
import 'notificacion_config_widget.dart';

class MyDesktopBody extends StatelessWidget {
  final SettingsController controller;
  const MyDesktopBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NotificacionConfigWidget(controller: controller),
                      const SizedBox(height: 32),
                      AdvancedSettingsWidget(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(flex: 3, child: Container()),
      ],
    );
  }
}
