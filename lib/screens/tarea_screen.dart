import '../models/tarea.dart';
import '../widgets/tarea_card.dart';

class TareaScreen extends StatelessWidget {
  final List<Tarea> tareas;

  TareaScreen({required this.tareas});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: tareas.map((t) => TareaCard(tarea: t)).toList(),
    );
  }
}
