import '../repository/tarea_repository.dart';
import '../domain/tarea.dart';

class TasksController {
  final TareaRepository repository;

  List<Tarea> tareas = [];
  bool isLoading = false;

  TasksController({required this.repository});

  Future<void> loadTareas() async {
    isLoading = true;
    tareas = await repository.fetchTareas();
    isLoading = false;
  }

  Future<void> createTarea(Tarea tarea) async {
    await repository.addTarea(tarea);
    await loadTareas();
  }

  Future<void> updateTarea(Tarea tarea) async {
    await repository.updateTarea(tarea);
    await loadTareas();
  }

  Future<void> deleteTarea(String id) async {
    await repository.deleteTarea(id);
    await loadTareas();
  }

  Map<String, List<Tarea>> clasificarTareas() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sevenDaysLater = today.add(Duration(days: 7));
    final Map<String, List<Tarea>> clasificacion = {
      "vencidas": [],
      "pendientesSemana": [],
      "proximas": [],
      "completadas": [],
    };

    for (var t in tareas) {
      if (t.completada) {
        clasificacion["completadas"]!.add(t);
        continue;
      }

      if (t.fecha.isBefore(today)) {
        clasificacion["vencidas"]!.add(t);
      } else if (t.fecha.isBefore(sevenDaysLater)) {
        clasificacion["pendientesSemana"]!.add(t);
      } else {
        clasificacion["proximas"]!.add(t);
      }
    }
    return clasificacion;
  }

  Map<DateTime, int> getWeeklyStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stats = <DateTime, int>{};

    for (int i = 0; i < 7; i++) {
      final day = today.add(Duration(days: i));
      stats[day] = tareas.where((t) {
        final tDate = DateTime(t.fecha.year, t.fecha.month, t.fecha.day);
        return tDate.isAtSameMomentAs(day) && !t.completada;
      }).length;
    }
    return stats;
  }

  double getTodayProgress() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayTasks = tareas.where((t) {
      final tDate = DateTime(t.fecha.year, t.fecha.month, t.fecha.day);
      return tDate.isAtSameMomentAs(today);
    }).toList();

    if (todayTasks.isEmpty) return 0.0;

    final completedCount = todayTasks.where((t) => t.completada).length;
    return completedCount / todayTasks.length;
  }
}
