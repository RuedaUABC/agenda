import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/theme/calendar_config.dart';
import '../../configuracion/preferences_helper.dart';
import '../domain/clase.dart';
import 'horario_controller.dart';
import 'widgets/horario_day_panel.dart';

class MyDesktopBody extends StatelessWidget {
  final HorarioController controller;
  final VoidCallback onRefresh;
  final WeekStartPreference weekStart;
  final VisualDensity visualDensity;
  final Future<void> Function(Clase clase)? onDeleteClase;
  final VoidCallback? onCreateClase;
  final bool confirmDestructiveActions;

  const MyDesktopBody({
    super.key,
    required this.controller,
    required this.onRefresh,
    this.weekStart = WeekStartPreference.lunes,
    this.visualDensity = VisualDensity.standard,
    this.onDeleteClase,
    this.onCreateClase,
    this.confirmDestructiveActions = true,
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
                  view: CalendarView.week,
                  dataSource: ClaseDataSource(controller.clases),
                  firstDayOfWeek: _firstDayOfWeek(weekStart),
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
                  viewHeaderStyle: ViewHeaderStyle(
                    dayTextStyle: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
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
                child: HorarioDayPanel(
                  controller: controller,
                  onRefresh: onRefresh,
                  weekStart: weekStart,
                  visualDensity: visualDensity,
                  onDeleteClase: onDeleteClase,
                  onCreateClase: onCreateClase,
                  confirmDestructiveActions: confirmDestructiveActions,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _firstDayOfWeek(WeekStartPreference value) {
    switch (value) {
      case WeekStartPreference.lunes:
        return DateTime.monday;
      case WeekStartPreference.domingo:
        return DateTime.sunday;
    }
  }
}
