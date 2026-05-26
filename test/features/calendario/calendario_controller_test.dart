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
  Future<void> programarNotificacionEvento(String eventoId) async {}

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
    test('carga eventos desde el repositorio y apaga isLoading', () async {
      final repo = FakeCalendarioRepository([
        evento(id: '1', titulo: 'Tutorias'),
        evento(id: '2', titulo: 'Entrega'),
      ]);
      final controller = CalendarioController(repository: repo);

      await controller.loadEventos();

      expect(controller.isLoading, isFalse);
      expect(controller.eventos.map((evento) => evento.titulo), [
        'Tutorias',
        'Entrega',
      ]);
    });

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

    test('mantiene la fecha seleccionada en un ValueNotifier actualizable', () {
      final controller = CalendarioController(
        repository: FakeCalendarioRepository(),
      );
      final selected = DateTime(2026, 5, 20);

      controller.selectedDate.value = selected;

      expect(controller.selectedDate.value, selected);
    });

    test('updateEvento inserta evento cuando no existe previamente', () async {
      final repo = FakeCalendarioRepository();
      final controller = CalendarioController(repository: repo);

      await controller.updateEvento(evento(id: 'nuevo', titulo: 'Seminario'));

      expect(controller.eventos, hasLength(1));
      expect(controller.eventos.single.id, 'nuevo');
      expect(controller.eventos.single.titulo, 'Seminario');
    });

    test(
      'deleteEvento ignora ids inexistentes sin alterar los eventos',
      () async {
        final repo = FakeCalendarioRepository([
          evento(id: '1', titulo: 'Examen'),
        ]);
        final controller = CalendarioController(repository: repo);

        await controller.deleteEvento('no-existe');

        expect(controller.eventos.single.titulo, 'Examen');
      },
    );
  });

  test(
    'EventoDataSource transforma eventos en appointments del calendario',
    () {
      final source = EventoDataSource([
        evento(
          id: 'evt-1',
          titulo: 'Entrega',
          descripcion: 'Proyecto final',
          color: Colors.purple.toARGB32(),
        ),
      ]);

      final appointment = source.appointments!.single as Appointment;

      expect(appointment.id, 'evt-1');
      expect(appointment.subject, 'Entrega');
      expect(appointment.notes, 'Proyecto final');
      expect(appointment.color.toARGB32(), Colors.purple.toARGB32());
    },
  );

  test('EventoDataSource conserva horario de inicio y fin', () {
    final inicio = DateTime(2026, 5, 13, 14, 30);
    final fin = DateTime(2026, 5, 13, 16);
    final source = EventoDataSource([
      evento(id: 'evt-2', titulo: 'Laboratorio', inicio: inicio, fin: fin),
    ]);

    final appointment = source.appointments!.single as Appointment;

    expect(appointment.startTime, inicio);
    expect(appointment.endTime, fin);
  });
}
