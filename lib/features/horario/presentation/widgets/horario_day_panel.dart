import 'package:flutter/material.dart';

import '../../../../core/widgets/agenda_empty_state.dart';
import '../../../../core/widgets/agenda_section_header.dart';
import '../../../configuracion/preferences_helper.dart';
import '../../domain/clase.dart';
import '../horario_controller.dart';
import 'clase_list_item.dart';

class HorarioDayPanel extends StatelessWidget {
  final HorarioController controller;
  final VoidCallback onRefresh;
  final WeekStartPreference weekStart;
  final VisualDensity visualDensity;
  final Future<void> Function(Clase clase)? onDeleteClase;
  final bool confirmDestructiveActions;

  const HorarioDayPanel({
    super.key,
    required this.controller,
    required this.onRefresh,
    this.weekStart = WeekStartPreference.lunes,
    this.visualDensity = VisualDensity.standard,
    this.onDeleteClase,
    this.confirmDestructiveActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: controller.selectedDate,
      builder: (context, date, _) {
        final clases = _classesFor(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AgendaSectionHeader(
              title: 'Clases del dia',
              count: clases.length,
              trailing: TextButton.icon(
                onPressed: () {
                  controller.selectedDate.value = DateTime.now();
                  onRefresh();
                },
                icon: const Icon(Icons.today_outlined),
                label: const Text('Hoy'),
              ),
            ),
            _WeekdaySelector(
              selectedDate: date,
              weekStart: weekStart,
              onSelected: (selectedDate) {
                controller.selectedDate.value = selectedDate;
                onRefresh();
              },
            ),
            Expanded(
              child: clases.isEmpty
                  ? const Center(
                      child: AgendaEmptyState(
                        icon: Icons.event_busy_outlined,
                        title: 'No hay clases este dia',
                        description: 'Selecciona otro dia o agrega una clase.',
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: clases.length,
                      separatorBuilder: (_, _) => SizedBox(
                        height: visualDensity == VisualDensity.compact ? 4 : 8,
                      ),
                      itemBuilder: (context, index) {
                        return ClaseListItem(
                          clase: clases[index],
                          visualDensity: visualDensity,
                          confirmBeforeDelete: confirmDestructiveActions,
                          onDelete: onDeleteClase == null
                              ? null
                              : () => onDeleteClase!(clases[index]),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  List<Clase> _classesFor(DateTime date) {
    final filtered = controller.clases
        .where((clase) => clase.inicio.weekday == date.weekday)
        .toList();
    filtered.sort((a, b) => a.inicio.compareTo(b.inicio));
    return filtered;
  }
}

class _WeekdaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;
  final WeekStartPreference weekStart;

  const _WeekdaySelector({
    required this.selectedDate,
    required this.onSelected,
    required this.weekStart,
  });

  @override
  Widget build(BuildContext context) {
    final startOfWeek = selectedDate.subtract(
      Duration(days: _daysFromWeekStart(selectedDate.weekday)),
    );
    final days = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final day in days) ...[
            ChoiceChip(
              label: Text('${_weekdayLabel(day.weekday)} ${day.day}'),
              selected: day.weekday == selectedDate.weekday,
              onSelected: (_) => onSelected(day),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  int _daysFromWeekStart(int weekday) {
    final start = weekStart == WeekStartPreference.domingo
        ? DateTime.sunday
        : DateTime.monday;
    return (weekday - start) % DateTime.daysPerWeek;
  }

  String _weekdayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lun';
      case DateTime.tuesday:
        return 'Mar';
      case DateTime.wednesday:
        return 'Mie';
      case DateTime.thursday:
        return 'Jue';
      case DateTime.friday:
        return 'Vie';
      case DateTime.saturday:
        return 'Sab';
      case DateTime.sunday:
        return 'Dom';
      default:
        return 'Dia';
    }
  }
}
