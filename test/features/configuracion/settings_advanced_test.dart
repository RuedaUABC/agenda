import 'dart:convert';

import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/repository/calendario_repository.dart';
import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:agenda/features/configuracion/presentation/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsController> _controller({
  Map<String, Object> initialPrefs = const {},
  CalendarioRepository? calendarioRepo,
}) async {
  SharedPreferences.setMockInitialValues(initialPrefs);
  final prefs = PreferencesHelper();
  await prefs.init();
  final controller = SettingsController(
    prefs: prefs,
    calendarioRepo: calendarioRepo,
  );
  await controller.loadSettings();
  return controller;
}

class _FakeCalendarioRepository implements CalendarioRepository {
  final List<Evento> eventos;
  final reprogramados = <String>[];

  _FakeCalendarioRepository(this.eventos);

  @override
  Future<void> addEvento(Evento evento) async {}

  @override
  Future<void> deleteEvento(String id) async {}

  @override
  Future<List<Evento>> fetchEventos() async => eventos;

  @override
  Future<void> programarNotificacionEvento(String eventoId) async {
    reprogramados.add(eventoId);
  }

  @override
  Future<void> updateEvento(Evento evento) async {}
}

void main() {
  group('SettingsController advanced preferences', () {
    test('carga valores por defecto de ajustes avanzados', () async {
      final controller = await _controller();

      expect(controller.globalEventoNotif, const Duration(minutes: 30));
      expect(controller.themePreference, AppThemePreference.system);
      expect(controller.initialModule, InitialModulePreference.tareas);
      expect(controller.visualDensity, VisualDensityPreference.comoda);
      expect(controller.weekStart, WeekStartPreference.lunes);
      expect(controller.confirmDestructiveActions, isTrue);
    });

    test('persiste aviso de eventos y preferencias visuales', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesHelper();
      await prefs.init();
      final controller = SettingsController(prefs: prefs);
      await controller.loadSettings();

      await controller.updateGlobalEventoNotif(const Duration(minutes: 60));
      await controller.updateThemePreference(AppThemePreference.dark);
      await controller.updateInitialModule(InitialModulePreference.calendario);
      await controller.updateVisualDensity(VisualDensityPreference.compacta);
      await controller.updateWeekStart(WeekStartPreference.domingo);
      await controller.updateConfirmDestructiveActions(false);

      final restored = SettingsController(prefs: prefs);
      await restored.loadSettings();

      expect(restored.globalEventoNotif, const Duration(minutes: 60));
      expect(restored.themePreference, AppThemePreference.dark);
      expect(restored.initialModule, InitialModulePreference.calendario);
      expect(restored.visualDensity, VisualDensityPreference.compacta);
      expect(restored.weekStart, WeekStartPreference.domingo);
      expect(restored.confirmDestructiveActions, isFalse);
    });

    test(
      'reprograma eventos futuros al cambiar aviso global de eventos',
      () async {
        final futureStart = DateTime.now().add(const Duration(days: 2));
        final repo = _FakeCalendarioRepository([
          Evento(
            id: 'evt-1',
            titulo: 'Parcial',
            inicio: futureStart,
            fin: futureStart.add(const Duration(hours: 1)),
          ),
        ]);
        final controller = await _controller(calendarioRepo: repo);

        await controller.updateGlobalEventoNotif(const Duration(minutes: 60));

        expect(repo.reprogramados, ['evt-1']);
      },
    );

    test('rechaza valores invalidos y recupera defaults', () async {
      final controller = await _controller(
        initialPrefs: {
          'evento_notificacion_minutes': 7,
          'theme_preference': 'neon',
          'initial_module': 'perfil',
          'visual_density': 'tiny',
          'week_start': 'viernes',
        },
      );

      expect(controller.globalEventoNotif, const Duration(minutes: 30));
      expect(controller.themePreference, AppThemePreference.system);
      expect(controller.initialModule, InitialModulePreference.tareas);
      expect(controller.visualDensity, VisualDensityPreference.comoda);
      expect(controller.weekStart, WeekStartPreference.lunes);

      await expectLater(
        controller.updateGlobalEventoNotif(const Duration(minutes: 7)),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('exporta e importa respaldo local validado', () async {
      final controller = await _controller();
      await controller.updateThemePreference(AppThemePreference.dark);
      await controller.updateInitialModule(InitialModulePreference.calendario);

      final backup = controller.exportLocalDataBackup(
        tareas: [
          {'id': 't1', 'titulo': 'Ensayo'},
        ],
        clases: [
          {'id': 'c1', 'materia': 'Fisica'},
        ],
        eventos: [
          {'id': 'e1', 'titulo': 'Parcial'},
        ],
      );
      final decoded = jsonDecode(backup) as Map<String, dynamic>;

      expect(decoded['version'], 1);
      expect(decoded['tareas'], isA<List<dynamic>>());
      expect(decoded['preferencias'], isA<Map<String, dynamic>>());

      await controller.updateThemePreference(AppThemePreference.light);
      await controller.importLocalDataBackup(backup);

      expect(controller.themePreference, AppThemePreference.dark);
      expect(controller.initialModule, InitialModulePreference.calendario);

      await expectLater(
        controller.importLocalDataBackup('{"version":99}'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('expone informacion de aplicacion y estados internos', () async {
      final controller = await _controller();

      expect(controller.appInfo.version, '1.0.0+1');
      expect(controller.appInfo.storageStatus, contains('local'));
      expect(controller.appInfo.notificationStatus, contains('nativas'));
    });

    test('mapea preferencias hacia ThemeMode e indice inicial', () async {
      final controller = await _controller();

      await controller.updateThemePreference(AppThemePreference.dark);
      await controller.updateInitialModule(InitialModulePreference.ajustes);

      expect(controller.themeMode, ThemeMode.dark);
      expect(controller.initialNavigationIndex, 3);
    });
  });
}
