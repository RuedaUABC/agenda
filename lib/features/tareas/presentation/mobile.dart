import 'package:flutter/material.dart';

import '../../configuracion/preferences_helper.dart';
import '../domain/tarea.dart';
import 'taskcontroller.dart';
import 'widgets/lista_tareas_categoria.dart';
import 'widgets/panel_progreso.dart';
import 'widgets/tareas_filter_bar.dart';

class MyMobileBody extends StatelessWidget {
  final TasksController controller;
  final VoidCallback onRefresh;
  final Map<String, List<Tarea>> clasificacion;
  final List<Tarea> papelera;
  final VisualDensityPreference visualDensityPreference;
  final bool confirmDestructiveActions;

  const MyMobileBody({
    super.key,
    required this.controller,
    required this.onRefresh,
    required this.clasificacion,
    this.papelera = const [],
    this.visualDensityPreference = VisualDensityPreference.comoda,
    this.confirmDestructiveActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListView(
        children: [
          TareasFilterBar(controller: controller, onChanged: onRefresh),
          PanelProgreso(controller: controller),
          _category('Vencidas', clasificacion['vencidas'] ?? []),
          _category(
            'Pendientes esta semana',
            clasificacion['pendientesSemana'] ?? [],
          ),
          _category('Proximas', clasificacion['proximas'] ?? []),
          _category(
            'Completadas',
            clasificacion['completadas'] ?? [],
            isCompletedMode: true,
          ),
          _category('Papelera', papelera, isTrashMode: true),
        ],
      ),
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
    );
  }
}
