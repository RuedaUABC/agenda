import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'horario_controller.dart';
import 'widgets/clase_list_item.dart';

class MyMobileBody extends StatelessWidget {
  final HorarioController controller;
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
          title: const Text('Horario'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_view_week), text: 'Semana'),
              Tab(icon: Icon(Icons.list), text: 'Lista'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Vista Semanal
            SfCalendar(
              view: CalendarView.week,
              dataSource: ClaseDataSource(controller.clases),
              firstDayOfWeek: 1, // Lunes
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 7,
                endHour: 22,
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
                final filteredClases = controller.clases.where((clase) {
                  return clase.inicio.weekday == date.weekday;
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Clases del ${date.day}/${date.month}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: filteredClases.isEmpty
                          ? const Center(
                              child: Text('No hay clases para este día'),
                            )
                          : ListView.builder(
                              itemCount: filteredClases.length,
                              itemBuilder: (context, index) {
                                return ClaseListItem(
                                  clase: filteredClases[index],
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
