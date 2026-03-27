import 'package:flutter/material.dart';
import 'package:agenda/core/widgets/desktop_colums.dart';
import 'package:agenda/features/home/presentation/widgets/task_card.dart';
import 'package:agenda/features/home/domain/tarea.dart';

class MyDesktopHome extends StatelessWidget {
  MyDesktopHome({super.key});

  final List<Widget> cards = [
    TaskCard(
      tarea: Tarea(
        id: "1",
        titulo: "Tarea 1",
        fecha: DateTime(2022, 1, 1),
        asignatura: "Matemáticas",
        descripcion: "Descripcion 1",
      ),
    ),
    TaskCard(
      tarea: Tarea(
        id: "1",
        titulo: "Tarea 2",
        fecha: DateTime(2022, 1, 2),
        asignatura: "Física",
        descripcion: "Descripcion 2",
      ),
    ),
    TaskCard(
      tarea: Tarea(
        id: "1",
        titulo: "Tarea 2",
        fecha: DateTime(2022, 1, 2),
        asignatura: "Física",
        descripcion: "Descripcion 2",
      ),
    ),
    TaskCard(
      tarea: Tarea(
        id: "1",
        titulo: "Tarea 2",
        fecha: DateTime(2022, 1, 2),
        asignatura: "Física",
        descripcion: "Descripcion 2",
      ),
    ),
    TaskCard(
      tarea: Tarea(
        id: "1",
        titulo: "Tarea 2",
        fecha: DateTime(2022, 1, 2),
        asignatura: "Física",
        descripcion: "Descripcion 2",
      ),
    ),
    TaskCard(
      tarea: Tarea(
        id: "1",
        titulo: "Tarea 2",
        fecha: DateTime(2022, 1, 2),
        asignatura: "Física",
        descripcion: "Descripcion 2",
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DesktopColumns(columnLeft: cards, columnRight: cards);
  }
}
