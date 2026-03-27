import 'package:flutter/material.dart';
import 'package:agenda/features/home/domain/tarea.dart';

class TaskCard extends StatelessWidget {
  final Tarea tarea;

  const TaskCard({super.key, required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tarea.titulo),
        Text(tarea.asignatura),
        Text(tarea.fecha.toString()),
      ],
    );
  }
}
