import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:agenda/features/tareas/presentation/taskcontroller.dart';
import 'package:agenda/features/tareas/presentation/widgets/lista_tareas_categoria.dart';
import 'package:agenda/features/tareas/presentation/widgets/tarea_form.dart';
import 'package:agenda/features/tareas/repository/tarea_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTareaRepository implements TareaRepository {
  final List<Tarea> tareas = [];

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
  Future<void> updateTarea(Tarea tarea) async {
    final index = tareas.indexWhere((item) => item.id == tarea.id);
    if (index == -1) {
      tareas.add(tarea);
    } else {
      tareas[index] = tarea;
    }
  }

  @override
  Future<void> restoreTarea(String id) async {
    final index = tareas.indexWhere((tarea) => tarea.id == id);
    if (index != -1) {
      tareas[index] = tareas[index].copyWith(eliminada: false);
    }
  }
}

Tarea _tarea({
  String id = '1',
  String titulo = 'Ensayo',
  String descripcion = 'Borrador final',
  bool completada = false,
  bool eliminada = false,
}) {
  return Tarea(
    id: id,
    titulo: titulo,
    asignatura: 'Literatura',
    descripcion: descripcion,
    fecha: DateTime(2026, 6, 13),
    completada: completada,
    eliminada: eliminada,
  );
}

void main() {
  testWidgets('TareaForm muestra validacion cuando falta el titulo', (
    tester,
  ) async {
    final controller = TasksController(repository: _FakeTareaRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TareaForm(controller: controller)),
      ),
    );

    await tester.tap(find.text('Guardar'));
    await tester.pump();

    expect(find.text('Nueva tarea'), findsOneWidget);
    expect(find.textContaining('requerido'), findsOneWidget);
  });

  testWidgets('ListaTareasCategoria confirma antes de eliminar una tarea', (
    tester,
  ) async {
    final repo = _FakeTareaRepository()..tareas.add(_tarea(titulo: 'Ensayo'));
    final controller = TasksController(repository: repo);
    await controller.loadTareas();
    var refreshCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () => refreshCount++,
            title: 'Pendientes',
            tareas: controller.tareas,
          ),
        ),
      ),
    );

    expect(find.byTooltip('Eliminar tarea'), findsNothing);
    expect(find.byTooltip('Editar tarea'), findsNothing);

    await tester.tap(find.text('Ensayo'));
    await tester.pumpAndSettle();

    expect(find.text('Borrador final'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Eliminar tarea'), findsWidgets);
    expect(find.text('¿Quieres eliminar la tarea Ensayo?'), findsOneWidget);

    await tester.tap(find.text('Sí'));
    await tester.pumpAndSettle();

    expect(controller.tareas, isEmpty);
    expect(controller.papelera.single.titulo, 'Ensayo');
    expect(refreshCount, 1);
  });

  testWidgets('ListaTareasCategoria recupera una tarea desde papelera', (
    tester,
  ) async {
    final repo = _FakeTareaRepository()
      ..tareas.add(_tarea(titulo: 'Ensayo', eliminada: true));
    final controller = TasksController(repository: repo);
    await controller.loadTareas();
    var refreshCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () => refreshCount++,
            title: 'Papelera',
            tareas: controller.papelera,
            isTrashMode: true,
          ),
        ),
      ),
    );

    expect(find.byTooltip('Recuperar tarea'), findsNothing);

    await tester.tap(find.text('Ensayo'));
    await tester.pumpAndSettle();

    expect(find.text('Borrador final'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Recuperar'));
    await tester.pumpAndSettle();

    expect(controller.papelera, isEmpty);
    expect(controller.tareas.single.titulo, 'Ensayo');
    expect(refreshCount, 1);
  });

  testWidgets('ListaTareasCategoria elimina definitivamente desde papelera', (
    tester,
  ) async {
    final repo = _FakeTareaRepository()
      ..tareas.add(_tarea(titulo: 'Ensayo', eliminada: true));
    final controller = TasksController(repository: repo);
    await controller.loadTareas();
    var refreshCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () => refreshCount++,
            title: 'Papelera',
            tareas: controller.papelera,
            isTrashMode: true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ensayo'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Eliminar definitivo'));
    await tester.pumpAndSettle();

    expect(find.text('Eliminar definitivamente'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(controller.papelera, isEmpty);
    expect(repo.tareas, isEmpty);
    expect(refreshCount, 1);
  });

  testWidgets(
    'ListaTareasCategoria muestra error visible al fallar persistencia',
    (tester) async {
      final controller = TasksController(repository: _FailingDeleteRepository())
        ..papelera = [_tarea(titulo: 'Ensayo', eliminada: true)];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListaTareasCategoria(
              controller: controller,
              onRefresh: () {},
              title: 'Papelera',
              tareas: controller.papelera,
              isTrashMode: true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Ensayo'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(FilledButton, 'Eliminar definitivo'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
      await tester.pumpAndSettle();

      expect(
        find.text('No se pudo eliminar definitivamente la tarea'),
        findsOneWidget,
      );
    },
  );

  testWidgets('ListaTareasCategoria permite editar una tarea existente', (
    tester,
  ) async {
    final repo = _FakeTareaRepository()..tareas.add(_tarea(titulo: 'Ensayo'));
    final controller = TasksController(repository: repo);
    await controller.loadTareas();
    var refreshCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () => refreshCount++,
            title: 'Pendientes',
            tareas: controller.tareas,
          ),
        ),
      ),
    );

    expect(find.byTooltip('Editar tarea'), findsNothing);

    await tester.tap(find.text('Ensayo'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Editar'));
    await tester.pumpAndSettle();

    expect(find.text('Editar tarea'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Ensayo'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Ensayo'),
      'Ensayo final',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(controller.tareas.single.id, '1');
    expect(controller.tareas.single.titulo, 'Ensayo final');
    expect(refreshCount, 1);
  });

  testWidgets('ListaTareasCategoria permite completar desde el preview', (
    tester,
  ) async {
    final repo = _FakeTareaRepository()..tareas.add(_tarea(titulo: 'Ensayo'));
    final controller = TasksController(repository: repo);
    await controller.loadTareas();
    var refreshCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () => refreshCount++,
            title: 'Pendientes',
            tareas: controller.tareas,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Marcar como completada'));
    await tester.pumpAndSettle();

    expect(controller.tareas.single.completada, isTrue);
    expect(refreshCount, 1);
  });

  testWidgets(
    'ListaTareasCategoria permite devolver a pendiente desde preview',
    (tester) async {
      final repo = _FakeTareaRepository()
        ..tareas.add(_tarea(titulo: 'Ensayo', completada: true));
      final controller = TasksController(repository: repo);
      await controller.loadTareas();
      var refreshCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListaTareasCategoria(
              controller: controller,
              onRefresh: () => refreshCount++,
              title: 'Completadas',
              tareas: controller.tareas,
              isCompletedMode: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Marcar como pendiente'));
      await tester.pumpAndSettle();

      expect(controller.tareas.single.completada, isFalse);
      expect(refreshCount, 1);
    },
  );
}

class _FailingDeleteRepository implements TareaRepository {
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
