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
  Future<void> deleteTarea(String id) async {}

  @override
  Future<void> deleteTareaDefinitiva(String id) async {
    tareas.removeWhere((tarea) => tarea.id == id);
  }

  @override
  Future<List<Tarea>> fetchTareas() async => List<Tarea>.from(tareas);

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

TasksController _controller(_FakeTareaRepository repo) {
  return TasksController(repository: repo);
}

void main() {
  testWidgets('TareaForm rechaza titulo compuesto solo por espacios', (
    tester,
  ) async {
    final repo = _FakeTareaRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TareaForm(
            controller: _controller(repo),
            now: () => DateTime(2026, 5, 13, 8),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '   ');
    await tester.tap(find.text('Guardar'));
    await tester.pump();

    expect(find.text('El titulo es requerido'), findsOneWidget);
    expect(repo.tareas, isEmpty);
  });

  testWidgets('TareaForm normaliza textos antes de guardar', (tester) async {
    final repo = _FakeTareaRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TareaForm(
            controller: _controller(repo),
            now: () => DateTime(2026, 5, 13, 8),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '  Ensayo  ');
    await tester.enterText(find.byType(TextFormField).at(1), '  Literatura  ');
    await tester.enterText(find.byType(TextFormField).at(2), '  Borrador  ');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(repo.tareas.single.titulo, 'Ensayo');
    expect(repo.tareas.single.asignatura, 'Literatura');
    expect(repo.tareas.single.descripcion, 'Borrador');
  });

  testWidgets('TareaForm valida longitudes maximas', (tester) async {
    final repo = _FakeTareaRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TareaForm(
            controller: _controller(repo),
            now: () => DateTime(2026, 5, 13, 8),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'a' * 121);
    await tester.enterText(find.byType(TextFormField).at(1), 'b' * 81);
    await tester.enterText(find.byType(TextFormField).at(2), 'c' * 501);
    await tester.tap(find.text('Guardar'));
    await tester.pump();

    expect(
      find.text('El titulo no puede superar 120 caracteres'),
      findsOneWidget,
    );
    expect(
      find.text('La asignatura no puede superar 80 caracteres'),
      findsOneWidget,
    );
    expect(
      find.text('La descripcion no puede superar 500 caracteres'),
      findsOneWidget,
    );
    expect(repo.tareas, isEmpty);
  });

  testWidgets('TareaForm pide confirmacion cuando la fecha esta en el pasado', (
    tester,
  ) async {
    final repo = _FakeTareaRepository()
      ..tareas.add(
        Tarea(
          id: '1',
          titulo: 'Entrega',
          asignatura: 'Literatura',
          descripcion: '',
          fecha: DateTime(2026, 5, 13, 8),
          completada: false,
        ),
      );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TareaForm(
            controller: _controller(repo),
            tarea: repo.tareas.single,
            now: () => DateTime(2026, 5, 13, 10),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Fecha en el pasado'), findsOneWidget);
    expect(repo.tareas, hasLength(1));

    await tester.tap(find.widgetWithText(TextButton, 'Guardar de todos modos'));
    await tester.pumpAndSettle();

    expect(repo.tareas.single.titulo, 'Entrega');
  });
}
