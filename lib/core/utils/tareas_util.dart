import 'package:agenda/features/tareas/domain/tarea.dart';

class TareaUtils {
  /// Clasifica las tareas en tres listas:
  /// - vencidas: fecha < hoy
  /// - pendientesSemana: fecha dentro de los próximos 7 días
  /// - proximas: fecha > 7 días desde hoy
  static Map<String, List<Tarea>> clasificarTareas(List<Tarea> tareas) {
    final hoy = DateTime.now();
    final finSemana = hoy.add(const Duration(days: 7));

    final vencidas = <Tarea>[];
    final pendientesSemana = <Tarea>[];
    final proximas = <Tarea>[];

    for (var tarea in tareas) {
      if (tarea.fecha.isBefore(hoy)) {
        vencidas.add(tarea);
      } else if (tarea.fecha.isBefore(finSemana)) {
        pendientesSemana.add(tarea);
      } else {
        proximas.add(tarea);
      }
    }

    return {
      "vencidas": vencidas,
      "pendientesSemana": pendientesSemana,
      "proximas": proximas,
    };
  }
}
