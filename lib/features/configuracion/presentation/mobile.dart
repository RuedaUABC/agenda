import 'package:flutter/material.dart';
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
        children: [
          NotificacionConfigWidget(controller: controller),
        ],
      ),
    );
  }
}
