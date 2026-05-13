import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:agenda/features/tareas/presentation/taskcontroller.dart';
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
    tareas.removeWhere((tarea) => tarea.id == id);
  }

  @override
  Future<List<Tarea>> fetchTareas() async => List<Tarea>.from(tareas);

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

    expect(find.text('Nueva Tarea'), findsOneWidget);
    expect(find.textContaining('requerido'), findsOneWidget);
  });
}
