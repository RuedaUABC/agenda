import '../domain/tarea.dart';
import '../data/tarea_dao.dart';
import '../data/notificacion_dao.dart';
import '../data/tarea_service.dart';
import '../../configuracion/preferences_helper.dart';
import '../../../core/utils/notification_scheduler.dart';
import 'tarea_repository.dart';

class TareaRepositoryImpl implements TareaRepository {
  final TareaDao tareaDao;
  final NotificacionDao notifDao;
  final TareaService tareaService;
  final PreferencesHelper prefs;
  final NotificationScheduler scheduler;

  TareaRepositoryImpl({
    required this.tareaDao,
    required this.notifDao,
    required this.tareaService,
    required this.prefs,
    required this.scheduler,
  });

  @override
  Future<List<Tarea>> fetchTareas() async {
    return await tareaDao.getTareas();
  }

  @override
  Future<void> addTarea(Tarea tarea) async {
    await tareaDao.insertTarea(tarea);
    await programarNotificacionesTarea(tarea.id);
  }

  @override
  Future<void> updateTarea(Tarea tarea) async {
    await tareaDao.updateTarea(tarea);
    await programarNotificacionesTarea(tarea.id);
  }

  @override
  Future<void> deleteTarea(String id) async {
    await tareaDao.deleteTarea(id);
    await scheduler.cancelNotification(id);
  }

  @override
  Future<void> programarNotificacionesTarea(String tareaId) async {
    // Obtener la tarea
    final tarea = (await tareaDao.getTareas()).firstWhere(
      (t) => t.id == tareaId,
      orElse: () => throw Exception("Tarea no encontrada"),
    );

    // Cancelar notificaciones previas de esa tarea
    await scheduler.cancelNotification(tarea.id);

    // Obtener preferencias globales (ej. recordatorios 1h antes, 1 día antes)
    final tiempos = prefs.getGlobalTareaNotificaciones();

    for (var tiempo in tiempos) {
      final when = tarea.fecha.subtract(tiempo);

      // Programar notificación
      await scheduler.scheduleNotification(
        id: "${tarea.id}_${tiempo.inMinutes}", // ID única por tarea+tiempo
        when: when,
        title: "Recordatorio de tarea",
        body: tarea.titulo,
      );
    }
  }
}
