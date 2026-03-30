import 'package:flutter/material.dart';
import '../../../core/utils/responsive_layout.dart';
import 'desktop.dart';
import 'mobile.dart';
import 'calendario_controller.dart';
import '../repository/calendario_repository_impl.dart';
import '../data/evento_dao.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late CalendarioController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDependencies();
  }

  Future<void> _initDependencies() async {
    final repo = CalendarioRepositoryImpl(
      eventoDao: EventoDao(),
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
          // TODO: Implementar formulario de nuevo evento
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
