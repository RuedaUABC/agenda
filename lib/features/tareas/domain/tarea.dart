class Tarea {
  final String id;
  final String titulo;
  final String asignatura;
  final String descripcion;
  final DateTime fecha;
  final bool completada;

  Tarea({
    required this.id,
    required this.titulo,
    required this.asignatura,
    required this.descripcion,
    required this.fecha,
    required this.completada,
  });

  // Convertir objeto a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "asignatura": asignatura,
      "descripcion": descripcion,
      "fecha": fecha.toIso8601String(), // Guardar como String
      "completada": completada ? 1 : 0, // Guardar como int
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
    );
  }
}
