import 'dart:async';

import 'package:agenda/core/widgets/agenda_color_picker.dart';
import 'package:agenda/core/widgets/agenda_date_time_button.dart';
import 'package:flutter/material.dart';

import '../../domain/clase.dart';
import '../horario_controller.dart';

class ClaseForm extends StatefulWidget {
  final DateTime initialDate;
  final FutureOr<void> Function(Clase clase)? onSave;
  final List<Clase> clases;

  const ClaseForm({
    super.key,
    required this.initialDate,
    this.onSave,
    this.clases = const [],
  });

  @override
  State<ClaseForm> createState() => _ClaseFormState();
}

class _ClaseFormState extends State<ClaseForm> {
  static const int maxMateriaLength = 120;
  static const int maxAulaLength = 80;

  static const List<Color> _colors = [
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFF97316),
    Color(0xFFE11D48),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
  ];

  final _formKey = GlobalKey<FormState>();
  final _materiaController = TextEditingController();
  final _aulaController = TextEditingController();
  late DateTime _date;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 9, minute: 0);
  Color _selectedColor = _colors.first;
  String? _scheduleError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate;
  }

  @override
  void dispose() {
    _materiaController.dispose();
    _aulaController.dispose();
    super.dispose();
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String? _validateMateria(String? value) {
    final materia = value?.trim() ?? '';
    if (materia.isEmpty) {
      return 'Ingresa la materia';
    }
    if (materia.length > maxMateriaLength) {
      return 'La materia no puede superar $maxMateriaLength caracteres';
    }
    return null;
  }

  String? _validateAula(String? value) {
    final aula = value?.trim() ?? '';
    if (aula.length > maxAulaLength) {
      return 'El aula no puede superar $maxAulaLength caracteres';
    }
    return null;
  }

  Clase? _conflictingClass(DateTime start, DateTime end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    for (final clase in widget.clases) {
      if (clase.inicio.weekday != start.weekday) continue;
      final classStartMinutes = clase.inicio.hour * 60 + clase.inicio.minute;
      final classEndMinutes = clase.fin.hour * 60 + clase.fin.minute;
      if (startMinutes < classEndMinutes && endMinutes > classStartMinutes) {
        return clase;
      }
    }
    return null;
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      setState(() {
        _date = selected;
        _scheduleError = null;
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );

    if (selected == null) return;

    setState(() {
      if (isStart) {
        _startTime = selected;
        final start = _combine(_date, _startTime);
        final end = _combine(_date, _endTime);
        if (!end.isAfter(start)) {
          final nextHour = start.add(const Duration(hours: 1));
          _endTime = TimeOfDay(hour: nextHour.hour, minute: nextHour.minute);
        }
      } else {
        _endTime = selected;
      }
      _scheduleError = null;
    });
  }

  Future<void> _save() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final start = _combine(_date, _startTime);
    final end = _combine(_date, _endTime);

    if (!end.isAfter(start)) {
      setState(
        () => _scheduleError =
            'La hora de fin debe ser posterior a la de inicio.',
      );
      return;
    }

    final conflict = _conflictingClass(start, end);
    if (conflict != null) {
      setState(
        () => _scheduleError =
            'La clase se cruza con ${conflict.materia} (${_formatTime(conflict.inicio)} - ${_formatTime(conflict.fin)}). Ajusta el horario o revisa la clase existente.',
      );
      return;
    }

    final clase = Clase(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      materia: _materiaController.text.trim(),
      aula: _aulaController.text.trim(),
      inicio: start,
      fin: end,
      recurrenceRule:
          'FREQ=WEEKLY;INTERVAL=1;BYDAY=${weekdayToRecurrenceDay(start.weekday)}',
      color: _selectedColor.toARGB32(),
    );

    if (widget.onSave == null) {
      Navigator.of(context).pop(clase);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await Future<void>.sync(() => widget.onSave!(clase));
    } catch (_) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar la clase')),
        );
      }
      return;
    }

    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nueva clase',
                        style: textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar formulario',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _materiaController,
                  decoration: const InputDecoration(
                    labelText: 'Materia',
                    prefixIcon: Icon(Icons.class_),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateMateria,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _aulaController,
                  decoration: const InputDecoration(
                    labelText: 'Aula',
                    prefixIcon: Icon(Icons.room_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: _validateAula,
                ),
                const SizedBox(height: 12),
                Text('Fecha y hora', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AgendaDateTimeButton(
                      onPressed: _pickDate,
                      icon: Icons.calendar_today,
                      label: 'Dia',
                      value: '${_date.day}/${_date.month}/${_date.year}',
                    ),
                    AgendaDateTimeButton(
                      onPressed: () => _pickTime(isStart: true),
                      icon: Icons.schedule,
                      label: 'Inicio',
                      value: _startTime.format(context),
                    ),
                    AgendaDateTimeButton(
                      onPressed: () => _pickTime(isStart: false),
                      icon: Icons.schedule_outlined,
                      label: 'Fin',
                      value: _endTime.format(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Se repetira cada semana este dia',
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (_scheduleError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _scheduleError!,
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text('Color', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                AgendaColorPicker(
                  colors: _colors,
                  selectedColor: _selectedColor.toARGB32(),
                  onChanged: (value) {
                    setState(() => _selectedColor = Color(value));
                  },
                ),
                const SizedBox(height: 16),
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
                      child: FilledButton.icon(
                        onPressed: _isSaving ? null : _save,
                        icon: const Icon(Icons.save),
                        label: Text(
                          _isSaving
                              ? 'Guardando clase...'
                              : 'Guardar clase semanal',
                        ),
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
