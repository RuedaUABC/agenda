class Clase {
  final String id;
  final String materia;
  final DateTime inicio;
  final DateTime fin;
  final String aula;
  final String? recurrenceRule;
  final int color; // Store color as ARGB int

  Clase({
    required this.id,
    required this.materia,
    required this.inicio,
    required this.fin,
    required this.aula,
    this.recurrenceRule,
    this.color = 0xFF2196F3, // Default blue
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "materia": materia,
      "inicio": inicio.toIso8601String(),
      "fin": fin.toIso8601String(),
      "aula": aula,
      "recurrenceRule": recurrenceRule,
      "color": color,
    };
  }

  factory Clase.fromMap(Map<String, dynamic> map) {
    return Clase(
      id: map["id"],
      materia: map["materia"],
      inicio: DateTime.parse(map["inicio"]),
      fin: DateTime.parse(map["fin"]),
      aula: map["aula"] ?? "",
      recurrenceRule: map["recurrenceRule"],
      color: map["color"] ?? 0xFF2196F3,
    );
  }
}
