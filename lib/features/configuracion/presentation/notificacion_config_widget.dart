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
        return _SettingsSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationHeader(),
              const SizedBox(height: 8),
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
          ),
        );
      },
    );
  }
}

class _NotificationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.notifications_active_outlined,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notificaciones globales',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                'Define los recordatorios predeterminados por modulo',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsSurface extends StatelessWidget {
  final Widget child;

  const _SettingsSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 560;
        final controlWidth = isWide
            ? 240.0
            : (constraints.maxWidth - 56)
                  .clamp(0.0, constraints.maxWidth)
                  .toDouble();
        final dropdown = DropdownMenu<int>(
          width: controlWidth,
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
        );

        if (isWide) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 44,
            leading: Icon(widget.icon),
            title: Text(widget.title),
            subtitle: Text(widget.subtitle),
            trailing: dropdown,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 44,
              leading: Icon(widget.icon),
              title: Text(widget.title),
              subtitle: Text(widget.subtitle),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(56, 0, 0, 12),
              child: dropdown,
            ),
          ],
        );
      },
    );
  }
}
