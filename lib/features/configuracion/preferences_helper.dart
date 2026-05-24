import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference { system, light, dark }

enum InitialModulePreference { tareas, horario, calendario, ajustes }

enum VisualDensityPreference { comoda, compacta }

enum WeekStartPreference { lunes, domingo }

class PreferencesHelper {
  static const List<int> allowedNotificationMinutes = [
    0,
    5,
    10,
    15,
    30,
    60,
    120,
    1440,
  ];

  static const Duration defaultClaseNotification = Duration(minutes: 15);
  static const Duration defaultEventoNotification = Duration(minutes: 30);
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

  Duration getGlobalEventoNotificacion() {
    final minutes =
        _prefs.getInt('evento_notificacion_minutes') ??
        defaultEventoNotification.inMinutes;
    if (!_isAllowedMinutes(minutes)) return defaultEventoNotification;
    return Duration(minutes: minutes);
  }

  Future<void> setGlobalEventoNotificacion(Duration d) async {
    _validateDuration(d);
    await _prefs.setInt('evento_notificacion_minutes', d.inMinutes);
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

  AppThemePreference getThemePreference() {
    return _enumByName(
      AppThemePreference.values,
      _prefs.getString('theme_preference'),
      AppThemePreference.system,
    );
  }

  Future<void> setThemePreference(AppThemePreference value) async {
    await _prefs.setString('theme_preference', value.name);
  }

  InitialModulePreference getInitialModule() {
    return _enumByName(
      InitialModulePreference.values,
      _prefs.getString('initial_module'),
      InitialModulePreference.tareas,
    );
  }

  Future<void> setInitialModule(InitialModulePreference value) async {
    await _prefs.setString('initial_module', value.name);
  }

  VisualDensityPreference getVisualDensity() {
    return _enumByName(
      VisualDensityPreference.values,
      _prefs.getString('visual_density'),
      VisualDensityPreference.comoda,
    );
  }

  Future<void> setVisualDensity(VisualDensityPreference value) async {
    await _prefs.setString('visual_density', value.name);
  }

  WeekStartPreference getWeekStart() {
    return _enumByName(
      WeekStartPreference.values,
      _prefs.getString('week_start'),
      WeekStartPreference.lunes,
    );
  }

  Future<void> setWeekStart(WeekStartPreference value) async {
    await _prefs.setString('week_start', value.name);
  }

  bool getConfirmDestructiveActions() {
    return _prefs.getBool('confirm_destructive_actions') ?? true;
  }

  Future<void> setConfirmDestructiveActions(bool value) async {
    await _prefs.setBool('confirm_destructive_actions', value);
  }

  Map<String, dynamic> exportPreferences() {
    return {
      'clase_notificacion_minutes': getGlobalClaseNotificacion().inMinutes,
      'evento_notificacion_minutes': getGlobalEventoNotificacion().inMinutes,
      'tarea_notificaciones_minutes': getGlobalTareaNotificaciones()
          .map((duration) => duration.inMinutes)
          .toList(),
      'theme_preference': getThemePreference().name,
      'initial_module': getInitialModule().name,
      'visual_density': getVisualDensity().name,
      'week_start': getWeekStart().name,
      'confirm_destructive_actions': getConfirmDestructiveActions(),
    };
  }

  Future<void> importPreferences(Map<String, dynamic> values) async {
    final claseMinutes = _readInt(values, 'clase_notificacion_minutes');
    if (claseMinutes != null) {
      await setGlobalClaseNotificacion(Duration(minutes: claseMinutes));
    }

    final eventoMinutes = _readInt(values, 'evento_notificacion_minutes');
    if (eventoMinutes != null) {
      await setGlobalEventoNotificacion(Duration(minutes: eventoMinutes));
    }

    final tareaMinutes = values['tarea_notificaciones_minutes'];
    if (tareaMinutes is List) {
      await setGlobalTareaNotificaciones(
        tareaMinutes
            .whereType<num>()
            .map((minutes) => Duration(minutes: minutes.toInt()))
            .toList(),
      );
    }

    final theme = _enumByNameOrNull(
      AppThemePreference.values,
      values['theme_preference'],
    );
    if (theme != null) await setThemePreference(theme);

    final module = _enumByNameOrNull(
      InitialModulePreference.values,
      values['initial_module'],
    );
    if (module != null) await setInitialModule(module);

    final density = _enumByNameOrNull(
      VisualDensityPreference.values,
      values['visual_density'],
    );
    if (density != null) await setVisualDensity(density);

    final weekStart = _enumByNameOrNull(
      WeekStartPreference.values,
      values['week_start'],
    );
    if (weekStart != null) await setWeekStart(weekStart);

    final confirm = values['confirm_destructive_actions'];
    if (confirm is bool) await setConfirmDestructiveActions(confirm);
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

  static int? _readInt(Map<String, dynamic> values, String key) {
    final value = values[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return null;
  }

  static T _enumByName<T extends Enum>(
    List<T> values,
    String? name,
    T fallback,
  ) {
    return _enumByNameOrNull(values, name) ?? fallback;
  }

  static T? _enumByNameOrNull<T extends Enum>(List<T> values, Object? name) {
    if (name is! String) return null;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
