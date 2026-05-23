import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/evento.dart';

class EventoListItem extends StatelessWidget {
  final Evento evento;
  final VoidCallback? onTap;
  final FutureOr<void> Function()? onDelete;
  final EdgeInsetsGeometry margin;

  const EventoListItem({
    super.key,
    required this.evento,
    this.onTap,
    this.onDelete,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  Future<void> _confirmDelete(BuildContext context) async {
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
    final description = evento.descripcion.trim();

    return Card(
      margin: margin,
      child: ListTile(
        leading: Container(
          width: 4,
          decoration: BoxDecoration(
            color: Color(evento.color),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          evento.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: description.isEmpty ? null : Text(description),
        trailing: onDelete == null
            ? null
            : IconButton(
                tooltip: 'Eliminar evento ${evento.titulo}',
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline),
              ),
        onTap: onTap,
      ),
    );
  }
}
