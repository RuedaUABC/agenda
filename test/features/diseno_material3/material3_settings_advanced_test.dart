import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:agenda/features/configuracion/presentation/advanced_settings_widget.dart';
import 'package:agenda/features/configuracion/presentation/notificacion_config_widget.dart';
import 'package:agenda/features/configuracion/presentation/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsController> _controller() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = PreferencesHelper();
  await prefs.init();
  final controller = SettingsController(prefs: prefs);
  await controller.loadSettings();
  return controller;
}

void main() {
  testWidgets('NotificacionConfigWidget incluye aviso de eventos', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NotificacionConfigWidget(controller: controller)),
      ),
    );

    expect(find.text('Eventos'), findsOneWidget);
    expect(find.byIcon(Icons.event_outlined), findsOneWidget);
    expect(find.byType(DropdownMenu<int>), findsNWidgets(3));
  });

  testWidgets('AdvancedSettingsWidget muestra preferencias propuestas', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AdvancedSettingsWidget(controller: controller)),
      ),
    );

    expect(find.text('Apariencia'), findsOneWidget);
    expect(find.text('Vista inicial'), findsOneWidget);
    expect(find.text('Densidad visual'), findsOneWidget);
    expect(find.text('Inicio de semana'), findsOneWidget);
    expect(find.text('Confirmaciones'), findsOneWidget);
    expect(find.text('Gestion de datos'), findsOneWidget);
    expect(find.text('Informacion de la app'), findsOneWidget);
    expect(find.byType(SegmentedButton<AppThemePreference>), findsOneWidget);
    expect(find.byType(SwitchListTile), findsWidgets);
  });

  testWidgets('AdvancedSettingsWidget actualiza tema y confirmaciones', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AdvancedSettingsWidget(controller: controller)),
      ),
    );

    await tester.tap(find.text('Oscuro'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(SwitchListTile, 'Confirmar eliminacion'),
    );
    await tester.pumpAndSettle();

    expect(controller.themePreference, AppThemePreference.dark);
    expect(controller.confirmDestructiveActions, isFalse);
  });
}
