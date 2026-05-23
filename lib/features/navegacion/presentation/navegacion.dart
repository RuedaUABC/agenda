import 'package:agenda/features/calendario/presentation/calendario.dart';
import 'package:agenda/features/configuracion/presentation/settings.dart';
import 'package:agenda/features/horario/presentation/horario.dart';
import 'package:agenda/features/tareas/presentation/tareas.dart';
import 'package:flutter/material.dart';

class AgendaNavigation extends StatefulWidget {
  final List<Widget>? pages;

  const AgendaNavigation({super.key, this.pages});

  @override
  State<AgendaNavigation> createState() => _AgendaNavigationState();
}

class _AgendaNavigationState extends State<AgendaNavigation> {
  int _currentIndex = 0;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.task_alt), label: 'Tareas'),
    NavigationDestination(icon: Icon(Icons.schedule), label: 'Horario'),
    NavigationDestination(
      icon: Icon(Icons.calendar_month),
      label: 'Calendario',
    ),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Ajustes'),
  ];

  List<Widget> get _pages {
    return widget.pages ??
        const [TasksPage(), HorarioPage(), CalendarioPage(), SettingsPage()];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= 600;
    final extendedRail = width >= 1024;
    final body = SafeArea(
      child: IndexedStack(index: _currentIndex, children: _pages),
    );

    if (!useRail) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: _destinations,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: extendedRail,
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: _destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      icon: destination.icon,
                      label: Text(destination.label),
                    ),
                  )
                  .toList(),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
