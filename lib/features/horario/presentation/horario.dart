import 'package:flutter/material.dart';

import '../../../core/utils/responsive_layout.dart';
import '../data/clase_dao.dart';
import '../domain/clase.dart';
import '../repository/horario_repository_impl.dart';
import 'desktop.dart';
import 'horario_controller.dart';
import 'mobile.dart';
import 'widgets/clase_form.dart';

class HorarioPage extends StatefulWidget {
  const HorarioPage({super.key});

  @override
  State<HorarioPage> createState() => _HorarioPageState();
}

class _HorarioPageState extends State<HorarioPage> {
  late HorarioController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDependencies();
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

    return Scaffold(
      body: ResponsiveLayout(
        mobile: MyMobileBody(
          controller: controller,
          onRefresh: () => setState(() {}),
        ),
        desktop: MyDesktopBody(
          controller: controller,
          onRefresh: () => setState(() {}),
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
