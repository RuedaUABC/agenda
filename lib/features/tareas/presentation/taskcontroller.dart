import '../domain/tarea.dart';
import '../repository/tarea_repository.dart';

enum TaskStatusFilter { todas, pendientes, completadas }

enum TaskDateFilter { todas, vencidas, hoy, semana, futuras }

class TasksController {
  final TareaRepository repository;

  List<Tarea> tareas = [];
  List<Tarea> papelera = [];
  bool isLoading = false;
  String? lastError;
  String searchQuery = '';
  TaskStatusFilter statusFilter = TaskStatusFilter.todas;
  TaskDateFilter dateFilter = TaskDateFilter.todas;

  TasksController({required this.repository});

  Future<void> loadTareas() async {
    isLoading = true;
    try {
      tareas = await repository.fetchTareas();
      papelera = await repository.fetchTareasEliminadas();
      lastError = null;
    } catch (_) {
      lastError = 'No se pudieron cargar las tareas';
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadPapelera() async {
    try {
      papelera = await repository.fetchTareasEliminadas();
      lastError = null;
    } catch (_) {
      lastError = 'No se pudo cargar la papelera';
      rethrow;
    }
  }

  Future<void> createTarea(Tarea tarea) async {
    try {
      await repository.addTarea(tarea);
      await loadTareas();
      lastError = null;
    } catch (_) {
      lastError = 'No se pudo guardar la tarea';
      rethrow;
    }
  }

  Future<void> updateTarea(Tarea tarea) async {
    try {
      await repository.updateTarea(tarea);
      await loadTareas();
      lastError = null;
    } catch (_) {
      lastError = 'No se pudo actualizar la tarea';
      rethrow;
    }
  }

  Future<void> deleteTarea(String id) async {
    try {
      await repository.deleteTarea(id);
      await loadTareas();
      lastError = null;
    } catch (_) {
      lastError = 'No se pudo eliminar la tarea';
      rethrow;
    }
  }

  Future<void> deleteTareaDefinitiva(String id) async {
    try {
      await repository.deleteTareaDefinitiva(id);
      await loadTareas();
      lastError = null;
    } catch (_) {
      lastError = 'No se pudo eliminar definitivamente la tarea';
      rethrow;
    }
  }

  Future<void> restoreTarea(String id) async {
    try {
      await repository.restoreTarea(id);
      await loadTareas();
      lastError = null;
    } catch (_) {
      lastError = 'No se pudo recuperar la tarea';
      rethrow;
    }
  }

  void updateSearchQuery(String value) {
    searchQuery = value.trim();
  }

  void updateStatusFilter(TaskStatusFilter value) {
    statusFilter = value;
  }

  void updateDateFilter(TaskDateFilter value) {
    dateFilter = value;
  }

  List<Tarea> buscarTareas(List<Tarea> source) {
    final query = searchQuery.toLowerCase();
    if (query.isEmpty) return List<Tarea>.from(source);

    return source.where((tarea) {
      return tarea.titulo.toLowerCase().contains(query) ||
          tarea.asignatura.toLowerCase().contains(query) ||
          tarea.descripcion.toLowerCase().contains(query);
    }).toList();
  }

  List<Tarea> filtrarTareas(List<Tarea> source) {
    final today = _today();
    return buscarTareas(source).where((tarea) {
      final matchesStatus = switch (statusFilter) {
        TaskStatusFilter.todas => true,
        TaskStatusFilter.pendientes => !tarea.completada,
        TaskStatusFilter.completadas => tarea.completada,
      };

      final taskDate = DateTime(
        tarea.fecha.year,
        tarea.fecha.month,
        tarea.fecha.day,
      );
      final matchesDate = switch (dateFilter) {
        TaskDateFilter.todas => true,
        TaskDateFilter.vencidas => taskDate.isBefore(today),
        TaskDateFilter.hoy => taskDate.isAtSameMomentAs(today),
        TaskDateFilter.semana =>
          !taskDate.isBefore(today) &&
              taskDate.isBefore(today.add(const Duration(days: 7))),
        TaskDateFilter.futuras => !taskDate.isBefore(
          today.add(const Duration(days: 7)),
        ),
      };

      return matchesStatus && matchesDate;
    }).toList();
  }

  Map<String, List<Tarea>> clasificarTareas([List<Tarea>? source]) {
    final today = _today();
    final sevenDaysLater = today.add(const Duration(days: 7));
    final Map<String, List<Tarea>> clasificacion = {
      "vencidas": [],
      "pendientesSemana": [],
      "proximas": [],
      "completadas": [],
    };

    for (var t in source ?? tareas) {
      if (t.completada) {
        clasificacion["completadas"]!.add(t);
        continue;
      }

      final taskDate = DateTime(t.fecha.year, t.fecha.month, t.fecha.day);
      if (taskDate.isBefore(today)) {
        clasificacion["vencidas"]!.add(t);
      } else if (taskDate.isBefore(sevenDaysLater)) {
        clasificacion["pendientesSemana"]!.add(t);
      } else {
        clasificacion["proximas"]!.add(t);
      }
    }
    return clasificacion;
  }

  Map<DateTime, int> getWeeklyStats() {
    final today = _today();
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
    final today = _today();

    final todayTasks = tareas.where((t) {
      final tDate = DateTime(t.fecha.year, t.fecha.month, t.fecha.day);
      return tDate.isAtSameMomentAs(today);
    }).toList();

    if (todayTasks.isEmpty) return 0.0;

    final completedCount = todayTasks.where((t) => t.completada).length;
    return completedCount / todayTasks.length;
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
