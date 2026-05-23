import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:agenda/features/configuracion/presentation/notificacion_config_widget.dart';
import 'package:agenda/features/configuracion/presentation/settings_controller.dart';
import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:agenda/features/tareas/repository/tarea_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeTareaRepository implements TareaRepository {
  final List<Tarea> tareas;
  final List<String> scheduledIds = [];

  _FakeTareaRepository(this.tareas);

  @override
  Future<void> addTarea(Tarea tarea) async {}

  @override
  Future<void> deleteTarea(String id) async {}

  @override
  Future<void> deleteTareaDefinitiva(String id) async {}

  @override
  Future<List<Tarea>> fetchTareas() async => tareas;

  @override
  Future<List<Tarea>> fetchTareasEliminadas() async => [];

  @override
  Future<void> programarNotificacionesTarea(String tareaId) async {
    scheduledIds.add(tareaId);
  }

  @override
  Future<void> restoreTarea(String id) async {}

  @override
  Future<void> updateTarea(Tarea tarea) async {}
}

Tarea _tarea(String id, {bool completada = false}) {
  return Tarea(
    id: id,
    titulo: 'Tarea $id',
    asignatura: 'Matematicas',
    descripcion: 'Practica',
    fecha: DateTime(2026, 5, 13),
    completada: completada,
  );
}

Future<SettingsController> _controller({
  TareaRepository? repo,
  Map<String, Object> initialPrefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(initialPrefs);
  final prefs = PreferencesHelper();
  await prefs.init();
  final controller = SettingsController(prefs: prefs, tareaRepo: repo);
  await controller.loadSettings();
  return controller;
}

void main() {
  testWidgets('NotificacionConfigWidget muestra valores actuales', (
    tester,
  ) async {
    final controller = await _controller(
      initialPrefs: {
        'clase_notificacion_minutes': 30,
        'tarea_notificaciones_minutes': ['120'],
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NotificacionConfigWidget(controller: controller)),
      ),
    );

    expect(find.text('Notificaciones Globales'), findsOneWidget);
    expect(find.text('Clases'), findsOneWidget);
    expect(find.text('Tareas (Primer Aviso)'), findsOneWidget);
    expect(find.text('30 minutos antes'), findsOneWidget);
    expect(find.text('2 hora(s) antes'), findsOneWidget);
  });

  testWidgets('NotificacionConfigWidget actualiza aviso global de clases', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NotificacionConfigWidget(controller: controller)),
      ),
    );

    await tester.tap(find.byType(DropdownButton<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('30 minutos antes').last);
    await tester.pumpAndSettle();

    expect(controller.globalClaseNotif, const Duration(minutes: 30));
  });

  testWidgets('NotificacionConfigWidget actualiza primer aviso de tareas', (
    tester,
  ) async {
    final repo = _FakeTareaRepository([
      _tarea('pendiente'),
      _tarea('completada', completada: true),
    ]);
    final controller = await _controller(repo: repo);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NotificacionConfigWidget(controller: controller)),
      ),
    );

    await tester.tap(find.byType(DropdownButton<int>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10 minutos antes').last);
    await tester.pumpAndSettle();

    expect(controller.globalTareaNotifs.first, const Duration(minutes: 10));
    expect(repo.scheduledIds, ['pendiente']);
  });
}
