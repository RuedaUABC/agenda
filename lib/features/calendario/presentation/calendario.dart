import 'package:flutter/material.dart';

import '../../../core/utils/responsive_layout.dart';
import '../../../core/utils/notification_scheduler.dart';
import '../../configuracion/preferences_helper.dart';
import '../../configuracion/presentation/settings_controller.dart';
import '../data/evento_dao.dart';
import '../domain/evento.dart';
import '../repository/calendario_repository_impl.dart';
import 'calendario_controller.dart';
import 'desktop.dart';
import 'mobile.dart';
import 'widgets/evento_form.dart';

class CalendarioPage extends StatefulWidget {
  final CalendarioController? controller;
  final SettingsController? settingsController;

  const CalendarioPage({super.key, this.controller, this.settingsController});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late CalendarioController controller;
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
    final repo = CalendarioRepositoryImpl(
      eventoDao: EventoDao(),
      prefs: prefs,
      scheduler: scheduler,
    );

    controller = CalendarioController(repository: repo);
    await controller.loadEventos();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
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
    final settings = widget.settingsController;
    final weekStart = settings?.weekStart ?? WeekStartPreference.lunes;
    final visualDensity =
        settings?.materialVisualDensity ?? VisualDensity.standard;
    final confirmDestructiveActions =
        settings?.confirmDestructiveActions ?? true;

    return Scaffold(
      body: ResponsiveLayout(
        mobile: MyMobileBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          onEditEvento: _showEventoForm,
          onDeleteEvento: _deleteEvento,
          weekStart: weekStart,
          visualDensity: visualDensity,
          confirmDestructiveActions: confirmDestructiveActions,
        ),
        desktop: MyDesktopBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          onEditEvento: _showEventoForm,
          onDeleteEvento: _deleteEvento,
          weekStart: weekStart,
          visualDensity: visualDensity,
          confirmDestructiveActions: confirmDestructiveActions,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventoForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showEventoForm([Evento? evento]) async {
    final savedEvento = await showModalBottomSheet<Evento>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return EventoForm(
          initialDate: evento?.inicio ?? controller.selectedDate.value,
          evento: evento,
          eventos: controller.eventos,
        );
      },
    );

    if (savedEvento == null) return;

    controller.selectedDate.value = savedEvento.inicio;
    try {
      if (evento == null) {
        await controller.addEvento(savedEvento);
      } else {
        await controller.updateEvento(savedEvento);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el evento')),
        );
      }
      return;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteEvento(Evento evento) async {
    try {
      await controller.deleteEvento(evento.id);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo eliminar el evento')),
        );
      }
      return;
    }

    if (!mounted) return;

    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Evento eliminado')));
  }
}
