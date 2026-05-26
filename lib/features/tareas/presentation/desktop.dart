import 'package:flutter/material.dart';

import '../../configuracion/preferences_helper.dart';
import '../domain/tarea.dart';
import 'taskcontroller.dart';
import 'widgets/lista_tareas_categoria.dart';
import 'widgets/panel_progreso.dart';
import 'widgets/tareas_filter_bar.dart';

class MyDesktopBody extends StatelessWidget {
  final TasksController controller;
  final VoidCallback onRefresh;
  final VoidCallback? onCreateTask;
  final Map<String, List<Tarea>> clasificacion;
  final List<Tarea> papelera;
  final VisualDensityPreference visualDensityPreference;
  final bool confirmDestructiveActions;

  const MyDesktopBody({
    super.key,
    required this.controller,
    required this.onRefresh,
    this.onCreateTask,
    required this.clasificacion,
    this.papelera = const [],
    this.visualDensityPreference = VisualDensityPreference.comoda,
    this.confirmDestructiveActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 13,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              TareasFilterBar(controller: controller, onChanged: onRefresh),
              PanelProgreso(controller: controller),
              const SizedBox(height: 16),
              _category('Vencidas', clasificacion['vencidas'] ?? []),
              _category(
                'Pendientes esta semana',
                clasificacion['pendientesSemana'] ?? [],
              ),
              _category('Proximas', clasificacion['proximas'] ?? []),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _category(
                  'Completadas',
                  clasificacion['completadas'] ?? [],
                  isCompletedMode: true,
                ),
                _category('Papelera', papelera, isTrashMode: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _category(
    String title,
    List<Tarea> tareas, {
    bool isCompletedMode = false,
    bool isTrashMode = false,
  }) {
    return ListaTareasCategoria(
      controller: controller,
      onRefresh: onRefresh,
      title: title,
      tareas: tareas,
      isCompletedMode: isCompletedMode,
      isTrashMode: isTrashMode,
      visualDensityPreference: visualDensityPreference,
      confirmDestructiveActions: confirmDestructiveActions,
      onCreateTask: isTrashMode || isCompletedMode ? null : onCreateTask,
    );
  }
}
