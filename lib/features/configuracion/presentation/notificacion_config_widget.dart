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
    if (minutes == 0) return 'Sin recordatorio';
    if (minutes >= 1440) return '${minutes ~/ 1440} dia(s) antes';
    if (minutes >= 60) return '${minutes ~/ 60} hora(s) antes';
    return '$minutes minutos antes';
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notificaciones globales',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _NotificationTile(
              icon: Icons.school_outlined,
              title: 'Clases',
              subtitle: 'Anticipacion para recordatorios de horario',
              initialSelection: controller.globalClaseNotif.inMinutes,
              options: opcionesMinutos,
              formatDuration: _formatDuration,
              onSelected: (minutes) {
                return controller.updateGlobalClaseNotif(
                  Duration(minutes: minutes),
                );
              },
            ),
            const Divider(height: 1),
            _NotificationTile(
              icon: Icons.event_outlined,
              title: 'Eventos',
              subtitle: 'Anticipacion para recordatorios del calendario',
              initialSelection: controller.globalEventoNotif.inMinutes,
              options: opcionesMinutos,
              formatDuration: _formatDuration,
              onSelected: (minutes) {
                return controller.updateGlobalEventoNotif(
                  Duration(minutes: minutes),
                );
              },
            ),
            const Divider(height: 1),
            _NotificationTile(
              icon: Icons.task_alt,
              title: 'Tareas (primer aviso)',
              subtitle: 'Anticipacion para el primer recordatorio',
              initialSelection: controller.globalTareaNotifs.isNotEmpty
                  ? controller.globalTareaNotifs.first.inMinutes
                  : 60,
              options: opcionesMinutos,
              formatDuration: _formatDuration,
              onSelected: (minutes) {
                final actual = [...controller.globalTareaNotifs];
                if (actual.isEmpty) {
                  actual.add(Duration(minutes: minutes));
                } else {
                  actual[0] = Duration(minutes: minutes);
                }
                return controller.updateGlobalTareaNotifs(actual);
              },
            ),
          ],
        );
      },
    );
  }
}

class _NotificationTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int initialSelection;
  final List<int> options;
  final String Function(int minutes) formatDuration;
  final Future<void> Function(int minutes) onSelected;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.initialSelection,
    required this.options,
    required this.formatDuration,
    required this.onSelected,
  });

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  late int _selected = widget.initialSelection;

  @override
  void didUpdateWidget(covariant _NotificationTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelection != widget.initialSelection) {
      _selected = widget.initialSelection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon),
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      trailing: DropdownMenu<int>(
        initialSelection: _selected,
        dropdownMenuEntries: widget.options.map((minutes) {
          return DropdownMenuEntry<int>(
            value: minutes,
            label: widget.formatDuration(minutes),
          );
        }).toList(),
        onSelected: (value) async {
          if (value == null) return;
          try {
            await widget.onSelected(value);
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
          if (mounted) setState(() => _selected = value);
        },
      ),
    );
  }
}
