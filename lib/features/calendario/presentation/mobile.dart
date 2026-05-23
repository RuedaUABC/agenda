import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../domain/evento.dart';
import 'calendario_controller.dart';
import 'widgets/calendario_day_panel.dart';

enum CalendarioMobileView { mes, dia }

class MyMobileBody extends StatefulWidget {
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
  State<MyMobileBody> createState() => _MyMobileBodyState();
}

class _MyMobileBodyState extends State<MyMobileBody> {
  CalendarioMobileView _view = CalendarioMobileView.mes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Calendario',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
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
                child: SegmentedButton<CalendarioMobileView>(
                  segments: const [
                    ButtonSegment(
                      value: CalendarioMobileView.mes,
                      icon: Icon(Icons.calendar_month_outlined),
                      label: Text('Mes'),
                    ),
                    ButtonSegment(
                      value: CalendarioMobileView.dia,
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
                      view: CalendarView.month,
                      dataSource: EventoDataSource(widget.controller.eventos),
                      firstDayOfWeek: 1,
                      todayHighlightColor: colorScheme.primary,
                      selectionDecoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      monthViewSettings: const MonthViewSettings(
                        showAgenda: true,
                        agendaViewHeight: 220,
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.indicator,
                      ),
                      onTap: (CalendarTapDetails details) {
                        if (details.date != null) {
                          widget.controller.selectedDate.value = details.date!;
                          widget.onRefresh();
                        }
                      },
                    ),
                  ),
                  CalendarioDayPanel(
                    controller: widget.controller,
                    onRefresh: widget.onRefresh,
                    onEditEvento: widget.onEditEvento,
                    onDeleteEvento: widget.onDeleteEvento,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
