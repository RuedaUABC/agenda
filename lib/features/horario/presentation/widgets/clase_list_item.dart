import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/clase.dart';

class ClaseListItem extends StatelessWidget {
  final Clase clase;
  final VisualDensity visualDensity;
  final FutureOr<void> Function()? onDelete;
  final bool confirmBeforeDelete;

  const ClaseListItem({
    super.key,
    required this.clase,
    this.visualDensity = VisualDensity.standard,
    this.onDelete,
    this.confirmBeforeDelete = true,
  });

  Future<void> _delete(BuildContext context) async {
    if (onDelete == null) return;
    if (!confirmBeforeDelete) {
      await Future<void>.sync(onDelete!);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar clase'),
          content: Text('¿Eliminar ${clase.materia}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await Future<void>.sync(onDelete!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final classColor = Color(clase.color);
    final timeFormat = DateFormat.Hm();
    final timeRange =
        '${timeFormat.format(clase.inicio)} - ${timeFormat.format(clase.fin)}';
    final compact = visualDensity == VisualDensity.compact;
    final contentPadding = compact
        ? const EdgeInsets.fromLTRB(8, 8, 12, 8)
        : const EdgeInsets.fromLTRB(12, 12, 16, 12);
    final iconSize = compact ? 36.0 : 40.0;
    final gap = compact ? 8.0 : 12.0;

    return Card.filled(
      margin: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: classColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: classColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school_outlined,
                            color: classColor,
                            semanticLabel: 'Clase',
                          ),
                        ),
                        SizedBox(width: gap),
                        Expanded(
                          child: Text(
                            clase.materia,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (onDelete != null)
                          IconButton(
                            tooltip: 'Eliminar clase ${clase.materia}',
                            onPressed: () => _delete(context),
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                    SizedBox(height: gap),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _MetadataChip(
                          icon: Icons.schedule_outlined,
                          label: timeRange,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        _MetadataChip(
                          icon: Icons.meeting_room_outlined,
                          label: clase.aula.isEmpty ? 'Sin aula' : clase.aula,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetadataChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
