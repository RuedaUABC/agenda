import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../repository/horario_repository.dart';
import '../domain/clase.dart';

class HorarioController {
  final HorarioRepository repository;

  List<Clase> clases = [];
  bool isLoading = false;
  final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  HorarioController({required this.repository});

  Future<void> loadClases() async {
    isLoading = true;
    clases = await repository.fetchClases();
    isLoading = false;
  }

  Future<void> addClase(Clase clase) async {
    await repository.addClase(clase);
    await loadClases();
  }

  Future<void> updateClase(Clase clase) async {
    await repository.updateClase(clase);
    await loadClases();
  }

  Future<void> deleteClase(String id) async {
    await repository.deleteClase(id);
    await loadClases();
  }
}

class ClaseDataSource extends CalendarDataSource {
  ClaseDataSource(List<Clase> source) {
    appointments = source.map((clase) {
      return Appointment(
        id: clase.id,
        subject: clase.materia,
        startTime: clase.inicio,
        endTime: clase.fin,
        location: clase.aula,
        recurrenceRule: normalizeWeeklyRecurrenceRule(
          clase.recurrenceRule,
          clase.inicio,
        ),
        color: Color(clase.color),
      );
    }).toList();
  }
}

String? normalizeWeeklyRecurrenceRule(String? rule, DateTime startDate) {
  if (rule == null || rule.isEmpty) return rule;
  if (!rule.contains('FREQ=WEEKLY') || rule.contains('BYDAY=')) return rule;

  return '$rule;BYDAY=${weekdayToRecurrenceDay(startDate.weekday)}';
}

String weekdayToRecurrenceDay(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'MO';
    case DateTime.tuesday:
      return 'TU';
    case DateTime.wednesday:
      return 'WE';
    case DateTime.thursday:
      return 'TH';
    case DateTime.friday:
      return 'FR';
    case DateTime.saturday:
      return 'SA';
    case DateTime.sunday:
      return 'SU';
    default:
      throw ArgumentError.value(weekday, 'weekday', 'Dia invalido');
  }
}
