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
import '../../configuracion/presentation/settings_controller.dart';
import '../../../core/utils/notification_scheduler.dart';
import 'widgets/tarea_form.dart';

class TasksPage extends StatefulWidget {
  final SettingsController? settingsController;
  final TasksController? controller;

  const TasksPage({super.key, this.settingsController, this.controller});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late TasksController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      controller = widget.controller!;
      isLoading = false;
    } else {
      _initDependencies();
    }
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

    final settingsController = widget.settingsController;
    if (settingsController != null) {
      return ListenableBuilder(
        listenable: settingsController,
        builder: (context, _) => _buildScaffold(),
      );
    }

    return _buildScaffold();
  }

  Widget _buildScaffold() {
    final tareasFiltradas = controller.filtrarTareas(controller.tareas);
    final papeleraFiltrada = controller.buscarTareas(controller.papelera);
    final clasificacion = controller.clasificarTareas(tareasFiltradas);
    final settings = widget.settingsController;
    final visualDensity =
        settings?.visualDensity ?? VisualDensityPreference.comoda;
    final confirmDestructiveActions =
        settings?.confirmDestructiveActions ?? true;

    return Scaffold(
      body: ResponsiveLayout(
        mobile: MyMobileBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          clasificacion: clasificacion,
          papelera: papeleraFiltrada,
          visualDensityPreference: visualDensity,
          confirmDestructiveActions: confirmDestructiveActions,
        ),
        desktop: MyDesktopBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          clasificacion: clasificacion,
          papelera: papeleraFiltrada,
          visualDensityPreference: visualDensity,
          confirmDestructiveActions: confirmDestructiveActions,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}
