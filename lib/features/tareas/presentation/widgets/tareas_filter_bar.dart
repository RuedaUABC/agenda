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
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Buscar tareas',
            onChanged: (value) {
              controller.updateSearchQuery(value);
              onChanged();
            },
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 12),
          DropdownMenu<TaskDateFilter>(
            initialSelection: controller.dateFilter,
            expandedInsets: EdgeInsets.zero,
            label: const Text('Fecha'),
            dropdownMenuEntries: const [
              DropdownMenuEntry(
                value: TaskDateFilter.todas,
                label: 'Cualquier fecha',
              ),
              DropdownMenuEntry(
                value: TaskDateFilter.vencidas,
                label: 'Vencidas',
              ),
              DropdownMenuEntry(value: TaskDateFilter.hoy, label: 'Hoy'),
              DropdownMenuEntry(
                value: TaskDateFilter.semana,
                label: 'Esta semana',
              ),
              DropdownMenuEntry(
                value: TaskDateFilter.futuras,
                label: 'Futuras',
              ),
            ],
            onSelected: (value) {
              if (value == null) return;
              controller.updateDateFilter(value);
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}
