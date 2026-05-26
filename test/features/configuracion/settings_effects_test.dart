import 'dart:convert';

import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/presentation/calendario.dart';
import 'package:agenda/features/calendario/presentation/mobile.dart'
    as calendario_mobile;
import 'package:agenda/features/calendario/presentation/widgets/evento_list_item.dart';
import 'package:agenda/features/calendario/presentation/calendario_controller.dart';
import 'package:agenda/features/calendario/repository/calendario_repository.dart';
import 'package:agenda/core/app/app_restart_scope.dart';
import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:agenda/features/configuracion/presentation/advanced_settings_widget.dart';
import 'package:agenda/features/configuracion/presentation/notificacion_config_widget.dart';
import 'package:agenda/features/configuracion/presentation/settings_controller.dart';
import 'package:agenda/features/horario/domain/clase.dart';
import 'package:agenda/features/horario/presentation/horario.dart';
import 'package:agenda/features/horario/presentation/mobile.dart'
    as horario_mobile;
import 'package:agenda/main.dart';
import 'package:agenda/features/horario/presentation/horario_controller.dart';
import 'package:agenda/features/horario/repository/horario_repository.dart';
import 'package:agenda/features/navegacion/presentation/navegacion.dart';
import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:agenda/features/tareas/presentation/tareas.dart';
import 'package:agenda/features/tareas/presentation/taskcontroller.dart';
import 'package:agenda/features/tareas/presentation/widgets/lista_tareas_categoria.dart';
import 'package:agenda/features/tareas/repository/tarea_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class _FakeCalendarioRepository implements CalendarioRepository {
  @override
  Future<void> addEvento(Evento evento) async {}

  @override
  Future<void> deleteEvento(String id) async {}

  @override
  Future<List<Evento>> fetchEventos() async => [];

  @override
  Future<void> programarNotificacionEvento(String eventoId) async {}

  @override
  Future<void> updateEvento(Evento evento) async {}
}

class _FakeHorarioRepository implements HorarioRepository {
  @override
  Future<void> addClase(Clase clase) async {}

  @override
  Future<void> deleteClase(String id) async {}

  @override
  Future<List<Clase>> fetchClases() async => [];

  @override
  Future<void> updateClase(Clase clase) async {}
}

class _FakeTareaRepository implements TareaRepository {
  final List<Tarea> tareas;

  _FakeTareaRepository(this.tareas);

  @override
  Future<void> addTarea(Tarea tarea) async {
    tareas.add(tarea);
  }

  @override
  Future<void> deleteTarea(String id) async {
    final index = tareas.indexWhere((tarea) => tarea.id == id);
    if (index != -1) {
      tareas[index] = tareas[index].copyWith(eliminada: true);
    }
  }

  @override
  Future<void> deleteTareaDefinitiva(String id) async {
    tareas.removeWhere((tarea) => tarea.id == id);
  }

  @override
  Future<List<Tarea>> fetchTareas() async {
    return tareas.where((tarea) => !tarea.eliminada).toList();
  }

  @override
  Future<List<Tarea>> fetchTareasEliminadas() async {
    return tareas.where((tarea) => tarea.eliminada).toList();
  }

  @override
  Future<void> programarNotificacionesTarea(String tareaId) async {}

  @override
  Future<void> restoreTarea(String id) async {}

  @override
  Future<void> updateTarea(Tarea tarea) async {}
}

class _FakeSettingsDataStore implements SettingsDataStore {
  bool cleared = false;
  List<Map<String, dynamic>> importedTareas = [];
  List<Map<String, dynamic>> importedClases = [];
  List<Map<String, dynamic>> importedEventos = [];

