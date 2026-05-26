import 'package:agenda/features/horario/domain/clase.dart';
import 'package:agenda/features/horario/presentation/horario.dart';
import 'package:agenda/features/horario/presentation/horario_controller.dart';
import 'package:agenda/features/horario/presentation/widgets/clase_list_item.dart';
import 'package:agenda/features/horario/repository/horario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHorarioRepository implements HorarioRepository {
  final List<Clase> stored;

  _FakeHorarioRepository([List<Clase>? initial]) : stored = initial ?? [];

  @override
  Future<void> addClase(Clase clase) async {
    stored.add(clase);
  }

  @override
  Future<void> deleteClase(String id) async {
    stored.removeWhere((clase) => clase.id == id);
  }

  @override
  Future<List<Clase>> fetchClases() async => List<Clase>.from(stored);

  @override
  Future<void> updateClase(Clase clase) async {
    final index = stored.indexWhere((item) => item.id == clase.id);
    if (index == -1) {
      stored.add(clase);
    } else {
      stored[index] = clase;
    }
  }
}

void main() {
  testWidgets('ClaseListItem muestra materia, aula y rango horario', (
    tester,
  ) async {
    final clase = Clase(
      id: '1',
      materia: 'Programacion',
      inicio: DateTime(2026, 5, 13, 8),
      fin: DateTime(2026, 5, 13, 10, 30),
      aula: 'Lab 3',
      color: Colors.indigo.toARGB32(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ClaseListItem(clase: clase)),
      ),
    );

    expect(find.text('Programacion'), findsOneWidget);
    expect(find.textContaining('Lab 3'), findsOneWidget);
    expect(find.textContaining('08:00 - 10:30'), findsOneWidget);
    expect(find.byIcon(Icons.school_outlined), findsOneWidget);
    expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    expect(find.byIcon(Icons.meeting_room_outlined), findsOneWidget);
  });

  testWidgets(
    'ClaseListItem confirma eliminacion cuando la preferencia esta activa',
    (tester) async {
      var deleted = false;
      final clase = Clase(
        id: '1',
        materia: 'Programacion',
        inicio: DateTime(2026, 5, 13, 8),
        fin: DateTime(2026, 5, 13, 10),
        aula: 'Lab 3',
        color: Colors.indigo.toARGB32(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClaseListItem(
              clase: clase,
              onDelete: () async => deleted = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Eliminar clase Programacion'));
      await tester.pumpAndSettle();

      expect(find.text('Eliminar clase'), findsOneWidget);
      expect(deleted, isFalse);

      await tester.tap(find.widgetWithText(TextButton, 'Eliminar'));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
    },
  );

  testWidgets(
    'ClaseListItem elimina sin dialogo cuando la preferencia esta desactivada',
    (tester) async {
      var deleted = false;
      final clase = Clase(
        id: '1',
        materia: 'Programacion',
        inicio: DateTime(2026, 5, 13, 8),
        fin: DateTime(2026, 5, 13, 10),
        aula: 'Lab 3',
        color: Colors.indigo.toARGB32(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClaseListItem(
              clase: clase,
              confirmBeforeDelete: false,
              onDelete: () async => deleted = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Eliminar clase Programacion'));
      await tester.pumpAndSettle();

      expect(find.text('Eliminar clase'), findsNothing);
      expect(deleted, isTrue);
    },
  );

  testWidgets('HorarioPage permite deshacer eliminacion de clase', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1100, 800);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    final clase = Clase(
      id: '1',
      materia: 'Programacion',
      inicio: DateTime(2026, 5, 13, 8),
      fin: DateTime(2026, 5, 13, 10),
      aula: 'Lab 3',
      color: Colors.indigo.toARGB32(),
    );
    final repo = _FakeHorarioRepository([clase]);
    final controller = HorarioController(repository: repo)
      ..selectedDate.value = DateTime(2026, 5, 13);
    await controller.loadClases();

    await tester.pumpWidget(
      MaterialApp(home: HorarioPage(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Eliminar clase Programacion'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(repo.stored, isEmpty);
    expect(find.text('Clase eliminada'), findsOneWidget);
    expect(find.text('Deshacer'), findsOneWidget);

    await tester.tap(find.text('Deshacer'));
    await tester.pumpAndSettle();

    expect(repo.stored.single.materia, 'Programacion');
  });
}
