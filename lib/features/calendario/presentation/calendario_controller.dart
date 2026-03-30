import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../repository/calendario_repository.dart';
import '../domain/evento.dart';

class CalendarioController {
  final CalendarioRepository repository;

  List<Evento> eventos = [];
  bool isLoading = false;
  final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(DateTime.now());

  CalendarioController({required this.repository});

  Future<void> loadEventos() async {
    isLoading = true;
    eventos = await repository.fetchEventos();
    isLoading = false;
  }

  Future<void> addEvento(Evento evento) async {
    await repository.addEvento(evento);
    await loadEventos();
  }

  Future<void> updateEvento(Evento evento) async {
    await repository.updateEvento(evento);
    await loadEventos();
  }

  Future<void> deleteEvento(String id) async {
    await repository.deleteEvento(id);
    await loadEventos();
  }
}

class EventoDataSource extends CalendarDataSource {
  EventoDataSource(List<Evento> source) {
    appointments = source.map((evento) {
      return Appointment(
        id: evento.id,
        subject: evento.titulo,
        startTime: evento.inicio,
        endTime: evento.fin,
        notes: evento.descripcion,
        color: Color(evento.color),
      );
    }).toList();
  }
}
