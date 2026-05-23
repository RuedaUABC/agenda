import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'horario_controller.dart';
import 'widgets/clase_list_item.dart';
import '../../../core/theme/calendar_config.dart';

class MyDesktopBody extends StatelessWidget {
  final HorarioController controller;
  final VoidCallback onRefresh;

  const MyDesktopBody({
    super.key,
    required this.controller,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 13 parts for the calendar
          Expanded(
            flex: CalendarConfig.desktopCalendarFlex.toInt(),
            child: Container(
              color: Theme.of(context).cardColor,
              child: SfCalendar(
                view: CalendarView.week,
                dataSource: ClaseDataSource(controller.clases),
                firstDayOfWeek: 1, // Lunes
                headerHeight: 60,
                headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                viewHeaderStyle: ViewHeaderStyle(
                  dayTextStyle: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                  dateTextStyle: Theme.of(context).textTheme.labelSmall,
                ),
                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 7,
                  endHour: 22,
                  nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
                ),
                onTap: (CalendarTapDetails details) {
                  if (details.date != null) {
                    controller.selectedDate.value = details.date!;
                  }
                },
              ),
            ),
          ),
          // 8 parts for the list
          Expanded(
            flex: CalendarConfig.desktopListFlex.toInt(),
            child: ValueListenableBuilder<DateTime>(
              valueListenable: controller.selectedDate,
              builder: (context, date, _) {
                final filteredClases = controller.clases.where((clase) {
                  // For simple day view, we check if it falls on the selected day
                  // For recurrent classes, it's trickier in a simple list, but let's show classes of that specific weekday.
                  return (clase.inicio.weekday == date.weekday);
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Clases del día',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: filteredClases.isEmpty
                          ? const Center(
                              child: Text('No hay clases programadas'),
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
          ),
        ],
      ),
    );
  }
}
