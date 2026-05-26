import 'dart:convert';

import 'package:flutter/material.dart';

import '../../calendario/data/evento_dao.dart';
import '../../calendario/domain/evento.dart';
import '../../calendario/repository/calendario_repository.dart';
import '../data/backup_file_service.dart';
import '../../horario/data/clase_dao.dart';
import '../../horario/domain/clase.dart';
import '../../tareas/data/tarea_dao.dart';
import '../../tareas/domain/tarea.dart';
import '../preferences_helper.dart';
import '../../tareas/repository/tarea_repository.dart';

export '../data/backup_file_service.dart';

abstract class SettingsDataStore {
  Future<List<Map<String, dynamic>>> exportTareas();
  Future<List<Map<String, dynamic>>> exportClases();
  Future<List<Map<String, dynamic>>> exportEventos();
  Future<void> importData({
    required List<Map<String, dynamic>> tareas,
    required List<Map<String, dynamic>> clases,
    required List<Map<String, dynamic>> eventos,
  });
  Future<void> deleteAllData();
}

class SqliteSettingsDataStore implements SettingsDataStore {
  final TareaDao tareaDao;
  final ClaseDao claseDao;
  final EventoDao eventoDao;

  SqliteSettingsDataStore({
    TareaDao? tareaDao,
    ClaseDao? claseDao,
    EventoDao? eventoDao,
  }) : tareaDao = tareaDao ?? TareaDao(),
       claseDao = claseDao ?? ClaseDao(),
       eventoDao = eventoDao ?? EventoDao();

  @override
  Future<List<Map<String, dynamic>>> exportTareas() async {
    final tareas = await tareaDao.getTodasLasTareas();
    return tareas.map((tarea) => tarea.toMap()).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> exportClases() async {
    final clases = await claseDao.getClases();
    return clases.map((clase) => clase.toMap()).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> exportEventos() async {
    final eventos = await eventoDao.getEventos();
    return eventos.map((evento) => evento.toMap()).toList();
  }

  @override
  Future<void> importData({
    required List<Map<String, dynamic>> tareas,
    required List<Map<String, dynamic>> clases,
    required List<Map<String, dynamic>> eventos,
  }) async {
    await deleteAllData();

    for (final tarea in tareas) {
      await tareaDao.insertTarea(Tarea.fromMap(tarea));
    }
    for (final clase in clases) {
      await claseDao.insertClase(Clase.fromMap(clase));
    }
    for (final evento in eventos) {
      await eventoDao.insertEvento(Evento.fromMap(evento));
    }
  }

  @override
  Future<void> deleteAllData() async {
    await tareaDao.deleteAllTareas();
    await claseDao.deleteAllClases();
    await eventoDao.deleteAllEventos();
  }
}

class SettingsAppInfo {
  final String version;
  final String storageStatus;
  final String notificationStatus;

  const SettingsAppInfo({
    required this.version,
    required this.storageStatus,
    required this.notificationStatus,
  });
}

class SettingsController extends ChangeNotifier {
  final PreferencesHelper prefs;
  final TareaRepository? tareaRepo;
  final CalendarioRepository? calendarioRepo;
  final SettingsDataStore dataStore;
  final BackupFileService backupFileService;

  Duration globalClaseNotif = const Duration(minutes: 15);
  Duration globalEventoNotif = const Duration(minutes: 30);
  List<Duration> globalTareaNotifs = [const Duration(minutes: 60)];
  AppThemePreference themePreference = AppThemePreference.system;
  InitialModulePreference initialModule = InitialModulePreference.tareas;
  VisualDensityPreference visualDensity = VisualDensityPreference.comoda;
  WeekStartPreference weekStart = WeekStartPreference.lunes;
  bool confirmDestructiveActions = true;

  final SettingsAppInfo appInfo = const SettingsAppInfo(
    version: '1.0.0+1',
    storageStatus: 'Almacenamiento local SQLite y preferencias locales',
    notificationStatus: 'Notificaciones nativas configuradas',
  );

  SettingsController({
    required this.prefs,
    this.tareaRepo,
    this.calendarioRepo,
    SettingsDataStore? dataStore,
    BackupFileService? backupFileService,
  }) : dataStore = dataStore ?? SqliteSettingsDataStore(),
       backupFileService = backupFileService ?? NativeBackupFileService();

  Future<void> loadSettings() async {
    globalClaseNotif = prefs.getGlobalClaseNotificacion();
    globalEventoNotif = prefs.getGlobalEventoNotificacion();
    globalTareaNotifs = prefs.getGlobalTareaNotificaciones();
    themePreference = prefs.getThemePreference();
    initialModule = prefs.getInitialModule();
    visualDensity = prefs.getVisualDensity();
    weekStart = prefs.getWeekStart();
    confirmDestructiveActions = prefs.getConfirmDestructiveActions();
    notifyListeners();
  }

  Future<void> updateGlobalClaseNotif(Duration d) async {
    await prefs.setGlobalClaseNotificacion(d);
    globalClaseNotif = d;
    notifyListeners();
    // Pendiente: Re-programar usando claseRepo
  }

  Future<void> updateGlobalEventoNotif(Duration d) async {
    await prefs.setGlobalEventoNotificacion(d);
    globalEventoNotif = d;
    if (calendarioRepo != null) {
      final eventos = await calendarioRepo!.fetchEventos();
      for (final evento in eventos) {
        if (evento.inicio.isAfter(DateTime.now())) {
          await calendarioRepo!.programarNotificacionEvento(evento.id);
        }
      }
    }
    notifyListeners();
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
    notifyListeners();
  }

  Future<void> updateThemePreference(AppThemePreference value) async {
    await prefs.setThemePreference(value);
    themePreference = value;
    notifyListeners();
  }

  Future<void> updateInitialModule(InitialModulePreference value) async {
    await prefs.setInitialModule(value);
    initialModule = value;
    notifyListeners();
  }

  Future<void> updateVisualDensity(VisualDensityPreference value) async {
    await prefs.setVisualDensity(value);
    visualDensity = value;
    notifyListeners();
  }

  Future<void> updateWeekStart(WeekStartPreference value) async {
    await prefs.setWeekStart(value);
    weekStart = value;
    notifyListeners();
  }

  Future<void> updateConfirmDestructiveActions(bool value) async {
    await prefs.setConfirmDestructiveActions(value);
    confirmDestructiveActions = value;
    notifyListeners();
  }

  ThemeMode get themeMode {
    switch (themePreference) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
    }
  }

  int get initialNavigationIndex {
    switch (initialModule) {
      case InitialModulePreference.tareas:
        return 0;
      case InitialModulePreference.horario:
        return 1;
      case InitialModulePreference.calendario:
        return 2;
      case InitialModulePreference.ajustes:
        return 3;
    }
  }

  int get calendarFirstDayOfWeek {
    switch (weekStart) {
      case WeekStartPreference.lunes:
        return DateTime.monday;
      case WeekStartPreference.domingo:
        return DateTime.sunday;
    }
  }

  VisualDensity get materialVisualDensity {
    switch (visualDensity) {
      case VisualDensityPreference.comoda:
        return VisualDensity.standard;
      case VisualDensityPreference.compacta:
        return VisualDensity.compact;
    }
  }

  String exportLocalDataBackup({
    List<Map<String, dynamic>> tareas = const [],
    List<Map<String, dynamic>> clases = const [],
    List<Map<String, dynamic>> eventos = const [],
  }) {
    return jsonEncode({
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'preferencias': prefs.exportPreferences(),
      'tareas': tareas,
      'clases': clases,
      'eventos': eventos,
    });
  }

  Future<void> importLocalDataBackup(String rawJson) async {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw ArgumentError.value(rawJson, 'rawJson', 'Respaldo invalido');
    }
    if (decoded['version'] != 1) {
      throw ArgumentError.value(
        decoded['version'],
        'version',
        'Version invalida',
      );
    }
    final preferencias = decoded['preferencias'];
    if (preferencias is! Map<String, dynamic>) {
      throw ArgumentError.value(
        preferencias,
        'preferencias',
        'Datos invalidos',
      );
    }

    await prefs.importPreferences(preferencias);
    await loadSettings();
  }

