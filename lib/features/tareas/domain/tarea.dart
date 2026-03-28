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
    this.completada = false,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      asignatura: json['asignatura'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fecha: DateTime.parse(json['fecha']),
      completada: json['completada'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'asignatura': asignatura,
      'descripcion': descripcion,
      // Al convertir de vuelta a JSON, convertimos la fecha a String ISO-8601
      'fecha': fecha.toIso8601String(),
      'completada': completada,
    };
  }
}
