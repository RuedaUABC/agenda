import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/presentation/calendario.dart';
import 'package:agenda/features/calendario/presentation/calendario_controller.dart';
import 'package:agenda/features/calendario/presentation/desktop.dart'
    as desktop;
import 'package:agenda/features/calendario/presentation/mobile.dart' as mobile;
import 'package:agenda/features/calendario/repository/calendario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCalendarioRepository implements CalendarioRepository {
  final List<Evento> stored;

  _FakeCalendarioRepository([List<Evento>? initial]) : stored = initial ?? [];

  @override
  Future<void> addEvento(Evento evento) async {
    stored.add(evento);
  }

  @override
  Future<void> deleteEvento(String id) async {
    stored.removeWhere((evento) => evento.id == id);
  }

  @override
  Future<List<Evento>> fetchEventos() async => List<Evento>.from(stored);

  @override
  Future<void> programarNotificacionEvento(String eventoId) async {}

  @override
  Future<void> updateEvento(Evento evento) async {
    final index = stored.indexWhere((item) => item.id == evento.id);
    if (index == -1) {
      stored.add(evento);
    } else {
      stored[index] = evento;
    }
  }
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
  testWidgets(
    'CalendarioPage abre formulario desde boton agregar y crea evento',
    (tester) async {
      final repo = _FakeCalendarioRepository();
      final controller = CalendarioController(repository: repo)
        ..selectedDate.value = DateTime(2026, 5, 13);

      await tester.pumpWidget(
        MaterialApp(home: CalendarioPage(controller: controller)),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Nuevo evento'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'Tutoria');
      await tester.tap(find.text('Guardar evento'));
      await tester.pumpAndSettle();

      expect(repo.stored.single.titulo, 'Tutoria');
      expect(repo.stored.single.inicio, DateTime(2026, 5, 13, 8));
    },
  );

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

    await tester.tap(find.text('Dia'));
    await tester.pumpAndSettle();

    expect(find.text('Eventos del dia (1)'), findsOneWidget);
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

    await tester.tap(find.text('Dia'));
    await tester.pumpAndSettle();

    expect(find.text('No hay eventos este dia'), findsOneWidget);
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

    expect(find.text('Eventos del dia (1)'), findsOneWidget);
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

    expect(find.text('No hay eventos este dia'), findsOneWidget);
  });

  testWidgets('Calendario desktop permite editar evento con tap', (
    tester,
  ) async {
    Evento? selectedEvento;
    final evento = _evento(titulo: 'Parcial', descripcion: 'Aula 2');
    final controller = _controller([evento], DateTime(2026, 5, 13));

    await tester.pumpWidget(
      MaterialApp(
        home: desktop.MyDesktopBody(
          controller: controller,
          onRefresh: () {},
          onEditEvento: (evento) => selectedEvento = evento,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Parcial'));
    await tester.pump();

    expect(selectedEvento, evento);
  });

  testWidgets('Calendario desktop confirma eliminacion desde accion visible', (
    tester,
  ) async {
    Evento? deletedEvento;
    final evento = _evento(titulo: 'Parcial', descripcion: 'Aula 2');
    final controller = _controller([evento], DateTime(2026, 5, 13));

    await tester.pumpWidget(
      MaterialApp(
        home: desktop.MyDesktopBody(
          controller: controller,
          onRefresh: () {},
          onDeleteEvento: (evento) async => deletedEvento = evento,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Eliminar evento Parcial'));
    await tester.pumpAndSettle();

    expect(find.text('Eliminar evento'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(deletedEvento, evento);
  });
}