  @override
  Future<List<Map<String, dynamic>>> exportTareas() async {
    return [
      {'id': 't1', 'titulo': 'Ensayo'},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> exportClases() async {
    return [
      {'id': 'c1', 'materia': 'Fisica'},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> exportEventos() async {
    return [
      {'id': 'e1', 'titulo': 'Parcial'},
    ];
  }

  @override
  Future<void> importData({
    required List<Map<String, dynamic>> tareas,
    required List<Map<String, dynamic>> clases,
    required List<Map<String, dynamic>> eventos,
  }) async {
    importedTareas = tareas;
    importedClases = clases;
    importedEventos = eventos;
  }

  @override
  Future<void> deleteAllData() async {
    cleared = true;
  }
}

class _FakeBackupFileService implements BackupFileService {
  String? exportedContent;
  String? importedContent;
  String? savedPath = 'C:\\tmp\\agenda-backup.json';

  @override
  Future<String?> openBackup() async => importedContent;

  @override
  Future<String?> saveBackup(String content) async {
    exportedContent = content;
    return savedPath;
  }
}

Evento _evento() {
  return Evento(
    id: 'e1',
    titulo: 'Parcial',
    inicio: DateTime(2026, 5, 13, 10),
    fin: DateTime(2026, 5, 13, 11),
    color: Colors.teal.toARGB32(),
  );
}

Tarea _tarea() {
  return Tarea(
    id: 't1',
    titulo: 'Ensayo',
    asignatura: 'Literatura',
    descripcion: 'Borrador',
    fecha: DateTime(2026, 5, 13),
    completada: false,
  );
}

Future<SettingsController> _settingsController({
  SettingsDataStore? dataStore,
  BackupFileService? backupFileService,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = PreferencesHelper();
  await prefs.init();
  final controller = SettingsController(
    prefs: prefs,
    dataStore: dataStore,
    backupFileService: backupFileService,
  );
  await controller.loadSettings();
  return controller;
}

void main() {
  testWidgets('inicio de semana afecta calendario y horario', (tester) async {
    final calendarioController = CalendarioController(
      repository: _FakeCalendarioRepository(),
    )..selectedDate.value = DateTime(2026, 5, 13);
    final horarioController = HorarioController(
      repository: _FakeHorarioRepository(),
    )..selectedDate.value = DateTime(2026, 5, 13);

    await tester.pumpWidget(
      MaterialApp(
        home: calendario_mobile.MyMobileBody(
          controller: calendarioController,
          onRefresh: () {},
          weekStart: WeekStartPreference.domingo,
        ),
      ),
    );

    expect(
      tester.widget<SfCalendar>(find.byType(SfCalendar)).firstDayOfWeek,
      DateTime.sunday,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: horario_mobile.MyMobileBody(
            controller: horarioController,
            onRefresh: () {},
            weekStart: WeekStartPreference.domingo,
          ),
        ),
      ),
    );

    expect(
      tester.widget<SfCalendar>(find.byType(SfCalendar)).firstDayOfWeek,
      DateTime.sunday,
    );
  });

  testWidgets('densidad compacta se aplica a listas de tareas', (tester) async {
    final repo = _FakeTareaRepository([_tarea()]);
    final controller = TasksController(repository: repo);
    await controller.loadTareas();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () {},
            title: 'Pendientes',
            tareas: controller.tareas,
            visualDensityPreference: VisualDensityPreference.compacta,
          ),
        ),
      ),
    );

    final tile = tester.widget<ListTile>(find.byType(ListTile));
    expect(tile.visualDensity, VisualDensity.compact);
  });

  testWidgets('confirmaciones desactivadas eliminan sin dialogo comun', (
    tester,
  ) async {
    var deletedEvento = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventoListItem(
            evento: _evento(),
            confirmBeforeDelete: false,
            onDelete: () async => deletedEvento = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Eliminar evento Parcial'));
    await tester.pumpAndSettle();

    expect(find.text('Eliminar evento'), findsNothing);
    expect(deletedEvento, isTrue);

    final repo = _FakeTareaRepository([_tarea()]);
    final controller = TasksController(repository: repo);
    await controller.loadTareas();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () {},
            title: 'Pendientes',
            tareas: controller.tareas,
            confirmDestructiveActions: false,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ensayo'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Eliminar tarea'), findsNothing);
    expect(controller.papelera.single.titulo, 'Ensayo');
  });

  test(
    'gestion de datos usa store real para exportar importar y borrar',
    () async {
      final store = _FakeSettingsDataStore();
      final controller = await _settingsController(dataStore: store);

      final backup = await controller.exportCompleteLocalDataBackup();
      final decoded = jsonDecode(backup) as Map<String, dynamic>;

      expect(decoded['tareas'], [
        {'id': 't1', 'titulo': 'Ensayo'},
      ]);
      expect(decoded['clases'], [
        {'id': 'c1', 'materia': 'Fisica'},
      ]);
      expect(decoded['eventos'], [
        {'id': 'e1', 'titulo': 'Parcial'},
      ]);

      await controller.importCompleteLocalDataBackup(backup);
      expect(store.importedTareas.single['titulo'], 'Ensayo');
      expect(store.importedClases.single['materia'], 'Fisica');
      expect(store.importedEventos.single['titulo'], 'Parcial');

      await controller.deleteAllLocalData();
      expect(store.cleared, isTrue);
    },
  );

  test(
    'gestion de datos usa servicio nativo para exportar e importar archivos',
    () async {
      final store = _FakeSettingsDataStore();
      final fileService = _FakeBackupFileService();
      final controller = await _settingsController(
        dataStore: store,
        backupFileService: fileService,
      );

      final path = await controller.exportCompleteLocalDataBackupToFile();
      expect(path, 'C:\\tmp\\agenda-backup.json');
      expect(fileService.exportedContent, isNotNull);
      expect(jsonDecode(fileService.exportedContent!)['eventos'], [
        {'id': 'e1', 'titulo': 'Parcial'},
      ]);

      fileService.importedContent = fileService.exportedContent;
      await controller.importCompleteLocalDataBackupFromFile();

      expect(store.importedTareas.single['titulo'], 'Ensayo');
      expect(store.importedClases.single['materia'], 'Fisica');
      expect(store.importedEventos.single['titulo'], 'Parcial');
    },
  );

  testWidgets('cambios de ajustes se aplican en tiempo real en pantallas', (
    tester,
  ) async {
    final settings = await _settingsController();
    final calendarioController = CalendarioController(
      repository: _FakeCalendarioRepository(),
    )..selectedDate.value = DateTime(2026, 5, 13);

    await tester.pumpWidget(
      MaterialApp(
        home: CalendarioPage(
          controller: calendarioController,
          settingsController: settings,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<SfCalendar>(find.byType(SfCalendar)).firstDayOfWeek,
      DateTime.monday,
    );

    await settings.updateWeekStart(WeekStartPreference.domingo);
    await tester.pumpAndSettle();

    expect(
      tester.widget<SfCalendar>(find.byType(SfCalendar)).firstDayOfWeek,
      DateTime.sunday,
    );

    final horarioController = HorarioController(
      repository: _FakeHorarioRepository(),
    )..selectedDate.value = DateTime(2026, 5, 13);

    await tester.pumpWidget(
      MaterialApp(
        home: HorarioPage(
          controller: horarioController,
          settingsController: settings,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<SfCalendar>(find.byType(SfCalendar)).firstDayOfWeek,
      DateTime.sunday,
    );

    await settings.updateWeekStart(WeekStartPreference.lunes);
    await tester.pumpAndSettle();

    expect(
      tester.widget<SfCalendar>(find.byType(SfCalendar)).firstDayOfWeek,
      DateTime.monday,
    );

    final tareasRepo = _FakeTareaRepository([_tarea()]);
    final tareasController = TasksController(repository: tareasRepo);
    await tareasController.loadTareas();

    await tester.pumpWidget(
      MaterialApp(
        home: TasksPage(
          controller: tareasController,
          settingsController: settings,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<ListTile>(find.byType(ListTile).first).visualDensity,
      VisualDensity.standard,
    );

    await settings.updateVisualDensity(VisualDensityPreference.compacta);
    await tester.pumpAndSettle();

    expect(
      tester.widget<ListTile>(find.byType(ListTile).first).visualDensity,
      VisualDensity.compact,
    );
  });

  testWidgets('tema cambia en tiempo real desde MyApp', (tester) async {
    final settings = await _settingsController();

    await tester.pumpWidget(
      MyApp(settingsController: settings, home: const SizedBox.shrink()),
    );

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );

    await settings.updateThemePreference(AppThemePreference.dark);
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('recordatorios reflejan cambios externos del controller', (
    tester,
  ) async {
    final settings = await _settingsController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NotificacionConfigWidget(controller: settings)),
      ),
    );

    expect(
      tester
          .widget<DropdownMenu<int>>(find.byType(DropdownMenu<int>).at(1))
          .initialSelection,
      30,
    );

    await settings.updateGlobalEventoNotif(const Duration(minutes: 60));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<DropdownMenu<int>>(find.byType(DropdownMenu<int>).at(1))
          .initialSelection,
      60,
    );
  });

  testWidgets('vista inicial muestra efecto diferido sin navegar', (
    tester,
  ) async {
    final settings = await _settingsController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AdvancedSettingsWidget(controller: settings)),
      ),
    );

    expect(find.textContaining('Se aplicara al abrir Agenda'), findsOneWidget);

    tester
        .widget<DropdownMenu<InitialModulePreference>>(
          find.byType(DropdownMenu<InitialModulePreference>),
        )
        .onSelected!(InitialModulePreference.calendario);
    await tester.pumpAndSettle();

    expect(settings.initialModule, InitialModulePreference.calendario);
    expect(find.textContaining('Se aplicara al abrir Agenda'), findsOneWidget);
  });

  testWidgets('boton aplicar cambios reinicia navegacion con vista guardada', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    final settings = await _settingsController();

    await tester.pumpWidget(
      AppRestartScope(
        child: ListenableBuilder(
          listenable: settings,
          builder: (context, _) {
            return MaterialApp(
              home: AgendaNavigation(
                initialIndex: settings.initialNavigationIndex,
                pages: [
                  const Scaffold(body: Center(child: Text('Tareas test'))),
                  const Scaffold(body: Center(child: Text('Horario test'))),
                  const Scaffold(body: Center(child: Text('Calendario test'))),
                  Scaffold(body: AdvancedSettingsWidget(controller: settings)),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Tareas test'), findsOneWidget);

    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    expect(find.text('Aplicar cambios'), findsOneWidget);

    await settings.updateInitialModule(InitialModulePreference.calendario);
    await tester.pumpAndSettle();
    expect(find.text('Aplicar cambios'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Aplicar'));
    await tester.pumpAndSettle();

    expect(find.text('Calendario test'), findsOneWidget);
  });

  test('borrado de datos emite cambio para refresco en vivo', () async {
    final store = _FakeSettingsDataStore();
    final settings = await _settingsController(dataStore: store);
    var notifications = 0;
    settings.addListener(() => notifications++);

    await settings.deleteAllLocalData();

    expect(store.cleared, isTrue);
    expect(notifications, 1);
  });
}
