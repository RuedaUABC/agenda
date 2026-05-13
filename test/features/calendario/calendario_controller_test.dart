import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/presentation/calendario_controller.dart';
import 'package:agenda/features/calendario/repository/calendario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class FakeCalendarioRepository implements CalendarioRepository {
  final List<Evento> stored;

  FakeCalendarioRepository([List<Evento>? initial]) : stored = initial ?? [];

  @override
  Future<void> addEvento(Evento evento) async {
    stored.add(evento);
  }

  @override
  Future<void> deleteEvento(String id) async {
    stored.removeWhere((evento) => evento.id == id);
  }

  @override
  Future<List<Evento>> fetchEventos() async => List<Evento>.from(stored);

  @override
  Future<void> updateEvento(Evento evento) async {
    final index = stored.indexWhere((item) => item.id == evento.id);
    if (index == -1) {
      stored.add(evento);
    } else {
      stored[index] = evento;
    }
  }
}

Evento evento({
  required String id,
  required String titulo,
  DateTime? inicio,
  DateTime? fin,
  String descripcion = 'Clase de repaso',
  int color = 0xFF4CAF50,
}) {
  final start = inicio ?? DateTime(2026, 5, 13, 10);
  return Evento(
    id: id,
    titulo: titulo,
    inicio: start,
    fin: fin ?? start.add(const Duration(hours: 1)),
    descripcion: descripcion,
    color: color,
  );
}

void main() {
  group('CalendarioController', () {
    test('agrega, actualiza y elimina eventos recargando el estado', () async {
      final repo = FakeCalendarioRepository();
      final controller = CalendarioController(repository: repo);

      await controller.addEvento(evento(id: '1', titulo: 'Parcial'));
      expect(controller.eventos.single.titulo, 'Parcial');

      await controller.updateEvento(evento(id: '1', titulo: 'Parcial final'));
      expect(controller.eventos.single.titulo, 'Parcial final');

      await controller.deleteEvento('1');
      expect(controller.eventos, isEmpty);
      expect(controller.isLoading, isFalse);
    });
  });

  test(
    'EventoDataSource transforma eventos en appointments del calendario',
    () {
      final source = EventoDataSource([
        evento(
          id: 'evt-1',
          titulo: 'Entrega',
          descripcion: 'Proyecto final',
          color: Colors.purple.value,
        ),
      ]);

      final appointment = source.appointments!.single as Appointment;

      expect(appointment.id, 'evt-1');
      expect(appointment.subject, 'Entrega');
      expect(appointment.notes, 'Proyecto final');
      expect(appointment.color.value, Colors.purple.value);
    },
  );
}
