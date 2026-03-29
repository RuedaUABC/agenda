import '../preferences_helper.dart';
import '../../tareas/repository/tarea_repository.dart';

class SettingsController {
  final PreferencesHelper prefs;
  final TareaRepository? tareaRepo;

  Duration globalClaseNotif = const Duration(minutes: 15);
  List<Duration> globalTareaNotifs = [const Duration(minutes: 60)];

  SettingsController({
    required this.prefs,
    this.tareaRepo,
  });

  Future<void> loadSettings() async {
    globalClaseNotif = prefs.getGlobalClaseNotificacion();
    globalTareaNotifs = prefs.getGlobalTareaNotificaciones();
  }

  Future<void> updateGlobalClaseNotif(Duration d) async {
    await prefs.setGlobalClaseNotificacion(d);
    globalClaseNotif = d;
    // Pendiente: Re-programar usando claseRepo
  }

  Future<void> updateGlobalTareaNotifs(List<Duration> ds) async {
    await prefs.setGlobalTareaNotificaciones(ds);
    globalTareaNotifs = ds;

    // Reprogramar notificaciones si existe el repositorio
    if (tareaRepo != null) {
      final tareas = await tareaRepo!.fetchTareas();
      for (var t in tareas) {
        if (!t.completada) {
          await tareaRepo!.programarNotificacionesTarea(t.id);
        }
      }
    }
  }
}
