import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'calendario_controller.dart';

class MyMobileBody extends StatelessWidget {
  final CalendarioController controller;
  final VoidCallback onRefresh;

  const MyMobileBody({
    super.key,
    required this.controller,
    required this.onRefresh,
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
            // Vista Mensual
            SfCalendar(
              view: CalendarView.month,
              dataSource: EventoDataSource(controller.eventos),
              firstDayOfWeek: 1, // Lunes
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
            // Vista de Lista (Día seleccionado)
            ValueListenableBuilder<DateTime>(
              valueListenable: controller.selectedDate,
              builder: (context, date, _) {
                final filteredEventos = controller.eventos.where((evento) {
                  final start = DateTime(evento.inicio.year, evento.inicio.month, evento.inicio.day);
                  final end = DateTime(evento.fin.year, evento.fin.month, evento.fin.day);
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
                              child: Text('No hay eventos para este día'),
                            )
                          : ListView.builder(
                              itemCount: filteredEventos.length,
                              itemBuilder: (context, index) {
                                final evento = filteredEventos[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    leading: Container(
                                      width: 4,
                                      decoration: BoxDecoration(
                                        color: Color(evento.color),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    title: Text(evento.titulo),
                                    subtitle: Text(evento.descripcion),
                                  ),
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
