import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/theme/calendar_config.dart';
import '../domain/evento.dart';
import 'calendario_controller.dart';
import 'widgets/evento_list_item.dart';

class MyDesktopBody extends StatelessWidget {
  final CalendarioController controller;
  final VoidCallback onRefresh;
  final ValueChanged<Evento>? onEditEvento;
  final Future<void> Function(Evento evento)? onDeleteEvento;

  const MyDesktopBody({
    super.key,
    required this.controller,
    required this.onRefresh,
    this.onEditEvento,
    this.onDeleteEvento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: CalendarConfig.desktopCalendarFlex.toInt(),
            child: Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(16.0),
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: EventoDataSource(controller.eventos),
                firstDayOfWeek: 1,
                monthViewSettings: const MonthViewSettings(
                  showAgenda: true,
                  agendaViewHeight: 200,
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  showTrailingAndLeadingDates: true,
                ),
                headerHeight: 60,
                onTap: (CalendarTapDetails details) {
                  if (details.date != null) {
                    controller.selectedDate.value = details.date!;
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: CalendarConfig.desktopListFlex.toInt(),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: ValueListenableBuilder<DateTime>(
                valueListenable: controller.selectedDate,
                builder: (context, date, _) {
                  final filteredEventos = controller.eventos.where((evento) {
                    final start = DateTime(
                      evento.inicio.year,
                      evento.inicio.month,
                      evento.inicio.day,
                    );
                    final end = DateTime(
                      evento.fin.year,
                      evento.fin.month,
                      evento.fin.day,
                    );
                    final target = DateTime(date.year, date.month, date.day);
                    return target.isAtSameMomentAs(start) ||
                        (target.isAfter(start) && target.isBefore(end)) ||
                        target.isAtSameMomentAs(end);
                  }).toList();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Eventos',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${date.day}/${date.month}/${date.year}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: filteredEventos.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      size: 48,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Sin eventos para hoy',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).disabledColor,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16.0),
                                itemCount: filteredEventos.length,
                                itemBuilder: (context, index) {
                                  final evento = filteredEventos[index];
                                  return EventoListItem(
                                    evento: evento,
                                    margin: const EdgeInsets.only(bottom: 12.0),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
