import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:agenda/features/configuracion/presentation/settings_controller.dart';
import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:agenda/features/tareas/repository/tarea_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeTareaRepository implements TareaRepository {
  final List<Tarea> stored;
  final List<String> scheduledIds = [];

  FakeTareaRepository(this.stored);

  @override
  Future<void> addTarea(Tarea tarea) async {
    stored.add(tarea);
  }

  @override
  Future<void> deleteTarea(String id) async {
    final index = stored.indexWhere((tarea) => tarea.id == id);
    if (index != -1) {
      stored[index] = stored[index].copyWith(eliminada: true);
    }
  }

  @override
  Future<void> deleteTareaDefinitiva(String id) async {
    stored.removeWhere((tarea) => tarea.id == id);
  }

  @override
  Future<List<Tarea>> fetchTareas() async {
    return stored.where((tarea) => !tarea.eliminada).toList();
  }

  @override
  Future<List<Tarea>> fetchTareasEliminadas() async {
    return stored.where((tarea) => tarea.eliminada).toList();
  }

  @override
  Future<void> programarNotificacionesTarea(String tareaId) async {
    scheduledIds.add(tareaId);
  }

  @override
  Future<void> updateTarea(Tarea tarea) async {
    final index = stored.indexWhere((item) => item.id == tarea.id);
    if (index == -1) {
      stored.add(tarea);
    } else {
      stored[index] = tarea;
    }
  }

  @override
  Future<void> restoreTarea(String id) async {
    final index = stored.indexWhere((tarea) => tarea.id == id);
    if (index != -1) {
      stored[index] = stored[index].copyWith(eliminada: false);
    }
  }
}

Tarea tarea(String id, {bool completada = false}) {
  return Tarea(
    id: id,
    titulo: 'Tarea $id',
    asignatura: 'Historia',
    descripcion: 'Leer apuntes',
    fecha: DateTime(2026, 5, 13),
    completada: completada,
  );
}

void main() {
  group('SettingsController', () {
    test('carga valores por defecto de preferencias vacias', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesHelper();
      await prefs.init();
      final controller = SettingsController(prefs: prefs);

      await controller.loadSettings();

      expect(controller.globalClaseNotif, const Duration(minutes: 15));
      expect(controller.globalTareaNotifs, [
        const Duration(minutes: 60),
        const Duration(days: 1),
      ]);
    });

    test('guarda preferencias de notificaciones de clase y tareas', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesHelper();
      await prefs.init();
      final controller = SettingsController(prefs: prefs);

      await controller.updateGlobalClaseNotif(const Duration(minutes: 30));
      await controller.updateGlobalTareaNotifs([
        const Duration(minutes: 10),
        const Duration(hours: 2),
      ]);

      expect(prefs.getGlobalClaseNotificacion(), const Duration(minutes: 30));
      expect(prefs.getGlobalTareaNotificaciones(), [
        const Duration(minutes: 10),
        const Duration(hours: 2),
      ]);
    });

    test(
      'reprograma solo tareas pendientes cuando cambian notificaciones',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = PreferencesHelper();
        await prefs.init();
        final repo = FakeTareaRepository([
          tarea('pendiente'),
          tarea('completada', completada: true),
        ]);
        final controller = SettingsController(prefs: prefs, tareaRepo: repo);

        await controller.updateGlobalTareaNotifs([const Duration(minutes: 5)]);

        expect(repo.scheduledIds, ['pendiente']);
      },
    );

    test('carga preferencias previamente persistidas', () async {
      SharedPreferences.setMockInitialValues({
        'clase_notificacion_minutes': 120,
        'tarea_notificaciones_minutes': ['30', '1440'],
      });
      final prefs = PreferencesHelper();
      await prefs.init();
      final controller = SettingsController(prefs: prefs);

      await controller.loadSettings();

      expect(controller.globalClaseNotif, const Duration(hours: 2));
      expect(controller.globalTareaNotifs, [
        const Duration(minutes: 30),
        const Duration(days: 1),
      ]);
    });

    test('rechaza lista vacia de avisos de tareas', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesHelper();
      await prefs.init();
      final controller = SettingsController(prefs: prefs);

      await expectLater(
        controller.updateGlobalTareaNotifs([]),
        throwsA(isA<ArgumentError>()),
      );

      expect(controller.globalTareaNotifs, [const Duration(minutes: 60)]);
      expect(prefs.getGlobalTareaNotificaciones(), [
        const Duration(minutes: 60),
        const Duration(days: 1),
      ]);
    });

    test('no reprograma tareas cuando no se inyecta repositorio', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesHelper();
      await prefs.init();
      final controller = SettingsController(prefs: prefs);

      await controller.updateGlobalTareaNotifs([const Duration(minutes: 15)]);

      expect(controller.globalTareaNotifs, [const Duration(minutes: 15)]);
    });

    test('rechaza preferencias de clase no permitidas', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesHelper();
      await prefs.init();
      final controller = SettingsController(prefs: prefs);

      await expectLater(
        controller.updateGlobalClaseNotif(const Duration(minutes: -5)),
        throwsA(isA<ArgumentError>()),
      );

      expect(controller.globalClaseNotif, const Duration(minutes: 15));
    });

    test('rechaza avisos de tareas no permitidos', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesHelper();
      await prefs.init();
      final controller = SettingsController(prefs: prefs);

      await expectLater(
        controller.updateGlobalTareaNotifs([const Duration(minutes: 7)]),
        throwsA(isA<ArgumentError>()),
      );

      expect(controller.globalTareaNotifs, [const Duration(minutes: 60)]);
    });

    test(
      'carga valores por defecto si preferencias guardadas son invalidas',
      () async {
        SharedPreferences.setMockInitialValues({
          'clase_notificacion_minutes': -1,
          'tarea_notificaciones_minutes': ['7', '-5'],
        });
        final prefs = PreferencesHelper();
        await prefs.init();
        final controller = SettingsController(prefs: prefs);

        await controller.loadSettings();

        expect(controller.globalClaseNotif, const Duration(minutes: 15));
        expect(controller.globalTareaNotifs, [
          const Duration(minutes: 60),
          const Duration(days: 1),
        ]);
      },
    );
  });
}
