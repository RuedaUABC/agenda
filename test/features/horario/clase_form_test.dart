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
}
