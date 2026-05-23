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
          TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar tareas',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              controller.updateSearchQuery(value);
              onChanged();
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DropdownButton<TaskStatusFilter>(
                value: controller.statusFilter,
                items: const [
                  DropdownMenuItem(
                    value: TaskStatusFilter.todas,
                    child: Text('Todas'),
                  ),
                  DropdownMenuItem(
                    value: TaskStatusFilter.pendientes,
                    child: Text('Pendientes'),
                  ),
                  DropdownMenuItem(
                    value: TaskStatusFilter.completadas,
                    child: Text('Completadas'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  controller.updateStatusFilter(value);
                  onChanged();
                },
              ),
              DropdownButton<TaskDateFilter>(
                value: controller.dateFilter,
                items: const [
                  DropdownMenuItem(
                    value: TaskDateFilter.todas,
                    child: Text('Cualquier fecha'),
                  ),
                  DropdownMenuItem(
                    value: TaskDateFilter.vencidas,
                    child: Text('Vencidas'),
                  ),
                  DropdownMenuItem(
                    value: TaskDateFilter.hoy,
                    child: Text('Hoy'),
                  ),
                  DropdownMenuItem(
                    value: TaskDateFilter.semana,
                    child: Text('Esta semana'),
                  ),
                  DropdownMenuItem(
                    value: TaskDateFilter.futuras,
                    child: Text('Futuras'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  controller.updateDateFilter(value);
                  onChanged();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
