import 'dart:async';

import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/presentation/widgets/evento_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Evento _evento({
  String id = 'evt-1',
  String titulo = 'Parcial',
  DateTime? inicio,
  DateTime? fin,
  String descripcion = 'Aula 2',
}) {
  final start = inicio ?? DateTime(2026, 5, 13, 8);
  return Evento(
    id: id,
    titulo: titulo,
    inicio: start,
    fin: fin ?? start.add(const Duration(hours: 1)),
    descripcion: descripcion,
  );
}

void main() {
  testWidgets('EventoForm valida que el titulo sea obligatorio', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventoForm(
            initialDate: DateTime(2026, 5, 13),
            eventos: const [],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Guardar evento'));
    await tester.pump();

    expect(find.text('Ingresa el titulo del evento'), findsOneWidget);
  });

  testWidgets('EventoForm crea evento normalizado con horario por defecto', (
    tester,
  ) async {
    Evento? savedEvento;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventoForm(
            initialDate: DateTime(2026, 5, 13),
            eventos: const [],
            onSave: (evento) => savedEvento = evento,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '  Seminario  ');
    await tester.enterText(find.byType(TextFormField).at(1), '  Aula 3  ');
    await tester.tap(find.text('Guardar evento'));
    await tester.pump();

    expect(savedEvento, isNotNull);
    expect(savedEvento!.titulo, 'Seminario');
    expect(savedEvento!.descripcion, 'Aula 3');
    expect(savedEvento!.inicio, DateTime(2026, 5, 13, 8));
    expect(savedEvento!.fin, DateTime(2026, 5, 13, 9));
    expect(savedEvento!.color, Evento.defaultColor);
  });

  testWidgets('EventoForm edita evento conservando su id', (tester) async {
    Evento? savedEvento;
    final existing = _evento(id: 'evt-123', titulo: 'Parcial');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventoForm(
            initialDate: DateTime(2026, 5, 13),
            evento: existing,
            eventos: [existing],
            onSave: (evento) => savedEvento = evento,
          ),
        ),
      ),
    );

    expect(find.text('Editar evento'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Parcial final');
    await tester.tap(find.text('Actualizar evento'));
    await tester.pump();

    expect(savedEvento, isNotNull);
    expect(savedEvento!.id, 'evt-123');
    expect(savedEvento!.titulo, 'Parcial final');
  });

  testWidgets('EventoForm advierte antes de guardar eventos superpuestos', (
    tester,
  ) async {
    Evento? savedEvento;
    final existing = _evento(
      id: 'evt-1',
      inicio: DateTime(2026, 5, 13, 8, 30),
      fin: DateTime(2026, 5, 13, 9, 30),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventoForm(
            initialDate: DateTime(2026, 5, 13),
            eventos: [existing],
            onSave: (evento) => savedEvento = evento,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Choque');
    await tester.tap(find.text('Guardar evento'));
    await tester.pumpAndSettle();

    expect(savedEvento, isNull);
    expect(find.text('Evento superpuesto'), findsOneWidget);
    expect(find.textContaining('Parcial'), findsOneWidget);
    expect(find.textContaining('08:30 - 09:30'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Guardar de todos modos'));
    await tester.pump();

    expect(savedEvento, isNotNull);
    expect(savedEvento!.titulo, 'Choque');
  });

  testWidgets('EventoForm mantiene estado Guardando mientras persiste', (
    tester,
  ) async {
    final completer = Completer<void>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventoForm(
            initialDate: DateTime(2026, 5, 13),
            eventos: const [],
            onSave: (_) => completer.future,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Tutoria');
    await tester.tap(find.text('Guardar evento'));
    await tester.pump();

    expect(find.text('Guardando evento...'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Guardando evento...'),
    );
    expect(button.onPressed, isNull);

    completer.complete();
    await tester.pump();
  });
}
