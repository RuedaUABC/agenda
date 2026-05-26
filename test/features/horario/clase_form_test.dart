import 'dart:async';

import 'package:agenda/features/horario/domain/clase.dart';
import 'package:agenda/features/horario/presentation/widgets/clase_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ClaseForm valida que la materia sea obligatoria', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ClaseForm(initialDate: DateTime(2026, 5, 13))),
      ),
    );

    await tester.tap(find.text('Guardar clase semanal'));
    await tester.pump();

    expect(find.text('Ingresa la materia'), findsOneWidget);
  });

  testWidgets('ClaseForm crea una clase semanal con regla BYDAY valida', (
    tester,
  ) async {
    Clase? savedClase;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClaseForm(
            initialDate: DateTime(2026, 5, 13),
            onSave: (clase) => savedClase = clase,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Programacion');
    await tester.enterText(find.byType(TextFormField).at(1), 'Lab 3');
    await tester.tap(find.text('Guardar clase semanal'));
    await tester.pump();

    expect(savedClase, isNotNull);
    expect(savedClase!.materia, 'Programacion');
    expect(savedClase!.aula, 'Lab 3');
    expect(savedClase!.inicio, DateTime(2026, 5, 13, 8));
    expect(savedClase!.fin, DateTime(2026, 5, 13, 9));
    expect(savedClase!.recurrenceRule, 'FREQ=WEEKLY;INTERVAL=1;BYDAY=WE');
  });

  testWidgets('ClaseForm valida longitudes maximas de materia y aula', (
    tester,
  ) async {
    Clase? savedClase;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClaseForm(
            initialDate: DateTime(2026, 5, 13),
            onSave: (clase) => savedClase = clase,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'a' * 121);
    await tester.enterText(find.byType(TextFormField).at(1), 'b' * 81);
    await tester.tap(find.text('Guardar clase semanal'));
    await tester.pump();

    expect(
      find.text('La materia no puede superar 120 caracteres'),
      findsOneWidget,
    );
    expect(find.text('El aula no puede superar 80 caracteres'), findsOneWidget);
    expect(savedClase, isNull);
  });

  testWidgets('ClaseForm impide guardar clase con conflicto de horario', (
    tester,
  ) async {
    Clase? savedClase;
    final existing = Clase(
      id: 'clase-1',
      materia: 'Matematicas',
      aula: 'Aula 1',
      inicio: DateTime(2026, 5, 13, 8, 30),
      fin: DateTime(2026, 5, 13, 9, 30),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClaseForm(
            initialDate: DateTime(2026, 5, 13),
            clases: [existing],
            onSave: (clase) => savedClase = clase,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Fisica');
    await tester.enterText(find.byType(TextFormField).at(1), 'Lab 1');
    await tester.tap(find.text('Guardar clase semanal'));
    await tester.pump();

    expect(savedClase, isNull);
    expect(find.textContaining('Matematicas'), findsOneWidget);
    expect(find.textContaining('08:30 - 09:30'), findsOneWidget);
  });

  testWidgets('ClaseForm muestra estado Guardando mientras persiste', (
    tester,
  ) async {
    final completer = Completer<void>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClaseForm(
            initialDate: DateTime(2026, 5, 13),
            onSave: (_) => completer.future,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Fisica');
    await tester.tap(find.text('Guardar clase semanal'));
    await tester.pump();

    expect(find.text('Guardando clase...'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Guardando clase...'),
    );
    expect(button.onPressed, isNull);

    completer.complete();
    await tester.pump();
  });
}
