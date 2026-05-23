import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'horario_controller.dart';
import 'widgets/horario_day_panel.dart';

enum HorarioMobileView { semana, dia }

class MyMobileBody extends StatefulWidget {
  final HorarioController controller;
  final VoidCallback onRefresh;

  const MyMobileBody({
    super.key,
    required this.controller,
    required this.onRefresh,
  });

  @override
  State<MyMobileBody> createState() => _MyMobileBodyState();
}

class _MyMobileBodyState extends State<MyMobileBody> {
  HorarioMobileView _view = HorarioMobileView.semana;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Horario',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    widget.controller.selectedDate.value = DateTime.now();
                    widget.onRefresh();
                  },
                  icon: const Icon(Icons.today_outlined),
                  label: const Text('Hoy'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SegmentedButton<HorarioMobileView>(
                segments: const [
                  ButtonSegment(
                    value: HorarioMobileView.semana,
                    icon: Icon(Icons.calendar_view_week_outlined),
                    label: Text('Semana'),
                  ),
                  ButtonSegment(
                    value: HorarioMobileView.dia,
                    icon: Icon(Icons.view_day_outlined),
                    label: Text('Dia'),
                  ),
                ],
                selected: {_view},
                onSelectionChanged: (selection) {
                  setState(() => _view = selection.first);
                },
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _view.index,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: colorScheme.surface),
                  child: SfCalendar(
                    view: CalendarView.week,
                    dataSource: ClaseDataSource(widget.controller.clases),
                    firstDayOfWeek: 1,
                    headerHeight: 52,
                    todayHighlightColor: colorScheme.primary,
                    selectionDecoration: BoxDecoration(
                      border: Border.all(color: colorScheme.primary, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    timeSlotViewSettings: const TimeSlotViewSettings(
                      startHour: 7,
                      endHour: 22,
                    ),
                    onTap: (CalendarTapDetails details) {
                      if (details.date != null) {
                        widget.controller.selectedDate.value = details.date!;
                        widget.onRefresh();
                      }
                    },
                  ),
                ),
                HorarioDayPanel(
                  controller: widget.controller,
                  onRefresh: widget.onRefresh,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
