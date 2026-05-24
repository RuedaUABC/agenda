import 'package:flutter/material.dart';
import 'advanced_settings_widget.dart';
import 'settings_controller.dart';
import 'notificacion_config_widget.dart';

class MyDesktopBody extends StatelessWidget {
  final SettingsController controller;
  const MyDesktopBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1040;
        final horizontalPadding = constraints.maxWidth >= 1200 ? 32.0 : 24.0;
        final bottomInset = MediaQuery.paddingOf(context).bottom;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            24,
            horizontalPadding,
            32 + bottomInset,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 392,
                          child: NotificacionConfigWidget(
                            controller: controller,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: AdvancedSettingsWidget(
                            controller: controller,
                            scrollable: false,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        NotificacionConfigWidget(controller: controller),
                        const SizedBox(height: 20),
                        AdvancedSettingsWidget(
                          controller: controller,
                          scrollable: false,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
