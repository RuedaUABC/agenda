import 'evento.dart';

class EventoValidator {
  static const int maxTituloLength = 120;
  static const int maxDescripcionLength = 500;

  static String normalizeText(String? value) => value?.trim() ?? '';

  static String? validateTitulo(String? value) {
    final titulo = normalizeText(value);
    if (titulo.isEmpty) {
      return 'Ingresa el titulo del evento';
    }
    if (titulo.length > maxTituloLength) {
      return 'El titulo no puede superar $maxTituloLength caracteres';
    }
    return null;
  }

  static String? validateDescripcion(String? value) {
    final descripcion = normalizeText(value);
    if (descripcion.length > maxDescripcionLength) {
      return 'La descripcion no puede superar $maxDescripcionLength caracteres';
    }
    return null;
  }

  static String? validateRango(DateTime? inicio, DateTime? fin) {
    if (inicio == null) {
      return 'Selecciona el inicio del evento';
    }
    if (fin == null) {
      return 'Selecciona el fin del evento';
    }
    if (fin.isBefore(inicio)) {
      return 'El fin no puede ser anterior al inicio';
    }
    return null;
  }

  static int normalizeColor(int? color) {
    if (color == null || color < 0 || color > 0xFFFFFFFF) {
      return Evento.defaultColor;
    }
    return color;
  }

  static Evento normalizedEvento({
    required String id,
    required String? titulo,
    required DateTime inicio,
    required DateTime fin,
    String? descripcion,
    int? color,
  }) {
    return Evento(
      id: id,
      titulo: normalizeText(titulo),
      inicio: inicio,
      fin: fin,
      descripcion: normalizeText(descripcion),
      color: normalizeColor(color),
    );
  }

  static bool hasOverlap(
    Evento candidate,
    List<Evento> eventos, {
    String? excludeId,
  }) {
    return eventos.any((evento) {
      if (evento.id == excludeId) return false;
      return _overlap(candidate, evento);
    });
  }

  static bool _overlap(Evento a, Evento b) {
    final aIsPoint = a.inicio.isAtSameMomentAs(a.fin);
    final bIsPoint = b.inicio.isAtSameMomentAs(b.fin);

    if (aIsPoint && bIsPoint) {
      return a.inicio.isAtSameMomentAs(b.inicio);
    }
    if (aIsPoint) {
      return !a.inicio.isBefore(b.inicio) && a.inicio.isBefore(b.fin);
    }
    if (bIsPoint) {
      return !b.inicio.isBefore(a.inicio) && b.inicio.isBefore(a.fin);
    }

    return a.inicio.isBefore(b.fin) && a.fin.isAfter(b.inicio);
  }
}
