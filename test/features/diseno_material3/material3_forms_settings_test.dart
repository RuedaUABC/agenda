import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/presentation/widgets/evento_form.dart';
import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:agenda/features/configuracion/presentation/notificacion_config_widget.dart';
import 'package:agenda/features/configuracion/presentation/settings_controller.dart';
import 'package:agenda/features/horario/presentation/widgets/clase_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsController> _settingsController() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = PreferencesHelper();
  await prefs.init();
  final controller = SettingsController(prefs: prefs);
  await controller.loadSettings();
  return controller;
}

void main() {
  testWidgets('EventoForm usa cierre visible y color picker accesible', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventoForm(
            initialDate: DateTime(2026, 5, 13),
            eventos: const [],
          ),
        ),
      ),
    );

    expect(find.byTooltip('Cerrar formulario'), findsOneWidget);
    expect(find.text('Fecha y hora'), findsOneWidget);

    final firstColor = find.byKey(const Key('agenda-color-option-0'));
    expect(firstColor, findsOneWidget);
    expect(tester.getSize(firstColor), const Size(48, 48));
  });

  testWidgets('ClaseForm usa cierre visible y color picker accesible', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ClaseForm(initialDate: DateTime(2026, 5, 13))),
      ),
    );

    expect(find.byTooltip('Cerrar formulario'), findsOneWidget);
    expect(find.text('Fecha y hora'), findsOneWidget);
    expect(find.text('Se repetira cada semana este dia'), findsOneWidget);

    final firstColor = find.byKey(const Key('agenda-color-option-0'));
    expect(firstColor, findsOneWidget);
    expect(tester.getSize(firstColor), const Size(48, 48));
  });

  testWidgets('NotificacionConfigWidget usa secciones y DropdownMenu', (
    tester,
  ) async {
    final controller = await _settingsController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NotificacionConfigWidget(controller: controller)),
      ),
    );

    expect(find.byType(Card), findsNothing);
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.byType(DropdownMenu<int>), findsNWidgets(2));
    expect(find.byType(DropdownButton<int>), findsNothing);
  });

  testWidgets('AgendaColorPicker conserva el color seleccionado de eventos', (
    tester,
  ) async {
    Evento? savedEvento;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventoForm(
            initialDate: DateTime(2026, 5, 13),
            eventos: const [],
            onSave: (evento) => savedEvento = evento,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Seminario');
    await tester.tap(find.byKey(const Key('agenda-color-option-1')));
    await tester.tap(find.text('Guardar evento'));
    await tester.pump();

    expect(savedEvento, isNotNull);
    expect(savedEvento!.color, const Color(0xFF3B82F6).toARGB32());
  });
}
