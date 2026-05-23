import 'package:agenda/core/widgets/agenda_empty_state.dart';
import 'package:agenda/core/widgets/agenda_section_header.dart';
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
    if (tareas.isEmpty) {
      return AgendaEmptyState(
        icon: Icons.task_alt,
        title: 'Sin tareas en $title',
        description: 'Cuando haya elementos para esta seccion apareceran aqui.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AgendaSectionHeader(title: title, count: tareas.length),
        ...tareas.map((t) {
          return Card(
            child: ListTile(
              onTap: () => _abrirDetalle(context, t),
              leading: isTrashMode
                  ? null
                  : Tooltip(
                      message: isCompletedMode
                          ? "Marcar como pendiente"
                          : "Marcar como completada",
                      child: Checkbox(
                        value: isCompletedMode,
                        onChanged: (_) async {
                          try {
                            await controller.updateTarea(
                              t.copyWith(completada: !isCompletedMode),
                            );
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    controller.lastError ??
                                        'No se pudo completar la accion',
                                  ),
                                ),
                              );
                            }
                            return;
                          }
                          onRefresh();
                        },
                      ),
                    ),
              title: Text(
                t.titulo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: isCompletedMode
                      ? TextDecoration.lineThrough
                      : null,
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
                      tooltip: 'Abrir detalle',
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => _abrirDetalle(context, t),
                    ),
            ),
          );
        }),
      ],
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
      try {
        await controller.deleteTarea(tarea.id);
      } catch (_) {
        if (context.mounted) {
          _showError(context);
        }
        return;
      }
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _confirmarEliminacionDefinitiva(
    BuildContext context,
    Tarea tarea,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Eliminar definitivamente"),
          content: Text(
            "Esta accion no se puede deshacer. ¿Eliminar ${tarea.titulo}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Cancelar"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await controller.deleteTareaDefinitiva(tarea.id);
      } catch (_) {
        if (context.mounted) {
          _showError(context);
        }
        return;
      }
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

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(controller.lastError ?? 'No se pudo completar la accion'),
      ),
    );
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
                          try {
                            await controller.restoreTarea(tarea.id);
                          } catch (_) {
                            if (context.mounted) {
                              _showError(context);
                            }
                            return;
                          }
                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.delete_forever_outlined),
                        label: const Text("Eliminar definitivo"),
                        onPressed: () =>
                            _confirmarEliminacionDefinitiva(context, tarea),
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
                          try {
                            await controller.updateTarea(
                              tarea.copyWith(completada: !isCompletedMode),
                            );
                          } catch (_) {
                            if (context.mounted) {
                              _showError(context);
                            }
                            return;
                          }
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
