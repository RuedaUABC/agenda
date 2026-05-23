import 'package:agenda/core/widgets/agenda_empty_state.dart';
import 'package:agenda/core/widgets/agenda_section_header.dart';
import 'package:agenda/features/horario/domain/clase.dart';
import 'package:agenda/features/horario/presentation/desktop.dart';
import 'package:agenda/features/horario/presentation/horario_controller.dart';
import 'package:agenda/features/horario/presentation/mobile.dart';
import 'package:agenda/features/horario/presentation/widgets/clase_list_item.dart';
import 'package:agenda/features/horario/repository/horario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHorarioRepository implements HorarioRepository {
  @override
  Future<void> addClase(Clase clase) async {}

  @override
  Future<void> deleteClase(String id) async {}

  @override
  Future<List<Clase>> fetchClases() async => [];

  @override
  Future<void> updateClase(Clase clase) async {}
}

HorarioController _controller({List<Clase> clases = const []}) {
  final controller = HorarioController(repository: _FakeHorarioRepository());
  controller.clases = clases;
  controller.selectedDate.value = DateTime(2026, 5, 13, 9);
  return controller;
}

Clase _clase({
  String materia = 'Programacion',
  DateTime? inicio,
  DateTime? fin,
}) {
  final start = inicio ?? DateTime(2026, 5, 13, 8);
  return Clase(
    id: 'clase-1',
    materia: materia,
    aula: 'Lab 3',
    inicio: start,
    fin: fin ?? start.add(const Duration(hours: 2)),
    color: Colors.indigo.toARGB32(),
  );
}

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Horario mobile usa selector segmentado Material 3', (
    tester,
  ) async {
    await _pump(
      tester,
      MyMobileBody(
        controller: _controller(clases: [_clase()]),
        onRefresh: () {},
      ),
    );

    expect(find.text('Horario'), findsOneWidget);
    expect(find.byType(SegmentedButton<HorarioMobileView>), findsOneWidget);
    expect(find.text('Hoy'), findsOneWidget);
    expect(find.byType(TabBar), findsNothing);
  });

  testWidgets('Horario mobile muestra lista diaria con encabezado y vacio', (
    tester,
  ) async {
    await _pump(
      tester,
      MyMobileBody(controller: _controller(), onRefresh: () {}),
    );

    await tester.tap(find.text('Dia'));
    await tester.pumpAndSettle();

    expect(find.byType(AgendaSectionHeader), findsOneWidget);
    expect(find.text('Clases del dia (0)'), findsOneWidget);
    expect(find.byType(AgendaEmptyState), findsOneWidget);
    expect(find.text('No hay clases este dia'), findsOneWidget);
  });

  testWidgets('Horario desktop usa panel secundario Material 3', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(
      tester,
      MyDesktopBody(
        controller: _controller(clases: [_clase()]),
        onRefresh: () {},
      ),
    );

    expect(find.byType(AgendaSectionHeader), findsOneWidget);
    expect(find.text('Clases del dia (1)'), findsOneWidget);
    expect(find.text('Hoy'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsWidgets);
    expect(find.byType(AgendaEmptyState), findsNothing);
  });

  testWidgets('ClaseListItem muestra metadatos Material 3 sin mojibake', (
    tester,
  ) async {
    await _pump(tester, ClaseListItem(clase: _clase()));

    expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    expect(find.byIcon(Icons.meeting_room_outlined), findsOneWidget);
    expect(find.text('08:00 - 10:00'), findsOneWidget);
    expect(find.text('Lab 3'), findsOneWidget);
    expect(
      find.textContaining(String.fromCharCodes([0x00E2, 0x20AC, 0x00A2])),
      findsNothing,
    );
  });
}