  Future<String> exportCompleteLocalDataBackup() async {
    return exportLocalDataBackup(
      tareas: await dataStore.exportTareas(),
      clases: await dataStore.exportClases(),
      eventos: await dataStore.exportEventos(),
    );
  }

  Future<String?> exportCompleteLocalDataBackupToFile() async {
    final backup = await exportCompleteLocalDataBackup();
    return backupFileService.saveBackup(backup);
  }

  Future<void> importCompleteLocalDataBackupFromFile() async {
    final backup = await backupFileService.openBackup();
    if (backup == null) return;
    await importCompleteLocalDataBackup(backup);
  }

  Future<void> importCompleteLocalDataBackup(String rawJson) async {
    final decoded = _decodeBackup(rawJson);
    final preferencias = decoded['preferencias'];
    if (preferencias is! Map<String, dynamic>) {
      throw ArgumentError.value(
        preferencias,
        'preferencias',
        'Datos invalidos',
      );
    }
    await prefs.importPreferences(preferencias);
    await dataStore.importData(
      tareas: _readMapList(decoded, 'tareas'),
      clases: _readMapList(decoded, 'clases'),
      eventos: _readMapList(decoded, 'eventos'),
    );
    await loadSettings();
  }

  Future<void> deleteAllLocalData() async {
    await dataStore.deleteAllData();
    notifyListeners();
  }

  Map<String, dynamic> _decodeBackup(String rawJson) {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw ArgumentError.value(rawJson, 'rawJson', 'Respaldo invalido');
    }
    if (decoded['version'] != 1) {
      throw ArgumentError.value(
        decoded['version'],
        'version',
        'Version invalida',
      );
    }
    return decoded;
  }

  List<Map<String, dynamic>> _readMapList(
    Map<String, dynamic> decoded,
    String key,
  ) {
    final value = decoded[key];
    if (value is! List) {
      throw ArgumentError.value(value, key, 'Lista invalida');
    }
    return value.map((item) {
      if (item is! Map) {
        throw ArgumentError.value(item, key, 'Elemento invalido');
      }
      return Map<String, dynamic>.from(item);
    }).toList();
  }
}
