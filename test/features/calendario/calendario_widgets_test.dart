import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/presentation/calendario_controller.dart';
import 'package:agenda/features/calendario/presentation/desktop.dart'
    as desktop;
import 'package:agenda/features/calendario/presentation/mobile.dart' as mobile;
import 'package:agenda/features/calendario/repository/calendario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCalendarioRepository implements CalendarioRepository {
  @override
  Future<void> addEvento(Evento evento) async {}

  @override
  Future<void> deleteEvento(String id) async {}

  @override
  Future<List<Evento>> fetchEventos() async => [];

  @override
  Future<void> updateEvento(Evento evento) async {}
}

Evento _evento({
  required String titulo,
  DateTime? inicio,
  DateTime? fin,
  String descripcion = 'Preparar materiales',
}) {
  final start = inicio ?? DateTime(2026, 5, 13, 10);
  return Evento(
    id: titulo,
    titulo: titulo,
    inicio: start,
    fin: fin ?? start.add(const Duration(hours: 1)),
    descripcion: descripcion,
    color: Colors.teal.toARGB32(),
  );
}

CalendarioController _controller(List<Evento> eventos, DateTime selectedDate) {
  return CalendarioController(repository: _FakeCalendarioRepository())
    ..eventos = eventos
    ..selectedDate.value = selectedDate;
}

void main() {
  testWidgets('Calendario mobile muestra eventos del dia seleccionado', (
    tester,
  ) async {
    final controller = _controller([
      _evento(titulo: 'Parcial', descripcion: 'Aula 2'),
    ], DateTime(2026, 5, 13));

    await tester.pumpWidget(
      MaterialApp(
        home: mobile.MyMobileBody(controller: controller, onRefresh: () {}),
      ),
    );

    await tester.tap(find.text('Eventos'));
    await tester.pumpAndSettle();

    expect(find.text('Eventos del 13/5'), findsOneWidget);
    expect(find.text('Parcial'), findsOneWidget);
    expect(find.text('Aula 2'), findsOneWidget);
  });

  testWidgets('Calendario mobile muestra estado vacio sin eventos', (
    tester,
  ) async {
    final controller = _controller([], DateTime(2026, 5, 13));

    await tester.pumpWidget(
      MaterialApp(
        home: mobile.MyMobileBody(controller: controller, onRefresh: () {}),
      ),
    );

    await tester.tap(find.text('Eventos'));
    await tester.pumpAndSettle();

    expect(find.textContaining('No hay eventos'), findsOneWidget);
  });

  testWidgets('Calendario desktop lista eventos que duran varios dias', (
    tester,
  ) async {
    final controller = _controller([
      _evento(
        titulo: 'Congreso',
        inicio: DateTime(2026, 5, 12, 9),
        fin: DateTime(2026, 5, 14, 18),
        descripcion: 'Dia intermedio',
      ),
    ], DateTime(2026, 5, 13));

    await tester.pumpWidget(
      MaterialApp(
        home: desktop.MyDesktopBody(controller: controller, onRefresh: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Eventos'), findsOneWidget);
    expect(find.text('13/5/2026'), findsOneWidget);
    expect(find.text('Congreso'), findsOneWidget);
    expect(find.text('Dia intermedio'), findsOneWidget);
  });

  testWidgets('Calendario desktop muestra estado vacio del dia seleccionado', (
    tester,
  ) async {
    final controller = _controller([
      _evento(titulo: 'Otro dia', inicio: DateTime(2026, 5, 14)),
    ], DateTime(2026, 5, 13));

    await tester.pumpWidget(
      MaterialApp(
        home: desktop.MyDesktopBody(controller: controller, onRefresh: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sin eventos para hoy'), findsOneWidget);
  });
}
