import 'package:flutter/material.dart';
import '../../domain/tarea.dart';
import '../taskcontroller.dart';

class ListaTareasCategoria extends StatelessWidget {
  const ListaTareasCategoria({
    super.key,
    required this.controller,
    required this.onRefresh,
    required this.title,
    required this.tareas,
    required this.context,
    this.isCompletedMode = false,
  });

  final TasksController controller;
  final VoidCallback onRefresh;
  final String title;
  final List<Tarea> tareas;
  final BuildContext context;
  final bool isCompletedMode;

  @override
  Widget build(BuildContext context) {
    if (tareas.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: true,
      children: tareas.map((t) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            title: Text(
              t.titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: isCompletedMode ? TextDecoration.lineThrough : null,
                color: isCompletedMode ? Colors.grey : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (t.asignatura.isNotEmpty)
                  Text("Asignatura: ${t.asignatura}"),
                Text("Fecha: ${t.fecha.toLocal().toString().split(' ')[0]}"),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isCompletedMode ? Icons.undo : Icons.check_circle_outline,
                color: isCompletedMode ? Colors.green : null,
              ),
              onPressed: () async {
                final tareaActualizada = Tarea(
                  id: t.id,
                  titulo: t.titulo,
                  asignatura: t.asignatura,
                  descripcion: t.descripcion,
                  fecha: t.fecha,
                  completada: !isCompletedMode,
                );
                await controller.updateTarea(tareaActualizada);
                onRefresh();
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
