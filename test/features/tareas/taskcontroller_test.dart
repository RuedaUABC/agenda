import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:agenda/features/tareas/presentation/taskcontroller.dart';
import 'package:agenda/features/tareas/repository/tarea_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTareaRepository implements TareaRepository {
  final List<Tarea> stored;
  final List<String> scheduledIds = [];

  FakeTareaRepository([List<Tarea>? initial]) : stored = initial ?? [];

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

Tarea tarea({
  required String id,
  required DateTime fecha,
  bool completada = false,
  String titulo = 'Tarea',
}) {
  return Tarea(
    id: id,
    titulo: titulo,
    asignatura: 'Matematicas',
    descripcion: 'Resolver ejercicios',
    fecha: fecha,
    completada: completada,
  );
}

void main() {
  group('TasksController', () {
    test('carga tareas desde el repositorio y actualiza isLoading', () async {
      final repo = FakeTareaRepository([tarea(id: '1', fecha: DateTime.now())]);
      final controller = TasksController(repository: repo);

      await controller.loadTareas();

      expect(controller.isLoading, isFalse);
      expect(controller.tareas, hasLength(1));
      expect(controller.tareas.single.id, '1');
    });

    test(
      'crea, actualiza y envia tareas a papelera recargando la lista',
      () async {
        final repo = FakeTareaRepository();
        final controller = TasksController(repository: repo);
        final original = tarea(id: '1', fecha: DateTime.now(), titulo: 'Leer');
        final updated = tarea(
          id: '1',
          fecha: DateTime.now().add(const Duration(days: 1)),
          titulo: 'Leer capitulo 2',
        );

        await controller.createTarea(original);
        expect(controller.tareas.single.titulo, 'Leer');

        await controller.updateTarea(updated);
        expect(controller.tareas.single.titulo, 'Leer capitulo 2');

        await controller.deleteTarea('1');
        expect(controller.tareas, isEmpty);
        expect(controller.papelera.single.id, '1');
        expect(controller.papelera.single.eliminada, isTrue);
      },
    );

    test('recupera una tarea eliminada desde la papelera', () async {
      final repo = FakeTareaRepository([
        tarea(
          id: '1',
          fecha: DateTime.now(),
          titulo: 'Ensayo',
        ).copyWith(eliminada: true),
      ]);
      final controller = TasksController(repository: repo);

      await controller.loadTareas();
      expect(controller.tareas, isEmpty);
      expect(controller.papelera.single.titulo, 'Ensayo');

      await controller.restoreTarea('1');

      expect(controller.papelera, isEmpty);
      expect(controller.tareas.single.titulo, 'Ensayo');
      expect(controller.tareas.single.eliminada, isFalse);
    });

    test('elimina definitivamente una tarea desde la papelera', () async {
      final repo = FakeTareaRepository([
        tarea(
          id: '1',
          fecha: DateTime.now(),
          titulo: 'Ensayo',
        ).copyWith(eliminada: true),
      ]);
      final controller = TasksController(repository: repo);

      await controller.loadTareas();
      await controller.deleteTareaDefinitiva('1');

      expect(controller.papelera, isEmpty);
      expect(repo.stored, isEmpty);
    });

    test(
      'clasifica vencidas, pendientes de semana, proximas y completadas',
      () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final controller = TasksController(repository: FakeTareaRepository())
          ..tareas = [
            tarea(
              id: 'vencida',
              fecha: today.subtract(const Duration(days: 1)),
            ),
            tarea(id: 'semana', fecha: today.add(const Duration(days: 6))),
            tarea(id: 'proxima', fecha: today.add(const Duration(days: 7))),
            tarea(id: 'completa', fecha: today, completada: true),
          ];

        final result = controller.clasificarTareas();

        expect(result['vencidas']!.map((t) => t.id), ['vencida']);
        expect(result['pendientesSemana']!.map((t) => t.id), ['semana']);
        expect(result['proximas']!.map((t) => t.id), ['proxima']);
        expect(result['completadas']!.map((t) => t.id), ['completa']);
      },
    );

    test('calcula estadisticas semanales solo con tareas no completadas', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final controller = TasksController(repository: FakeTareaRepository())
        ..tareas = [
          tarea(id: '1', fecha: today),
          tarea(id: '2', fecha: today),
          tarea(id: '3', fecha: today, completada: true),
          tarea(id: '4', fecha: today.add(const Duration(days: 1))),
          tarea(id: '8', fecha: today.add(const Duration(days: 8))),
        ];

      final stats = controller.getWeeklyStats();

      expect(stats, hasLength(7));
      expect(stats[today], 2);
      expect(stats[today.add(const Duration(days: 1))], 1);
      expect(stats.containsKey(today.add(const Duration(days: 8))), isFalse);
    });

    test('calcula progreso de hoy con tareas completadas y pendientes', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final controller = TasksController(repository: FakeTareaRepository())
        ..tareas = [
          tarea(id: '1', fecha: today, completada: true),
          tarea(id: '2', fecha: today, completada: false),
          tarea(
            id: '3',
            fecha: today.add(const Duration(days: 1)),
            completada: true,
          ),
        ];

      expect(controller.getTodayProgress(), 0.5);
    });

    test('busca tareas por titulo, asignatura y descripcion', () {
      final controller = TasksController(repository: FakeTareaRepository())
        ..tareas = [
          tarea(id: '1', fecha: DateTime.now(), titulo: 'Leer fuentes'),
          Tarea(
            id: '2',
            titulo: 'Resolver ejercicios',
            asignatura: 'Historia',
            descripcion: 'Preparar exposicion',
            fecha: DateTime.now(),
            completada: false,
          ),
        ]
        ..searchQuery = 'historia';

      final result = controller.filtrarTareas(controller.tareas);

      expect(result.map((tarea) => tarea.id), ['2']);
    });

    test('filtra tareas por estado y rango de fecha', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final controller = TasksController(repository: FakeTareaRepository())
        ..tareas = [
          tarea(id: 'pendiente-hoy', fecha: today, completada: false),
          tarea(id: 'completa-hoy', fecha: today, completada: true),
          tarea(
            id: 'pendiente-futura',
            fecha: today.add(const Duration(days: 10)),
            completada: false,
          ),
        ]
        ..statusFilter = TaskStatusFilter.pendientes
        ..dateFilter = TaskDateFilter.hoy;

      final result = controller.filtrarTareas(controller.tareas);

      expect(result.map((tarea) => tarea.id), ['pendiente-hoy']);
    });

    test('expone error cuando falla la persistencia', () async {
      final controller = TasksController(repository: _FailingTareaRepository());

      await expectLater(
        controller.deleteTareaDefinitiva('1'),
        throwsA(isA<Exception>()),
      );

      expect(
        controller.lastError,
        'No se pudo eliminar definitivamente la tarea',
      );
    });
  });
}

class _FailingTareaRepository implements TareaRepository {
  @override
  Future<void> addTarea(Tarea tarea) async {}

  @override
  Future<void> deleteTarea(String id) async {}

  @override
  Future<void> deleteTareaDefinitiva(String id) async {
    throw Exception('db down');
  }

  @override
  Future<List<Tarea>> fetchTareas() async => [];

  @override
  Future<List<Tarea>> fetchTareasEliminadas() async => [];

  @override
  Future<void> programarNotificacionesTarea(String tareaId) async {}

  @override
  Future<void> restoreTarea(String id) async {}

  @override
  Future<void> updateTarea(Tarea tarea) async {}
}
