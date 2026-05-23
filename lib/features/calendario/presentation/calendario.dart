import 'package:flutter/material.dart';

import '../../../core/utils/responsive_layout.dart';
import '../data/evento_dao.dart';
import '../domain/evento.dart';
import '../repository/calendario_repository_impl.dart';
import 'calendario_controller.dart';
import 'desktop.dart';
import 'mobile.dart';
import 'widgets/evento_form.dart';

class CalendarioPage extends StatefulWidget {
  final CalendarioController? controller;

  const CalendarioPage({super.key, this.controller});

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
    final repo = CalendarioRepositoryImpl(eventoDao: EventoDao());

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
          onEditEvento: _showEventoForm,
          onDeleteEvento: _deleteEvento,
        ),
        desktop: MyDesktopBody(
          controller: controller,
          onRefresh: () => setState(() {}),
          onEditEvento: _showEventoForm,
          onDeleteEvento: _deleteEvento,
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
