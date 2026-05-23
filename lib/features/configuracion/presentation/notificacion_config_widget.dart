import 'package:flutter/material.dart';
import '../preferences_helper.dart';
import 'settings_controller.dart';

class NotificacionConfigWidget extends StatefulWidget {
  final SettingsController controller;

  const NotificacionConfigWidget({super.key, required this.controller});

  @override
  State<NotificacionConfigWidget> createState() =>
      _NotificacionConfigWidgetState();
}

class _NotificacionConfigWidgetState extends State<NotificacionConfigWidget> {
  final List<int> opcionesMinutos =
      PreferencesHelper.allowedNotificationMinutes;

  String _formatDuration(int minutes) {
    if (minutes >= 1440) return '${minutes ~/ 1440} día(s) antes';
    if (minutes >= 60) return '${minutes ~/ 60} hora(s) antes';
    return '$minutes minutos antes';
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notificaciones globales",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.school_outlined),
          title: const Text("Clases"),
          subtitle: const Text("Anticipacion para recordatorios de horario"),
          trailing: DropdownMenu<int>(
            initialSelection: controller.globalClaseNotif.inMinutes,
            dropdownMenuEntries: opcionesMinutos.map((min) {
              return DropdownMenuEntry<int>(
                value: min,
                label: _formatDuration(min),
              );
            }).toList(),
            onSelected: (val) async {
              if (val != null) {
                try {
                  await controller.updateGlobalClaseNotif(
                    Duration(minutes: val),
                  );
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Valor de notificacion no permitido'),
                      ),
                    );
                  }
                  return;
                }
                setState(() {});
              }
            },
          ),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.task_alt),
          title: const Text("Tareas (primer aviso)"),
          subtitle: const Text("Anticipacion para el primer recordatorio"),
          trailing: DropdownMenu<int>(
            initialSelection: controller.globalTareaNotifs.isNotEmpty
                ? controller.globalTareaNotifs.first.inMinutes
                : 60,
            dropdownMenuEntries: opcionesMinutos.map((min) {
              return DropdownMenuEntry<int>(
                value: min,
                label: _formatDuration(min),
              );
            }).toList(),
            onSelected: (val) async {
              if (val != null) {
                List<Duration> actual = [...controller.globalTareaNotifs];
                if (actual.isEmpty) {
                  actual.add(Duration(minutes: val));
                } else {
                  actual[0] = Duration(minutes: val);
                }
                try {
                  await controller.updateGlobalTareaNotifs(actual);
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Valor de notificacion no permitido'),
                      ),
                    );
                  }
                  return;
                }
                setState(() {});
              }
            },
          ),
        ),
      ],
    );
  }
}
