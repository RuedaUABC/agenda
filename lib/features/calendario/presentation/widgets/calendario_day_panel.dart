import 'package:flutter/material.dart';

import '../../../../core/widgets/agenda_empty_state.dart';
import '../../../../core/widgets/agenda_section_header.dart';
import '../../../configuracion/preferences_helper.dart';
import '../../domain/evento.dart';
import '../calendario_controller.dart';
import 'evento_list_item.dart';

class CalendarioDayPanel extends StatelessWidget {
  final CalendarioController controller;
  final VoidCallback onRefresh;
  final ValueChanged<Evento>? onEditEvento;
  final Future<void> Function(Evento evento)? onDeleteEvento;
  final VoidCallback? onCreateEvento;
  final WeekStartPreference weekStart;
  final VisualDensity visualDensity;
  final bool confirmDestructiveActions;

  const CalendarioDayPanel({
    super.key,
    required this.controller,
    required this.onRefresh,
    this.onEditEvento,
    this.onDeleteEvento,
    this.onCreateEvento,
    this.weekStart = WeekStartPreference.lunes,
    this.visualDensity = VisualDensity.standard,
    this.confirmDestructiveActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: controller.selectedDate,
      builder: (context, date, _) {
        final eventos = _eventsFor(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AgendaSectionHeader(
              title: 'Eventos del dia',
              count: eventos.length,
              trailing: TextButton.icon(
                onPressed: () {
                  controller.selectedDate.value = DateTime.now();
                  onRefresh();
                },
                icon: const Icon(Icons.today_outlined),
                label: const Text('Hoy'),
              ),
            ),
            _DateSelector(
              selectedDate: date,
              weekStart: weekStart,
              onSelected: (selectedDate) {
                controller.selectedDate.value = selectedDate;
                onRefresh();
              },
            ),
            Expanded(
              child: eventos.isEmpty
                  ? Center(
                      child: AgendaEmptyState(
                        icon: Icons.event_busy_outlined,
                        title: 'No hay eventos este dia',
                        description: 'Selecciona otra fecha o crea un evento.',
                        action: onCreateEvento == null
                            ? null
                            : FilledButton.icon(
                                onPressed: onCreateEvento,
                                icon: const Icon(Icons.add),
                                label: const Text('Crear evento'),
                              ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: eventos.length,
                      separatorBuilder: (_, _) => SizedBox(
                        height: visualDensity == VisualDensity.compact ? 4 : 8,
                      ),
                      itemBuilder: (context, index) {
                        final evento = eventos[index];
                        return EventoListItem(
                          evento: evento,
                          margin: EdgeInsets.zero,
                          visualDensity: visualDensity,
                          confirmBeforeDelete: confirmDestructiveActions,
                          onTap: onEditEvento == null
                              ? null
                              : () => onEditEvento!(evento),
                          onDelete: onDeleteEvento == null
                              ? null
                              : () => onDeleteEvento!(evento),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  List<Evento> _eventsFor(DateTime date) {
    final target = _dateOnly(date);
    final filtered = controller.eventos.where((evento) {
      final start = _dateOnly(evento.inicio);
      final end = _dateOnly(evento.fin);
      return target.isAtSameMomentAs(start) ||
          target.isAtSameMomentAs(end) ||
          (target.isAfter(start) && target.isBefore(end));
    }).toList();
    filtered.sort((a, b) => a.inicio.compareTo(b.inicio));
    return filtered;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;
  final WeekStartPreference weekStart;

  const _DateSelector({
    required this.selectedDate,
    required this.onSelected,
    required this.weekStart,
  });

  @override
  Widget build(BuildContext context) {
    final start = selectedDate.subtract(
      Duration(days: _daysFromWeekStart(selectedDate.weekday)),
    );
    final days = List.generate(7, (index) => start.add(Duration(days: index)));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final day in days) ...[
            ChoiceChip(
              label: Text('${_weekdayLabel(day.weekday)} ${day.day}'),
              selected: _sameDay(day, selectedDate),
              onSelected: (_) => onSelected(day),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
