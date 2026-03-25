import 'package:agenda/widgets/task_card.dart';
import 'package:flutter/material.dart';

class Tasklist extends StatelessWidget {
  const Tasklist({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsGeometry.all(8.0),
            child: TaskCard(
              name: "Tarea $index",
              vencimiento: "$index/$index/26",
              asignatura: "Asignatura $index",
            ),
          );
        },
      ),
    );
  }
}
