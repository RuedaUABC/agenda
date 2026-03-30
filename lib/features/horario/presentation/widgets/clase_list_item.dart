import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/clase.dart';

class ClaseListItem extends StatelessWidget {
  final Clase clase;

  const ClaseListItem({super.key, required this.clase});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.Hm();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(clase.materia),
        subtitle: Text('${clase.aula} • ${timeFormat.format(clase.inicio)} - ${timeFormat.format(clase.fin)}'),
        leading: CircleAvatar(
          backgroundColor: Color(clase.color),
          child: const Icon(Icons.class_, color: Colors.white),
        ),
      ),
    );
  }
}
