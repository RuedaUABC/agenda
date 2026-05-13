import 'package:flutter/material.dart';

import '../../domain/clase.dart';
import '../horario_controller.dart';

class ClaseForm extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<Clase>? onSave;

  const ClaseForm({super.key, required this.initialDate, this.onSave});

  @override
  State<ClaseForm> createState() => _ClaseFormState();
}

class _ClaseFormState extends State<ClaseForm> {
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

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      setState(() => _date = selected);
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
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final start = _combine(_date, _startTime);
    final end = _combine(_date, _endTime);

    if (!end.isAfter(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La hora de fin debe ser posterior a la de inicio'),
        ),
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

    widget.onSave?.call(clase);

    if (widget.onSave == null) {
      Navigator.of(context).pop(clase);
    }
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
                Text('Nueva clase', style: textTheme.headlineSmall),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _materiaController,
                  decoration: const InputDecoration(
                    labelText: 'Materia',
                    prefixIcon: Icon(Icons.class_),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa la materia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _aulaController,
                  decoration: const InputDecoration(
                    labelText: 'Aula',
                    prefixIcon: Icon(Icons.room_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text('Dia: ${_date.day}/${_date.month}/${_date.year}'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(isStart: true),
                    icon: const Icon(Icons.schedule),
                    label: Text('Inicio: ${_startTime.format(context)}'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(isStart: false),
                    icon: const Icon(Icons.schedule_outlined),
                    label: Text('Fin: ${_endTime.format(context)}'),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Color', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _colors.map((color) {
                    final isSelected =
                        color.toARGB32() == _selectedColor.toARGB32();

                    return Tooltip(
                      message: 'Seleccionar color',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar clase semanal'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
