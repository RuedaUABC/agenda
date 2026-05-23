import 'package:flutter/material.dart';
import 'taskcontroller.dart';
import '../domain/tarea.dart';
import 'widgets/panel_progreso.dart';
import 'widgets/lista_tareas_categoria.dart';
import 'widgets/tareas_filter_bar.dart';

class MyDesktopBody extends StatelessWidget {
  final TasksController controller;
  final VoidCallback onRefresh;
  final Map<String, List<Tarea>> clasificacion;
  final List<Tarea> papelera;

  const MyDesktopBody({
    super.key,
    required this.controller,
    required this.onRefresh,
    required this.clasificacion,
    this.papelera = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda: Listado de tareas activas
        Expanded(
          flex: 13,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              TareasFilterBar(controller: controller, onChanged: onRefresh),
              PanelProgreso(controller: controller),
              const SizedBox(height: 16),
              ListaTareasCategoria(
                controller: controller,
                onRefresh: onRefresh,
                title: "Vencidas",
                tareas: clasificacion["vencidas"] ?? [],
              ),
              ListaTareasCategoria(
                controller: controller,
                onRefresh: onRefresh,
                title: "Pendientes esta semana",
                tareas: clasificacion["pendientesSemana"] ?? [],
              ),
              ListaTareasCategoria(
                controller: controller,
                onRefresh: onRefresh,
                title: "Próximas",
                tareas: clasificacion["proximas"] ?? [],
              ),
            ],
          ),
        ),
        // Columna derecha: Estadísticas, vencidas y completadas
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListaTareasCategoria(
                  controller: controller,
                  onRefresh: onRefresh,
                  title: "Completadas",
                  tareas: clasificacion["completadas"] ?? [],
                  isCompletedMode: true,
                ),
                ListaTareasCategoria(
                  controller: controller,
                  onRefresh: onRefresh,
                  title: "Papelera",
                  tareas: papelera,
                  isTrashMode: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
