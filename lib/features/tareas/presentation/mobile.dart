import 'package:flutter/material.dart';
import 'taskcontroller.dart';
import '../domain/tarea.dart';
import 'widgets/lista_tareas_categoria.dart';
import 'widgets/panel_progreso.dart';
import 'widgets/tareas_filter_bar.dart';

class MyMobileBody extends StatelessWidget {
  final TasksController controller;
  final VoidCallback onRefresh;
  final Map<String, List<Tarea>> clasificacion;
  final List<Tarea> papelera;

  const MyMobileBody({
    super.key,
    required this.controller,
    required this.onRefresh,
    required this.clasificacion,
    this.papelera = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListView(
        children: [
          TareasFilterBar(controller: controller, onChanged: onRefresh),
          PanelProgreso(controller: controller),
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
    );
  }
}
