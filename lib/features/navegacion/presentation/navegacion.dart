import 'package:agenda/features/calendario/presentation/calendario.dart';
import 'package:agenda/features/configuracion/presentation/settings.dart';
import 'package:agenda/features/configuracion/presentation/settings_controller.dart';
import 'package:agenda/features/horario/presentation/horario.dart';
import 'package:agenda/features/tareas/presentation/tareas.dart';
import 'package:flutter/material.dart';

class AgendaNavigation extends StatefulWidget {
  final List<Widget>? pages;
  final SettingsController? settingsController;
  final int? initialIndex;

  const AgendaNavigation({
    super.key,
    this.pages,
    this.settingsController,
    this.initialIndex,
  });

  @override
  State<AgendaNavigation> createState() => _AgendaNavigationState();
}

class _AgendaNavigationState extends State<AgendaNavigation> {
  late int _currentIndex = widget.initialIndex ?? 0;
  bool _hasUserSelected = false;

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
        [
          TasksPage(settingsController: widget.settingsController),
          HorarioPage(settingsController: widget.settingsController),
          CalendarioPage(settingsController: widget.settingsController),
          SettingsPage(controller: widget.settingsController),
        ];
  }

  @override
  void didUpdateWidget(covariant AgendaNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextIndex = widget.initialIndex;
    if (!_hasUserSelected &&
        nextIndex != null &&
        nextIndex != oldWidget.initialIndex) {
      _currentIndex = nextIndex;
    }
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
            setState(() {
              _hasUserSelected = true;
              _currentIndex = index;
            });
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
                setState(() {
                  _hasUserSelected = true;
                  _currentIndex = index;
                });
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
