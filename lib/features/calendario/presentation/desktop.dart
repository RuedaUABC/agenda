import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/theme/calendar_config.dart';
import '../domain/evento.dart';
import 'calendario_controller.dart';
import 'widgets/calendario_day_panel.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: CalendarConfig.desktopCalendarFlex.toInt(),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: SfCalendar(
                  view: CalendarView.month,
                  dataSource: EventoDataSource(controller.eventos),
                  firstDayOfWeek: 1,
                  headerHeight: 60,
                  todayHighlightColor: colorScheme.primary,
                  selectionDecoration: BoxDecoration(
                    border: Border.all(color: colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  headerStyle: CalendarHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  monthViewSettings: const MonthViewSettings(
                    showAgenda: true,
                    agendaViewHeight: 180,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.indicator,
                    showTrailingAndLeadingDates: true,
                  ),
                  onTap: (CalendarTapDetails details) {
                    if (details.date != null) {
                      controller.selectedDate.value = details.date!;
                      onRefresh();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: CalendarConfig.desktopListFlex.toInt(),
              child: Card.filled(
                clipBehavior: Clip.antiAlias,
                child: CalendarioDayPanel(
                  controller: controller,
                  onRefresh: onRefresh,
                  onEditEvento: onEditEvento,
                  onDeleteEvento: onDeleteEvento,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
