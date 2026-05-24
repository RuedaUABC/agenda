import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/evento.dart';

class EventoListItem extends StatelessWidget {
  final Evento evento;
  final VoidCallback? onTap;
  final FutureOr<void> Function()? onDelete;
  final EdgeInsetsGeometry margin;
  final bool confirmBeforeDelete;
  final VisualDensity visualDensity;

  const EventoListItem({
    super.key,
    required this.evento,
    this.onTap,
    this.onDelete,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.confirmBeforeDelete = true,
    this.visualDensity = VisualDensity.standard,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    if (!confirmBeforeDelete) {
      await Future<void>.sync(() => onDelete?.call());
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar evento'),
          content: Text('Esta accion eliminara "${evento.titulo}".'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await Future<void>.sync(() => onDelete?.call());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final eventColor = Color(evento.color);
    final description = evento.descripcion.trim();
    final timeFormat = DateFormat.Hm();
    final timeRange =
        '${timeFormat.format(evento.inicio)} - ${timeFormat.format(evento.fin)}';
    final compact = visualDensity == VisualDensity.compact;
    final contentPadding = compact
        ? const EdgeInsets.fromLTRB(8, 8, 6, 8)
        : const EdgeInsets.fromLTRB(12, 12, 8, 12);
    final iconSize = compact ? 36.0 : 40.0;
    final gap = compact ? 8.0 : 12.0;

    return Card.filled(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: eventColor,
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
                              color: eventColor.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.event_outlined,
                              color: eventColor,
                              semanticLabel: 'Evento',
                            ),
                          ),
                          SizedBox(width: gap),
                          Expanded(
                            child: Text(
                              evento.titulo,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (onDelete != null)
                            IconButton(
                              tooltip: 'Eliminar evento ${evento.titulo}',
                              onPressed: () => _confirmDelete(context),
                              icon: const Icon(Icons.delete_outline),
                              color: colorScheme.error,
                            ),
                        ],
                      ),
                      SizedBox(height: gap),
                      _MetadataLine(
                        icon: Icons.schedule_outlined,
                        label: timeRange,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      if (description.isNotEmpty) ...[
                        SizedBox(height: compact ? 6 : 8),
                        _MetadataLine(
                          icon: Icons.notes_outlined,
                          label: description,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetadataLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetadataLine({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
