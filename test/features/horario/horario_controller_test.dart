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
    test('carga clases desde el repositorio y apaga isLoading', () async {
      final repo = FakeHorarioRepository([
        clase(id: '1', materia: 'Fisica'),
        clase(id: '2', materia: 'Historia'),
      ]);
      final controller = HorarioController(repository: repo);

      await controller.loadClases();

      expect(controller.isLoading, isFalse);
      expect(controller.clases.map((clase) => clase.materia), [
        'Fisica',
        'Historia',
      ]);
    });

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

    test('mantiene la fecha seleccionada en un ValueNotifier actualizable', () {
      final controller = HorarioController(repository: FakeHorarioRepository());
      final selected = DateTime(2026, 5, 18);

      controller.selectedDate.value = selected;

      expect(controller.selectedDate.value, selected);
    });

    test('updateClase inserta clase cuando no existe previamente', () async {
      final repo = FakeHorarioRepository();
      final controller = HorarioController(repository: repo);

      await controller.updateClase(clase(id: 'nueva', materia: 'Quimica'));

      expect(controller.clases, hasLength(1));
      expect(controller.clases.single.id, 'nueva');
      expect(controller.clases.single.materia, 'Quimica');
    });

    test(
      'deleteClase ignora ids inexistentes sin alterar las clases',
      () async {
        final repo = FakeHorarioRepository([
          clase(id: '1', materia: 'Algebra'),
        ]);
        final controller = HorarioController(repository: repo);

        await controller.deleteClase('no-existe');

        expect(controller.clases.single.materia, 'Algebra');
      },
    );
  });

  test('ClaseDataSource transforma clases en appointments del calendario', () {
    final source = ClaseDataSource([
      clase(
        id: 'clase-1',
        materia: 'Programacion',
        aula: 'Lab 3',
        recurrenceRule: 'FREQ=WEEKLY;COUNT=4',
        color: Colors.blueGrey.toARGB32(),
      ),
    ]);

    final appointment = source.appointments!.single as Appointment;

    expect(appointment.id, 'clase-1');
    expect(appointment.subject, 'Programacion');
    expect(appointment.location, 'Lab 3');
    expect(appointment.recurrenceRule, 'FREQ=WEEKLY;COUNT=4;BYDAY=WE');
    expect(appointment.color.toARGB32(), Colors.blueGrey.toARGB32());
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

  test('normalizeWeeklyRecurrenceRule conserva reglas nulas o vacias', () {
    final start = DateTime(2026, 5, 13);

    expect(normalizeWeeklyRecurrenceRule(null, start), isNull);
    expect(normalizeWeeklyRecurrenceRule('', start), '');
  });

  test('normalizeWeeklyRecurrenceRule no cambia reglas no semanales', () {
    final rule = 'FREQ=DAILY;COUNT=5';

    expect(normalizeWeeklyRecurrenceRule(rule, DateTime(2026, 5, 13)), rule);
  });

  test('weekdayToRecurrenceDay mapea todos los dias de la semana', () {
    expect(weekdayToRecurrenceDay(DateTime.monday), 'MO');
    expect(weekdayToRecurrenceDay(DateTime.tuesday), 'TU');
    expect(weekdayToRecurrenceDay(DateTime.wednesday), 'WE');
    expect(weekdayToRecurrenceDay(DateTime.thursday), 'TH');
    expect(weekdayToRecurrenceDay(DateTime.friday), 'FR');
    expect(weekdayToRecurrenceDay(DateTime.saturday), 'SA');
    expect(weekdayToRecurrenceDay(DateTime.sunday), 'SU');
  });

  test('weekdayToRecurrenceDay rechaza dias invalidos', () {
    expect(() => weekdayToRecurrenceDay(0), throwsArgumentError);
  });
}
