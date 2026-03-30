import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../repository/horario_repository.dart';
import '../domain/clase.dart';

class HorarioController {
  final HorarioRepository repository;

  List<Clase> clases = [];
  bool isLoading = false;
  final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(DateTime.now());

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
        recurrenceRule: clase.recurrenceRule,
        color: Color(clase.color),
      );
    }).toList();
  }
}
