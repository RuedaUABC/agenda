import 'package:flutter/material.dart';

import '../../domain/tarea.dart';
import '../taskcontroller.dart';

class TareaForm extends StatefulWidget {
  final TasksController controller;
  final Tarea? tarea;
  final DateTime Function() now;

  const TareaForm({
    super.key,
    required this.controller,
    this.tarea,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  @override
  State<TareaForm> createState() => _TareaFormState();
}

class _TareaFormState extends State<TareaForm> {
  static const int maxTituloLength = 120;
  static const int maxAsignaturaLength = 80;
  static const int maxDescripcionLength = 500;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _asignaturaController;
  late final TextEditingController _descripcionController;
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;

  @override
  void initState() {
    super.initState();
    final defaultDateTime = widget.now().add(const Duration(hours: 1));
    _tituloController = TextEditingController(text: widget.tarea?.titulo ?? "");
    _asignaturaController = TextEditingController(
      text: widget.tarea?.asignatura ?? "",
    );
    _descripcionController = TextEditingController(
      text: widget.tarea?.descripcion ?? "",
    );
    _fechaSeleccionada = widget.tarea?.fecha ?? defaultDateTime;
    _horaSeleccionada = widget.tarea != null
        ? TimeOfDay.fromDateTime(widget.tarea!.fecha)
        : TimeOfDay.fromDateTime(defaultDateTime);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _asignaturaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  String? _validateTitulo(String? value) {
    final titulo = value?.trim() ?? "";
    if (titulo.isEmpty) return "El titulo es requerido";
    if (titulo.length > maxTituloLength) {
      return "El titulo no puede superar $maxTituloLength caracteres";
    }
    return null;
  }

  String? _validateAsignatura(String? value) {
    final asignatura = value?.trim() ?? "";
    if (asignatura.length > maxAsignaturaLength) {
      return "La asignatura no puede superar $maxAsignaturaLength caracteres";
    }
    return null;
  }

  String? _validateDescripcion(String? value) {
    final descripcion = value?.trim() ?? "";
    if (descripcion.length > maxDescripcionLength) {
      return "La descripcion no puede superar $maxDescripcionLength caracteres";
    }
    return null;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? widget.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _fechaSeleccionada) {
      setState(() => _fechaSeleccionada = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? TimeOfDay.fromDateTime(widget.now()),
    );

    if (picked != null && picked != _horaSeleccionada) {
      setState(() => _horaSeleccionada = picked);
    }
  }

  Future<bool> _confirmPastDate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fecha en el pasado"),
          content: const Text(
            "La fecha y hora de la tarea ya pasaron. Puedes revisar los datos o guardarla de todos modos.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Guardar de todos modos"),
            ),
          ],
        );
      },
    );

    return confirmed == true;
  }

  Future<void> _persistir(Tarea tarea) async {
    try {
      if (widget.tarea == null) {
        await widget.controller.createTarea(tarea);
      } else {
        await widget.controller.updateTarea(tarea);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.controller.lastError ?? 'No se pudo guardar la tarea',
            ),
          ),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaSeleccionada == null || _horaSeleccionada == null) return;

    final fechaCompleta = DateTime(
      _fechaSeleccionada!.year,
      _fechaSeleccionada!.month,
      _fechaSeleccionada!.day,
      _horaSeleccionada!.hour,
      _horaSeleccionada!.minute,
    );

    final nuevaTarea = Tarea(
      id: widget.tarea?.id ?? widget.now().microsecondsSinceEpoch.toString(),
      titulo: _tituloController.text.trim(),
      asignatura: _asignaturaController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      fecha: fechaCompleta,
      completada: widget.tarea?.completada ?? false,
      eliminada: widget.tarea?.eliminada ?? false,
    );

    if (fechaCompleta.isBefore(widget.now())) {
      final confirmed = await _confirmPastDate();
      if (!confirmed || !mounted) return;
    }

    await _persistir(nuevaTarea);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 40,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(onPressed: _guardar, child: const Text("Guardar")),
              Text(
                widget.tarea == null ? "Nueva Tarea" : "Editar Tarea",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: "Titulo",
                  border: OutlineInputBorder(),
                ),
                validator: _validateTitulo,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _asignaturaController,
                decoration: const InputDecoration(
                  labelText: "Asignatura",
                  border: OutlineInputBorder(),
                ),
                validator: _validateAsignatura,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: "Descripcion",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: _validateDescripcion,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaSeleccionada == null
                          ? "Seleccione Fecha"
                          : "Fecha: ${_fechaSeleccionada!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  TextButton(
                    onPressed: _selectDate,
                    child: const Text("Cambiar"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _horaSeleccionada == null
                          ? "Seleccione Hora"
                          : "Hora: ${_horaSeleccionada!.format(context)}",
                    ),
                  ),
                  TextButton(
                    onPressed: _selectTime,
                    child: const Text("Cambiar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
