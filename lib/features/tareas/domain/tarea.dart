class Tarea {
  final String id;
  final String titulo;
  final String asignatura;
  final String descripcion;
  final DateTime fecha;
  final bool completada;
  final bool eliminada;

  Tarea({
    required this.id,
    required this.titulo,
    required this.asignatura,
    required this.descripcion,
    required this.fecha,
    required this.completada,
    this.eliminada = false,
  });

  Tarea copyWith({
    String? id,
    String? titulo,
    String? asignatura,
    String? descripcion,
    DateTime? fecha,
    bool? completada,
    bool? eliminada,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      asignatura: asignatura ?? this.asignatura,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      completada: completada ?? this.completada,
      eliminada: eliminada ?? this.eliminada,
    );
  }

  // Convertir objeto a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "asignatura": asignatura,
      "descripcion": descripcion,
      "fecha": fecha.toIso8601String(), // Guardar como String
      "completada": completada ? 1 : 0, // Guardar como int
      "eliminada": eliminada ? 1 : 0,
    };
  }

  // Crear objeto desde Map de SQLite
  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map["id"],
      titulo: map["titulo"],
      asignatura: map["asignatura"] ?? "",
      descripcion: map["descripcion"] ?? "",
      fecha: DateTime.parse(map["fecha"]), // Convertir String a DateTime
      completada: map["completada"] == 1,
      eliminada: map["eliminada"] == 1,
    );
  }
}
