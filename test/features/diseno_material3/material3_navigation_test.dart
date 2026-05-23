import 'package:agenda/features/navegacion/presentation/navegacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

List<Widget> _pages() {
  return const [
    Center(child: Text('Tareas test')),
    Center(child: Text('Horario test')),
    Center(child: Text('Calendario test')),
    Center(child: Text('Ajustes test')),
  ];
}

Future<void> _pumpAtWidth(WidgetTester tester, double width) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 800);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: AgendaNavigation(pages: _pages())));
}

void main() {
  testWidgets('AgendaNavigation usa NavigationBar en pantallas moviles', (
    tester,
  ) async {
    await _pumpAtWidth(tester, 390);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(IndexedStack), findsOneWidget);
  });

  testWidgets('AgendaNavigation usa NavigationRail en pantallas amplias', (
    tester,
  ) async {
    await _pumpAtWidth(tester, 800);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('AgendaNavigation extiende el rail en escritorio', (
    tester,
  ) async {
    await _pumpAtWidth(tester, 1200);

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

    expect(rail.extended, isTrue);
  });
}
