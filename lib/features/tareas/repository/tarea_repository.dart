import '../domain/tarea.dart';

abstract class TareaRepository {
  Future<List<Tarea>> fetchTareas();
  Future<void> addTarea(Tarea tarea);
  Future<void> updateTarea(Tarea tarea);
  Future<void> deleteTarea(String id);
  Future<void> programarNotificacionesTarea(String tareaId);
}
