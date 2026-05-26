import 'dart:async';

import 'package:agenda/core/widgets/agenda_color_picker.dart';
import 'package:agenda/core/widgets/agenda_date_time_button.dart';
import 'package:flutter/material.dart';

import '../../domain/evento.dart';
import '../../domain/evento_validator.dart';

class EventoForm extends StatefulWidget {
  final DateTime initialDate;
  final Evento? evento;
  final List<Evento> eventos;
  final FutureOr<void> Function(Evento evento)? onSave;

  const EventoForm({
    super.key,
    required this.initialDate,
    this.evento,
    this.eventos = const [],
    this.onSave,
  });

  @override
  State<EventoForm> createState() => _EventoFormState();
}

class _EventoFormState extends State<EventoForm> {
  static const List<Color> _colors = [
    Color(Evento.defaultColor),
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFF97316),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _descripcionController;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late int _selectedColor;
  String? _rangeError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final evento = widget.evento;
    final initialStart = evento?.inicio ?? _defaultStart(widget.initialDate);
    final initialEnd =
        evento?.fin ?? initialStart.add(const Duration(hours: 1));

    _tituloController = TextEditingController(text: evento?.titulo ?? '');
    _descripcionController = TextEditingController(
      text: evento?.descripcion ?? '',
    );
    _startDate = _dateOnly(initialStart);
    _endDate = _dateOnly(initialEnd);
    _startTime = TimeOfDay.fromDateTime(initialStart);
    _endTime = TimeOfDay.fromDateTime(initialEnd);
    _selectedColor = EventoValidator.normalizeColor(evento?.color);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  DateTime _defaultStart(DateTime date) {
    return DateTime(date.year, date.month, date.day, 8);
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (selected == null) return;

    setState(() {
      if (isStart) {
        _startDate = selected;
        final start = _combine(_startDate, _startTime);
        final end = _combine(_endDate, _endTime);
        if (end.isBefore(start)) {
          final adjusted = start.add(const Duration(hours: 1));
          _endDate = _dateOnly(adjusted);
          _endTime = TimeOfDay.fromDateTime(adjusted);
        }
      } else {
        _endDate = selected;
      }
      _rangeError = null;
    });
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
        final start = _combine(_startDate, _startTime);
        final end = _combine(_endDate, _endTime);
        if (end.isBefore(start)) {
          final adjusted = start.add(const Duration(hours: 1));
          _endDate = _dateOnly(adjusted);
          _endTime = TimeOfDay.fromDateTime(adjusted);
        }
      } else {
        _endTime = selected;
      }
      _rangeError = null;
    });
  }

  Future<void> _save() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    final inicio = _combine(_startDate, _startTime);
    final fin = _combine(_endDate, _endTime);
    final rangeError = EventoValidator.validateRango(inicio, fin);

    setState(() => _rangeError = rangeError);

    if (!formIsValid || rangeError != null) return;

    final evento = EventoValidator.normalizedEvento(
      id: widget.evento?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: _tituloController.text,
      inicio: inicio,
      fin: fin,
      descripcion: _descripcionController.text,
      color: _selectedColor,
    );

    final overlap = EventoValidator.firstOverlap(
      evento,
      widget.eventos,
      excludeId: widget.evento?.id,
    );
    if (overlap != null) {
      final confirmed = await _confirmOverlap(overlap);
      if (!confirmed || !mounted) return;
    }

    setState(() => _isSaving = true);
    try {
      await Future<void>.sync(() => widget.onSave?.call(evento));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el evento')),
        );
        setState(() => _isSaving = false);
      }
      return;
    }

    if (!mounted) return;

    if (widget.onSave == null) {
      Navigator.of(context).pop(evento);
      return;
    }

    setState(() => _isSaving = false);
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<bool> _confirmOverlap(Evento overlap) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Evento superpuesto'),
          content: Text(
            'Este evento se cruza con ${overlap.titulo} (${_formatTime(overlap.inicio)} - ${_formatTime(overlap.fin)}). Puedes revisar el horario o guardarlo de todos modos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Guardar de todos modos'),
            ),
          ],
        );
      },
    );

    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final textTheme = Theme.of(context).textTheme;
    final isEditing = widget.evento != null;
    final colors = _colors.any((color) => color.toARGB32() == _selectedColor)
        ? _colors
        : [Color(_selectedColor), ..._colors];

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
                        isEditing ? 'Editar evento' : 'Nuevo evento',
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
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Titulo',
                    prefixIcon: Icon(Icons.event),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: EventoValidator.validateTitulo,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripcion',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 3,
                  validator: EventoValidator.validateDescripcion,
                ),
                const SizedBox(height: 12),
                Text('Fecha y hora', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AgendaDateTimeButton(
                      onPressed: () => _pickDate(isStart: true),
                      icon: Icons.calendar_today,
                      label: 'Inicio',
                      value: _formatDate(_startDate),
                    ),
                    AgendaDateTimeButton(
                      onPressed: () => _pickTime(isStart: true),
                      icon: Icons.schedule,
                      label: 'Hora inicio',
                      value: _startTime.format(context),
                    ),
                    AgendaDateTimeButton(
                      onPressed: () => _pickDate(isStart: false),
                      icon: Icons.event_available,
                      label: 'Fin',
                      value: _formatDate(_endDate),
                    ),
                    AgendaDateTimeButton(
                      onPressed: () => _pickTime(isStart: false),
                      icon: Icons.schedule_outlined,
                      label: 'Hora fin',
                      value: _endTime.format(context),
                    ),
                  ],
                ),
                if (_rangeError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _rangeError!,
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text('Color', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                AgendaColorPicker(
                  colors: colors,
                  selectedColor: _selectedColor,
                  onChanged: (value) {
                    setState(() => _selectedColor = value);
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
                              ? 'Guardando evento...'
                              : isEditing
                              ? 'Actualizar evento'
                              : 'Guardar evento',
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
