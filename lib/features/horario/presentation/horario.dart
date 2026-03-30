import 'package:flutter/material.dart';
import '../../../core/utils/responsive_layout.dart';
import 'desktop.dart';
import 'mobile.dart';
import 'horario_controller.dart';
import '../repository/horario_repository_impl.dart';
import '../data/clase_dao.dart';

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
    final repo = HorarioRepositoryImpl(
      claseDao: ClaseDao(),
    );

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
        onPressed: () {
          // TODO: Implementar formulario de nueva clase (similar a TareaForm)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
