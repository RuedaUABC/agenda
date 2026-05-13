import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/horario/domain/clase.dart';
import 'package:agenda/features/tareas/domain/tarea.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('modelos de dominio', () {
    test('Tarea serializa y deserializa valores de SQLite', () {
      final tarea = Tarea(
        id: 't1',
        titulo: 'Ensayo',
        asignatura: 'Literatura',
        descripcion: 'Borrador final',
        fecha: DateTime(2026, 5, 13, 18, 30),
        completada: true,
        eliminada: true,
      );

      final map = tarea.toMap();
      final restored = Tarea.fromMap(map);

      expect(map['completada'], 1);
      expect(map['eliminada'], 1);
      expect(restored.id, tarea.id);
      expect(restored.fecha, tarea.fecha);
      expect(restored.completada, isTrue);
      expect(restored.eliminada, isTrue);
    });

    test('Evento conserva fecha, descripcion y color', () {
      final evento = Evento(
        id: 'e1',
        titulo: 'Examen',
        inicio: DateTime(2026, 5, 14, 9),
        fin: DateTime(2026, 5, 14, 11),
        descripcion: 'Aula magna',
        color: 0xFF00BCD4,
      );

      final restored = Evento.fromMap(evento.toMap());

      expect(restored.titulo, 'Examen');
      expect(restored.inicio, evento.inicio);
      expect(restored.fin, evento.fin);
      expect(restored.descripcion, 'Aula magna');
      expect(restored.color, 0xFF00BCD4);
    });

    test('Clase conserva aula, recurrencia y color', () {
      final clase = Clase(
        id: 'c1',
        materia: 'Algebra',
        inicio: DateTime(2026, 5, 15, 7),
        fin: DateTime(2026, 5, 15, 9),
        aula: 'B-2',
        recurrenceRule: 'FREQ=WEEKLY;COUNT=8',
        color: 0xFFFF9800,
      );

      final restored = Clase.fromMap(clase.toMap());

      expect(restored.materia, 'Algebra');
      expect(restored.inicio, clase.inicio);
      expect(restored.fin, clase.fin);
      expect(restored.aula, 'B-2');
      expect(restored.recurrenceRule, 'FREQ=WEEKLY;COUNT=8');
      expect(restored.color, 0xFFFF9800);
    });
  });
}
