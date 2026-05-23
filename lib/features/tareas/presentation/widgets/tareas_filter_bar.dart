import 'package:flutter/material.dart';

import '../taskcontroller.dart';

class TareasFilterBar extends StatelessWidget {
  final TasksController controller;
  final VoidCallback onChanged;

  const TareasFilterBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<TaskStatusFilter>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: TaskStatusFilter.todas,
                label: Text('Todas'),
              ),
              ButtonSegment(
                value: TaskStatusFilter.pendientes,
                label: Text('Pendientes'),
              ),
              ButtonSegment(
                value: TaskStatusFilter.completadas,
                label: Text('Completadas'),
              ),
            ],
            selected: {controller.statusFilter},
            onSelectionChanged: (selection) {
              controller.updateStatusFilter(selection.single);
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}
