import 'package:flutter/material.dart';
import 'package:agenda/core/widgets/agenda_date_time_button.dart';

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
  String? _duplicateError;

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
    if (_duplicateError != null) return _duplicateError;
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
      setState(() {
        _fechaSeleccionada = picked;
        _duplicateError = null;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? TimeOfDay.fromDateTime(widget.now()),
    );

    if (picked != null && picked != _horaSeleccionada) {
      setState(() {
        _horaSeleccionada = picked;
        _duplicateError = null;
      });
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _normalizeDuplicateText(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  bool _sameTaskData(Tarea current, Tarea other) {
    return _normalizeDuplicateText(current.titulo) ==
            _normalizeDuplicateText(other.titulo) &&
        _normalizeDuplicateText(current.asignatura) ==
            _normalizeDuplicateText(other.asignatura) &&
        _normalizeDuplicateText(current.descripcion) ==
            _normalizeDuplicateText(other.descripcion) &&
        current.fecha.isAtSameMomentAs(other.fecha);
  }

  bool _hasDuplicate(Tarea tarea) {
    return [...widget.controller.tareas, ...widget.controller.papelera].any((
      existing,
    ) {
      return existing.id != tarea.id && _sameTaskData(tarea, existing);
    });
  }

  void _clearDuplicateError(String _) {
    if (_duplicateError == null) return;
    setState(() => _duplicateError = null);
  }

  void _guardar() async {
    _duplicateError = null;
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

    if (_hasDuplicate(nuevaTarea)) {
      setState(
        () => _duplicateError = 'Ya existe una tarea con los mismos datos',
      );
      _formKey.currentState!.validate();
      return;
    }

    if (fechaCompleta.isBefore(widget.now())) {
      final confirmed = await _confirmPastDate();
      if (!confirmed || !mounted) return;
    }

    await _persistir(nuevaTarea);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 20,
            right: 20,
            top: 12,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.tarea == null ? "Nueva tarea" : "Editar tarea",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar formulario',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: "Titulo",
                    prefixIcon: Icon(Icons.task_alt),
                  ),
                  onChanged: _clearDuplicateError,
                  validator: _validateTitulo,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _asignaturaController,
                  decoration: const InputDecoration(
                    labelText: "Asignatura",
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  onChanged: _clearDuplicateError,
                  validator: _validateAsignatura,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: "Descripcion",
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 3,
                  onChanged: _clearDuplicateError,
                  validator: _validateDescripcion,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AgendaDateTimeButton(
                      key: const Key('task-date-button'),
                      icon: Icons.calendar_today,
                      label: 'Fecha',
                      value: _fechaSeleccionada == null
                          ? 'Seleccionar'
                          : _formatDate(_fechaSeleccionada!),
                      onPressed: _selectDate,
                    ),
                    AgendaDateTimeButton(
                      key: const Key('task-time-button'),
                      icon: Icons.schedule,
                      label: 'Hora',
                      value: _horaSeleccionada == null
                          ? 'Seleccionar'
                          : _horaSeleccionada!.format(context),
                      onPressed: _selectTime,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _guardar,
                        child: const Text("Guardar"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
