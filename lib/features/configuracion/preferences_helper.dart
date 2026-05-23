import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const List<int> allowedNotificationMinutes = [
    5,
    10,
    15,
    30,
    60,
    120,
    1440,
  ];

  static const Duration defaultClaseNotification = Duration(minutes: 15);
  static const List<Duration> defaultTareaNotifications = [
    Duration(minutes: 60),
    Duration(days: 1),
  ];

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Duration getGlobalClaseNotificacion() {
    final minutes =
        _prefs.getInt('clase_notificacion_minutes') ??
        defaultClaseNotification.inMinutes;
    if (!_isAllowedMinutes(minutes)) return defaultClaseNotification;
    return Duration(minutes: minutes);
  }

  Future<void> setGlobalClaseNotificacion(Duration d) async {
    _validateDuration(d);
    await _prefs.setInt('clase_notificacion_minutes', d.inMinutes);
  }

  List<Duration> getGlobalTareaNotificaciones() {
    final listStrings = _prefs.getStringList('tarea_notificaciones_minutes');
    if (listStrings == null || listStrings.isEmpty) {
      return defaultTareaNotifications;
    }

    final minutes = <int>[];
    for (final value in listStrings) {
      final parsed = int.tryParse(value);
      if (parsed == null || !_isAllowedMinutes(parsed)) {
        return defaultTareaNotifications;
      }
      minutes.add(parsed);
    }

    return minutes.map((minutes) => Duration(minutes: minutes)).toList();
  }

  Future<void> setGlobalTareaNotificaciones(List<Duration> ds) async {
    if (ds.isEmpty) {
      throw ArgumentError.value(ds, 'ds', 'Debe incluir al menos un aviso');
    }
    for (final duration in ds) {
      _validateDuration(duration);
    }
    final listStrings = ds.map((d) => d.inMinutes.toString()).toList();
    await _prefs.setStringList('tarea_notificaciones_minutes', listStrings);
  }

  static bool isAllowed(Duration duration) {
    return _isAllowedMinutes(duration.inMinutes);
  }

  static bool _isAllowedMinutes(int minutes) {
    return allowedNotificationMinutes.contains(minutes);
  }

  static void _validateDuration(Duration duration) {
    if (!_isAllowedMinutes(duration.inMinutes)) {
      throw ArgumentError.value(
        duration,
        'duration',
        'Aviso de notificacion no permitido',
      );
    }
  }
}
