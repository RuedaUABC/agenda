import 'package:flutter/material.dart';
import 'settings_controller.dart';

class NotificacionConfigWidget extends StatefulWidget {
  final SettingsController controller;

  const NotificacionConfigWidget({super.key, required this.controller});

  @override
  State<NotificacionConfigWidget> createState() =>
      _NotificacionConfigWidgetState();
}

class _NotificacionConfigWidgetState extends State<NotificacionConfigWidget> {
  final List<int> opcionesMinutos = [5, 10, 15, 30, 60, 120, 1440];

  String _formatDuration(int minutes) {
    if (minutes >= 1440) return '${minutes ~/ 1440} día(s) antes';
    if (minutes >= 60) return '${minutes ~/ 60} hora(s) antes';
    return '$minutes minutos antes';
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notificaciones Globales",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              "Clases",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: controller.globalClaseNotif.inMinutes,
              isExpanded: true,
              items: opcionesMinutos.map((min) {
                return DropdownMenuItem<int>(
                  value: min,
                  child: Text(_formatDuration(min)),
                );
              }).toList(),
              onChanged: (val) async {
                if (val != null) {
                  await controller
                      .updateGlobalClaseNotif(Duration(minutes: val));
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Tareas (Primer Aviso)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: controller.globalTareaNotifs.isNotEmpty
                  ? controller.globalTareaNotifs.first.inMinutes
                  : 60,
              isExpanded: true,
              items: opcionesMinutos.map((min) {
                return DropdownMenuItem<int>(
                  value: min,
                  child: Text(_formatDuration(min)),
                );
              }).toList(),
              onChanged: (val) async {
                if (val != null) {
                  // Mantiene el segundo aviso (si existe) pero actualiza el primero
                  List<Duration> actual = [...controller.globalTareaNotifs];
                  if (actual.isEmpty) {
                    actual.add(Duration(minutes: val));
                  } else {
                    actual[0] = Duration(minutes: val);
                  }
                  await controller.updateGlobalTareaNotifs(actual);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
