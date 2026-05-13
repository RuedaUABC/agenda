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
    stored.removeWhere((tarea) => tarea.id == id);
  }

  @override
  Future<List<Tarea>> fetchTareas() async => List<Tarea>.from(stored);

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
  });
}
