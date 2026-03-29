class Notificacion {
  final String id;
  final String tareaId;
  final Duration tiempoAntes;
  final String mensaje;
  final bool activo;

  Notificacion({
    required this.id,
    required this.tareaId,
    required this.tiempoAntes,
    required this.mensaje,
    required this.activo,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "tareaId": tareaId,
      "tiempoAntes": tiempoAntes.inMinutes, // guardamos como int (minutos)
      "mensaje": mensaje,
      "activo": activo ? 1 : 0,
    };
  }

  factory Notificacion.fromMap(Map<String, dynamic> map) {
    return Notificacion(
      id: map["id"],
      tareaId: map["tareaId"],
      tiempoAntes: Duration(minutes: map["tiempoAntes"]),
      mensaje: map["mensaje"],
      activo: map["activo"] == 1,
    );
  }
}
