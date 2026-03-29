import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Clases
  Duration getGlobalClaseNotificacion() {
    final minutes = _prefs.getInt('clase_notificacion_minutes') ?? 15; // default 15 min
    return Duration(minutes: minutes);
  }

  Future<void> setGlobalClaseNotificacion(Duration d) async {
    await _prefs.setInt('clase_notificacion_minutes', d.inMinutes);
  }

  // Tareas
  List<Duration> getGlobalTareaNotificaciones() {
    final listStrings = _prefs.getStringList('tarea_notificaciones_minutes');
    if (listStrings == null || listStrings.isEmpty) {
      return [const Duration(minutes: 60), const Duration(days: 1)]; // default 1h, 1d
    }
    return listStrings.map((s) => Duration(minutes: int.parse(s))).toList();
  }

  Future<void> setGlobalTareaNotificaciones(List<Duration> ds) async {
    final listStrings = ds.map((d) => d.inMinutes.toString()).toList();
    await _prefs.setStringList('tarea_notificaciones_minutes', listStrings);
  }
}
