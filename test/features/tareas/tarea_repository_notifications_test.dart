import 'package:agenda/core/utils/notification_scheduler.dart';
import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:agenda/features/tareas/data/notificacion_dao.dart';
import 'package:agenda/features/tareas/data/tarea_dao.dart';
import 'package:agenda/features/tareas/data/tarea_service.dart';
import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:agenda/features/tareas/repository/tareas_repository_impt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MemoryTareaDao extends TareaDao {
  final List<Tarea> stored = [];

  @override
  Future<int> insertTarea(Tarea tarea) async {
    stored.add(tarea);
    return 1;
  }

  @override
  Future<List<Tarea>> getTareas() async {
    return stored.where((tarea) => !tarea.eliminada).toList();
  }
}

class _FailingPastScheduler extends NotificationScheduler {
  final scheduled = <DateTime>[];

  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleNotification({
    required String id,
    required DateTime when,
    required String title,
    required String body,
  }) async {
    if (!when.isAfter(DateTime.now())) {
      throw ArgumentError.value(when, 'when', 'Debe ser una fecha futura');
    }
    scheduled.add(when);
  }

  @override
  Future<void> cancelNotification(String id) async {}
}

Tarea _tarea(DateTime fecha) {
  return Tarea(
    id: 't1',
    titulo: 'Ensayo',
    asignatura: 'Literatura',
    descripcion: '',
    fecha: fecha,
    completada: false,
  );
}

Future<PreferencesHelper> _prefs() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = PreferencesHelper();
  await prefs.init();
  return prefs;
}

void main() {
  test(
    'addTarea no falla si un recordatorio global queda en el pasado',
    () async {
      final tareaDao = _MemoryTareaDao();
      final scheduler = _FailingPastScheduler();
      final repository = TareaRepositoryImpl(
        tareaDao: tareaDao,
        notifDao: NotificacionDao(),
        tareaService: TareaService(),
        prefs: await _prefs(),
        scheduler: scheduler,
      );

      await repository.addTarea(
        _tarea(DateTime.now().add(const Duration(minutes: 30))),
      );

      expect(tareaDao.stored.single.titulo, 'Ensayo');
      expect(scheduler.scheduled, isEmpty);
    },
  );
}
