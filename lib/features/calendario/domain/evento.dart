class Evento {
  static const int defaultColor = 0xFFF44336;

  final String id;
  final String titulo;
  final DateTime inicio;
  final DateTime fin;
  final String descripcion;
  final int color;

  Evento({
    required this.id,
    required this.titulo,
    required this.inicio,
    required this.fin,
    this.descripcion = "",
    this.color = defaultColor,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "inicio": inicio.toIso8601String(),
      "fin": fin.toIso8601String(),
      "descripcion": descripcion,
      "color": color,
    };
  }

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map["id"],
      titulo: map["titulo"],
      inicio: DateTime.parse(map["inicio"]),
      fin: DateTime.parse(map["fin"]),
      descripcion: map["descripcion"] ?? "",
      color: map["color"] ?? defaultColor,
    );
  }
}
