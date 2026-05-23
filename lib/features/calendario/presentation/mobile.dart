import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../domain/evento.dart';
import 'calendario_controller.dart';
import 'widgets/evento_list_item.dart';

class MyMobileBody extends StatelessWidget {
  final CalendarioController controller;
  final VoidCallback onRefresh;
  final ValueChanged<Evento>? onEditEvento;
  final Future<void> Function(Evento evento)? onDeleteEvento;

  const MyMobileBody({
    super.key,
    required this.controller,
    required this.onRefresh,
    this.onEditEvento,
    this.onDeleteEvento,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendario'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_month), text: 'Mes'),
              Tab(icon: Icon(Icons.list), text: 'Eventos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SfCalendar(
              view: CalendarView.month,
              dataSource: EventoDataSource(controller.eventos),
              firstDayOfWeek: 1,
              monthViewSettings: const MonthViewSettings(
                showAgenda: true,
                agendaViewHeight: 250,
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              ),
              onTap: (CalendarTapDetails details) {
                if (details.date != null) {
                  controller.selectedDate.value = details.date!;
                }
              },
            ),
            ValueListenableBuilder<DateTime>(
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
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Eventos del ${date.day}/${date.month}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: filteredEventos.isEmpty
                          ? const Center(
                              child: Text('No hay eventos para este dia'),
                            )
                          : ListView.builder(
                              itemCount: filteredEventos.length,
                              itemBuilder: (context, index) {
                                final evento = filteredEventos[index];
                                return EventoListItem(
                                  evento: evento,
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
          ],
        ),
      ),
    );
  }
}
