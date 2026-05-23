import 'package:agenda/features/tareas/presentation/taskcontroller.dart';
import 'package:agenda/features/tareas/presentation/widgets/tareas_filter_bar.dart';
import 'package:agenda/features/tareas/repository/tarea_repository.dart';
import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTareaRepository implements TareaRepository {
  @override
  Future<void> addTarea(Tarea tarea) async {}

  @override
  Future<void> deleteTarea(String id) async {}

  @override
  Future<void> deleteTareaDefinitiva(String id) async {}

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

void main() {
  testWidgets('TareasFilterBar muestra solo filtros de estado Material 3', (
    tester,
  ) async {
    final controller = TasksController(repository: _FakeTareaRepository());
    var refreshCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TareasFilterBar(
            controller: controller,
            onChanged: () => refreshCount++,
          ),
        ),
      ),
    );

    expect(find.byType(SearchBar), findsNothing);
    expect(find.byType(DropdownMenu<TaskDateFilter>), findsNothing);
    expect(find.byType(SegmentedButton<TaskStatusFilter>), findsOneWidget);

    await tester.tap(find.text('Pendientes'));
    await tester.pumpAndSettle();

    expect(controller.statusFilter, TaskStatusFilter.pendientes);
    expect(controller.searchQuery, isEmpty);
    expect(controller.dateFilter, TaskDateFilter.todas);
    expect(refreshCount, 1);
  });
}
