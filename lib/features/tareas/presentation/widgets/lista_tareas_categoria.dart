import 'package:flutter/material.dart';
import '../../domain/tarea.dart';
import '../taskcontroller.dart';
import 'tarea_form.dart';

class ListaTareasCategoria extends StatelessWidget {
  const ListaTareasCategoria({
    super.key,
    required this.controller,
    required this.onRefresh,
    required this.title,
    required this.tareas,
    this.isCompletedMode = false,
    this.isTrashMode = false,
  });

  final TasksController controller;
  final VoidCallback onRefresh;
  final String title;
  final List<Tarea> tareas;
  final bool isCompletedMode;
  final bool isTrashMode;

  Future<void> _abrirDetalle(BuildContext context, Tarea tarea) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _TareaDetalle(
          controller: controller,
          tarea: tarea,
          isCompletedMode: isCompletedMode,
          isTrashMode: isTrashMode,
        );
      },
    );

    if (result == true) {
      onRefresh();
    }
  }

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
            onTap: () => _abrirDetalle(context, t),
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
            trailing: isTrashMode
                ? null
                : IconButton(
                    tooltip: isCompletedMode
                        ? "Marcar como pendiente"
                        : "Marcar como completada",
                    icon: Icon(
                      isCompletedMode ? Icons.undo : Icons.check_circle_outline,
                    ),
                    onPressed: () async {
                      await controller.updateTarea(
                        t.copyWith(completada: !isCompletedMode),
                      );
                      onRefresh();
                    },
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _TareaDetalle extends StatelessWidget {
  const _TareaDetalle({
    required this.controller,
    required this.tarea,
    required this.isCompletedMode,
    required this.isTrashMode,
  });

  final TasksController controller;
  final Tarea tarea;
  final bool isCompletedMode;
  final bool isTrashMode;

  Future<void> _confirmarEliminacion(BuildContext context, Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Eliminar tarea"),
          content: Text("¿Quieres eliminar la tarea ${tarea.titulo}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("No"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Sí"),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await controller.deleteTarea(tarea.id);
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _editarTarea(BuildContext context, Tarea tarea) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TareaForm(controller: controller, tarea: tarea);
      },
    );

    if (result == true) {
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fecha = tarea.fecha.toLocal().toString().split('.').first;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      tarea.titulo,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    tooltip: "Cerrar",
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DetalleDato(
                label: "Asignatura",
                value: tarea.asignatura.isEmpty
                    ? "Sin asignatura"
                    : tarea.asignatura,
              ),
              _DetalleDato(
                label: "Descripcion",
                value: tarea.descripcion.isEmpty
                    ? "Sin descripcion"
                    : tarea.descripcion,
              ),
              _DetalleDato(label: "Fecha", value: fecha),
              _DetalleDato(
                label: "Estado",
                value: tarea.completada ? "Completada" : "Pendiente",
              ),
              const SizedBox(height: 16),
              if (isTrashMode)
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.restore),
                        label: const Text("Recuperar"),
                        onPressed: () async {
                          await controller.restoreTarea(tarea.id);
                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(
                          isCompletedMode
                              ? Icons.undo
                              : Icons.check_circle_outline,
                        ),
                        label: Text(
                          isCompletedMode ? "Pendiente" : "Completar",
                        ),
                        onPressed: () async {
                          await controller.updateTarea(
                            tarea.copyWith(completada: !isCompletedMode),
                          );
                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text("Editar"),
                        onPressed: () => _editarTarea(context, tarea),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("Eliminar"),
                        onPressed: () => _confirmarEliminacion(context, tarea),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetalleDato extends StatelessWidget {
  const _DetalleDato({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
