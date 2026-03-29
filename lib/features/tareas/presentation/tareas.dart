import 'package:agenda/features/tareas/presentation/desktop.dart';
import 'package:agenda/features/tareas/presentation/mobile.dart';
import 'package:agenda/core/utils/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'taskcontroller.dart';
import '../repository/tareas_repository_impt.dart';
import '../data/tarea_dao.dart';
import '../data/notificacion_dao.dart';
import '../data/tarea_service.dart';
import '../../configuracion/preferences_helper.dart';
import '../../../core/utils/notification_scheduler.dart';
import 'widgets/tarea_form.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late TasksController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDependencies();
  }

  Future<void> _initDependencies() async {
    final prefs = PreferencesHelper();
    await prefs.init();

    final scheduler = NotificationScheduler();
    await scheduler.init();

    final repo = TareaRepositoryImpl(
      tareaDao: TareaDao(),
      notifDao: NotificacionDao(),
      tareaService: TareaService(),
      prefs: prefs,
      scheduler: scheduler,
    );

    controller = TasksController(repository: repo);
    await controller.loadTareas();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _abrirFormulario() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TareaForm(controller: controller);
      },
    );

    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final clasificacion = controller.clasificarTareas();

    return Scaffold(
      body: ResponsiveLayout(
        mobile: MyMobileBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          clasificacion: clasificacion,
        ),
        desktop: MyDesktopBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          clasificacion: clasificacion,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}
