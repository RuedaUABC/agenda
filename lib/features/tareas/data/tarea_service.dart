import '../domain/tarea.dart';

class TareaService {
  final String baseUrl = "https://api.tuapp.com/tareas"; // Placeholder URL

  Future<void> syncTareas(List<Tarea> tareas) async {
    // Aqui iria la logica para sincronizar con una API externa.
    // print("Syncing ${tareas.length} tareas to $baseUrl");
  }
}
