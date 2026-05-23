import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/domain/evento_validator.dart';
import 'package:flutter_test/flutter_test.dart';

Evento _evento({
  String id = 'evt-1',
  String titulo = 'Parcial',
  DateTime? inicio,
  DateTime? fin,
}) {
  final start = inicio ?? DateTime(2026, 5, 13, 10);
  return Evento(
    id: id,
    titulo: titulo,
    inicio: start,
    fin: fin ?? start.add(const Duration(hours: 1)),
  );
}

void main() {
  group('EventoValidator', () {
    test('valida titulo obligatorio y longitud maxima', () {
      expect(
        EventoValidator.validateTitulo('   '),
        'Ingresa el titulo del evento',
      );
      expect(
        EventoValidator.validateTitulo(
          'a' * (EventoValidator.maxTituloLength + 1),
        ),
        'El titulo no puede superar 120 caracteres',
      );
      expect(EventoValidator.validateTitulo('  Tutoria  '), isNull);
    });

    test('valida descripcion con longitud maxima', () {
      expect(
        EventoValidator.validateDescripcion(
          'a' * (EventoValidator.maxDescripcionLength + 1),
        ),
        'La descripcion no puede superar 500 caracteres',
      );
      expect(EventoValidator.validateDescripcion('  Aula 2  '), isNull);
    });

    test('valida rango de fechas y permite evento puntual', () {
      final start = DateTime(2026, 5, 13, 10);
      final end = DateTime(2026, 5, 13, 11);

      expect(
        EventoValidator.validateRango(null, end),
        'Selecciona el inicio del evento',
      );
      expect(
        EventoValidator.validateRango(start, null),
        'Selecciona el fin del evento',
      );
      expect(
        EventoValidator.validateRango(end, start),
        'El fin no puede ser anterior al inicio',
      );
      expect(EventoValidator.validateRango(start, start), isNull);
    });

    test('normaliza textos y aplica color por defecto', () {
      final evento = EventoValidator.normalizedEvento(
        id: 'evt-1',
        titulo: '  Entrega final  ',
        inicio: DateTime(2026, 5, 13, 8),
        fin: DateTime(2026, 5, 13, 9),
        descripcion: '  Aula magna  ',
        color: null,
      );

      expect(evento.titulo, 'Entrega final');
      expect(evento.descripcion, 'Aula magna');
      expect(evento.color, Evento.defaultColor);
    });

    test('detecta superposiciones excluyendo el evento editado', () {
      final existing = _evento(
        id: 'evt-1',
        inicio: DateTime(2026, 5, 13, 10),
        fin: DateTime(2026, 5, 13, 11),
      );

      expect(
        EventoValidator.hasOverlap(
          _evento(
            id: 'evt-2',
            inicio: DateTime(2026, 5, 13, 10, 30),
            fin: DateTime(2026, 5, 13, 12),
          ),
          [existing],
        ),
        isTrue,
      );
      expect(
        EventoValidator.hasOverlap(
          _evento(
            id: 'evt-2',
            inicio: DateTime(2026, 5, 13, 11),
            fin: DateTime(2026, 5, 13, 12),
          ),
          [existing],
        ),
        isFalse,
      );
      expect(
        EventoValidator.hasOverlap(
          _evento(
            id: 'evt-1',
            inicio: DateTime(2026, 5, 13, 10, 30),
            fin: DateTime(2026, 5, 13, 12),
          ),
          [existing],
          excludeId: 'evt-1',
        ),
        isFalse,
      );
    });
  });
}
