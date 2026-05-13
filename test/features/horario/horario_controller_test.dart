import 'package:agenda/features/horario/domain/clase.dart';
import 'package:agenda/features/horario/presentation/horario_controller.dart';
import 'package:agenda/features/horario/repository/horario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class FakeHorarioRepository implements HorarioRepository {
  final List<Clase> stored;

  FakeHorarioRepository([List<Clase>? initial]) : stored = initial ?? [];

  @override
  Future<void> addClase(Clase clase) async {
    stored.add(clase);
  }

  @override
  Future<void> deleteClase(String id) async {
    stored.removeWhere((clase) => clase.id == id);
  }

  @override
  Future<List<Clase>> fetchClases() async => List<Clase>.from(stored);

  @override
  Future<void> updateClase(Clase clase) async {
    final index = stored.indexWhere((item) => item.id == clase.id);
    if (index == -1) {
      stored.add(clase);
    } else {
      stored[index] = clase;
    }
  }
}

Clase clase({
  required String id,
  required String materia,
  DateTime? inicio,
  DateTime? fin,
  String aula = 'A-12',
  String? recurrenceRule,
  int color = 0xFF2196F3,
}) {
  final start = inicio ?? DateTime(2026, 5, 13, 8);
  return Clase(
    id: id,
    materia: materia,
    inicio: start,
    fin: fin ?? start.add(const Duration(hours: 2)),
    aula: aula,
    recurrenceRule: recurrenceRule,
    color: color,
  );
}

void main() {
  group('HorarioController', () {
    test('agrega, actualiza y elimina clases recargando el estado', () async {
      final repo = FakeHorarioRepository();
      final controller = HorarioController(repository: repo);

      await controller.addClase(clase(id: '1', materia: 'Fisica'));
      expect(controller.clases.single.materia, 'Fisica');

      await controller.updateClase(clase(id: '1', materia: 'Fisica II'));
      expect(controller.clases.single.materia, 'Fisica II');

      await controller.deleteClase('1');
      expect(controller.clases, isEmpty);
      expect(controller.isLoading, isFalse);
    });
  });

  test('ClaseDataSource transforma clases en appointments del calendario', () {
    final source = ClaseDataSource([
      clase(
        id: 'clase-1',
        materia: 'Programacion',
        aula: 'Lab 3',
        recurrenceRule: 'FREQ=WEEKLY;COUNT=4',
        color: Colors.blueGrey.value,
      ),
    ]);

    final appointment = source.appointments!.single as Appointment;

    expect(appointment.id, 'clase-1');
    expect(appointment.subject, 'Programacion');
    expect(appointment.location, 'Lab 3');
    expect(appointment.recurrenceRule, 'FREQ=WEEKLY;COUNT=4;BYDAY=WE');
    expect(appointment.color.value, Colors.blueGrey.value);
  });

  test('ClaseDataSource normaliza reglas semanales antiguas sin BYDAY', () {
    final source = ClaseDataSource([
      clase(
        id: 'clase-1',
        materia: 'Programacion',
        inicio: DateTime(2026, 5, 13, 8),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1',
      ),
    ]);

    final appointment = source.appointments!.single as Appointment;

    expect(appointment.recurrenceRule, 'FREQ=WEEKLY;INTERVAL=1;BYDAY=WE');
  });
}
