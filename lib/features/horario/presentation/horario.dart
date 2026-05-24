import 'package:flutter/material.dart';

import '../../../core/utils/responsive_layout.dart';
import '../../configuracion/preferences_helper.dart';
import '../../configuracion/presentation/settings_controller.dart';
import '../data/clase_dao.dart';
import '../domain/clase.dart';
import '../repository/horario_repository_impl.dart';
import 'desktop.dart';
import 'horario_controller.dart';
import 'mobile.dart';
import 'widgets/clase_form.dart';

class HorarioPage extends StatefulWidget {
  final SettingsController? settingsController;
  final HorarioController? controller;

  const HorarioPage({super.key, this.settingsController, this.controller});

  @override
  State<HorarioPage> createState() => _HorarioPageState();
}

class _HorarioPageState extends State<HorarioPage> {
  late HorarioController controller;
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
    final repo = HorarioRepositoryImpl(claseDao: ClaseDao());

    controller = HorarioController(repository: repo);
    await controller.loadClases();

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

    return Scaffold(
      body: ResponsiveLayout(
        mobile: MyMobileBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          weekStart: weekStart,
          visualDensity: visualDensity,
        ),
        desktop: MyDesktopBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          weekStart: weekStart,
          visualDensity: visualDensity,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showClaseForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showClaseForm() async {
    final clase = await showModalBottomSheet<Clase>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ClaseForm(
          initialDate: controller.selectedDate.value,
          clases: controller.clases,
        );
      },
    );

    if (clase == null) return;

    controller.selectedDate.value = clase.inicio;
    try {
      await controller.addClase(clase);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar la clase')),
        );
      }
      return;
    }

    if (mounted) {
      setState(() {});
    }
  }
}
