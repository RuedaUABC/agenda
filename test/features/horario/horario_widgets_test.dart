import 'package:agenda/features/horario/domain/clase.dart';
import 'package:agenda/features/horario/presentation/widgets/clase_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
