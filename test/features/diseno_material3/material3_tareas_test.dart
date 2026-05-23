import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:agenda/features/tareas/presentation/taskcontroller.dart';
import 'package:agenda/features/tareas/presentation/widgets/lista_tareas_categoria.dart';
import 'package:agenda/features/tareas/presentation/widgets/tarea_form.dart';
import 'package:agenda/features/tareas/presentation/widgets/tareas_filter_bar.dart';
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
  Future<void> deleteTarea(String id) async {}

  @override
  Future<void> deleteTareaDefinitiva(String id) async {}

  @override
  Future<List<Tarea>> fetchTareas() async => tareas;

  @override
  Future<List<Tarea>> fetchTareasEliminadas() async => [];

  @override
  Future<void> programarNotificacionesTarea(String tareaId) async {}

  @override
  Future<void> restoreTarea(String id) async {}

  @override
  Future<void> updateTarea(Tarea tarea) async {
    final index = tareas.indexWhere((item) => item.id == tarea.id);
    if (index == -1) {
      tareas.add(tarea);
    } else {
      tareas[index] = tarea;
    }
  }
}

Tarea _tarea({bool completada = false}) {
  return Tarea(
    id: '1',
    titulo: 'Ensayo',
    asignatura: 'Literatura',
    descripcion: 'Borrador',
    fecha: DateTime(2026, 5, 13, 9),
    completada: completada,
  );
}

void main() {
  testWidgets('TareasFilterBar usa solo selector de estado Material 3', (
    tester,
  ) async {
    final controller = TasksController(repository: _FakeTareaRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TareasFilterBar(controller: controller, onChanged: () {}),
        ),
      ),
    );

    expect(find.byType(SearchBar), findsNothing);
    expect(find.byType(SegmentedButton<TaskStatusFilter>), findsOneWidget);
    expect(find.byType(DropdownMenu<TaskDateFilter>), findsNothing);
    expect(find.byType(DropdownButton<TaskStatusFilter>), findsNothing);
    expect(find.byType(DropdownButton<TaskDateFilter>), findsNothing);
  });

  testWidgets('ListaTareasCategoria muestra contador y checkbox visible', (
    tester,
  ) async {
    final controller = TasksController(repository: _FakeTareaRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () {},
            title: 'Pendientes',
            tareas: [_tarea()],
          ),
        ),
      ),
    );

    expect(find.text('Pendientes (1)'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
  });

  testWidgets('ListaTareasCategoria muestra estado vacio Material 3', (
    tester,
  ) async {
    final controller = TasksController(repository: _FakeTareaRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListaTareasCategoria(
            controller: controller,
            onRefresh: () {},
            title: 'Vencidas',
            tareas: const [],
          ),
        ),
      ),
    );

    expect(find.text('Sin tareas en Vencidas'), findsOneWidget);
    expect(find.byIcon(Icons.task_alt), findsOneWidget);
  });

  testWidgets('TareaForm usa acciones Material 3 y botones fecha/hora', (
    tester,
  ) async {
    final controller = TasksController(repository: _FakeTareaRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TareaForm(
            controller: controller,
            now: () => DateTime(2026, 5, 13, 8),
          ),
        ),
      ),
    );

    expect(find.text('Nueva tarea'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Guardar'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Cancelar'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.byKey(const Key('task-date-button')), findsOneWidget);
    expect(find.byKey(const Key('task-time-button')), findsOneWidget);
  });
}
