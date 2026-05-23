import 'package:agenda/core/widgets/agenda_empty_state.dart';
import 'package:agenda/core/widgets/agenda_section_header.dart';
import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/presentation/calendario_controller.dart';
import 'package:agenda/features/calendario/presentation/desktop.dart'
    as desktop;
import 'package:agenda/features/calendario/presentation/mobile.dart' as mobile;
import 'package:agenda/features/calendario/presentation/widgets/evento_list_item.dart';
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

CalendarioController _controller({List<Evento> eventos = const []}) {
  final controller = CalendarioController(
    repository: _FakeCalendarioRepository(),
  );
  controller.eventos = eventos;
  controller.selectedDate.value = DateTime(2026, 5, 13, 9);
  return controller;
}

Evento _evento({
  String titulo = 'Parcial',
  DateTime? inicio,
  DateTime? fin,
  String descripcion = 'Aula 2',
}) {
  final start = inicio ?? DateTime(2026, 5, 13, 10);
  return Evento(
    id: titulo,
    titulo: titulo,
    inicio: start,
    fin: fin ?? start.add(const Duration(hours: 1, minutes: 30)),
    descripcion: descripcion,
    color: Colors.teal.toARGB32(),
  );
}

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
  await tester.pumpAndSettle();
}

Finder _segmentedButton() {
  return find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString().startsWith('SegmentedButton'),
  );
}

void main() {
  testWidgets('Calendario mobile usa selector segmentado Material 3', (
    tester,
  ) async {
    await _pump(
      tester,
      mobile.MyMobileBody(
        controller: _controller(eventos: [_evento()]),
        onRefresh: () {},
      ),
    );

    expect(find.text('Calendario'), findsOneWidget);
    expect(_segmentedButton(), findsOneWidget);
    expect(find.text('Hoy'), findsOneWidget);
    expect(find.byType(TabBar), findsNothing);
  });

  testWidgets('Calendario mobile muestra panel diario con vacio Material 3', (
    tester,
  ) async {
    await _pump(
      tester,
      mobile.MyMobileBody(controller: _controller(), onRefresh: () {}),
    );

    await tester.tap(find.text('Dia'));
    await tester.pumpAndSettle();

    expect(find.byType(AgendaSectionHeader), findsOneWidget);
    expect(find.text('Eventos del dia (0)'), findsOneWidget);
    expect(find.byType(AgendaEmptyState), findsOneWidget);
    expect(find.text('No hay eventos este dia'), findsOneWidget);
  });

  testWidgets('Calendario desktop usa panel secundario Material 3', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(
      tester,
      desktop.MyDesktopBody(
        controller: _controller(eventos: [_evento()]),
        onRefresh: () {},
      ),
    );

    expect(find.byType(AgendaSectionHeader), findsOneWidget);
    expect(find.text('Eventos del dia (1)'), findsOneWidget);
    expect(find.text('Hoy'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsWidgets);
    expect(find.byType(AgendaEmptyState), findsNothing);
  });

  testWidgets('EventoListItem muestra metadatos Material 3', (tester) async {
    await _pump(tester, EventoListItem(evento: _evento()));

    expect(find.byIcon(Icons.event_outlined), findsOneWidget);
    expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    expect(find.byIcon(Icons.notes_outlined), findsOneWidget);
    expect(find.text('10:00 - 11:30'), findsOneWidget);
    expect(find.text('Aula 2'), findsOneWidget);
  });
}
