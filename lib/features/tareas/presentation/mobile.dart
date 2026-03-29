import 'package:flutter/material.dart';
import 'taskcontroller.dart';
import '../domain/tarea.dart';
import 'widgets/lista_tareas_categoria.dart';
import 'widgets/panel_progreso.dart';

class MyMobileBody extends StatelessWidget {
  final TasksController controller;
  final VoidCallback onRefresh;
  final Map<String, List<Tarea>> clasificacion;

  const MyMobileBody({
    super.key,
    required this.controller,
    required this.onRefresh,
    required this.clasificacion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListView(
        children: [
          PanelProgreso(controller: controller),
          ListaTareasCategoria(
            controller: controller,
            onRefresh: onRefresh,
            title: "Vencidas",
            tareas: clasificacion["vencidas"] ?? [],
            context: context,
          ),
          ListaTareasCategoria(
            controller: controller,
            onRefresh: onRefresh,
            title: "Pendientes esta semana",
            tareas: clasificacion["pendientesSemana"] ?? [],
            context: context,
          ),
          ListaTareasCategoria(
            controller: controller,
            onRefresh: onRefresh,
            title: "Próximas",
            tareas: clasificacion["proximas"] ?? [],
            context: context,
          ),
          ListaTareasCategoria(
            controller: controller,
            onRefresh: onRefresh,
            title: "Completadas",
            tareas: clasificacion["completadas"] ?? [],
            context: context,
            isCompletedMode: true,
          ),
        ],
      ),
    );
  }
}
