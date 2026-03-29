import 'package:flutter/material.dart';
import '../../domain/tarea.dart';
import '../taskcontroller.dart';

class TareaForm extends StatefulWidget {
  final TasksController controller;
  final Tarea? tarea;

  const TareaForm({super.key, required this.controller, this.tarea});

  @override
  State<TareaForm> createState() => _TareaFormState();
}

class _TareaFormState extends State<TareaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _asignaturaController;
  late TextEditingController _descripcionController;
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tarea?.titulo ?? "");
    _asignaturaController = TextEditingController(
      text: widget.tarea?.asignatura ?? "",
    );
    _descripcionController = TextEditingController(
      text: widget.tarea?.descripcion ?? "",
    );
    _fechaSeleccionada = widget.tarea?.fecha ?? DateTime.now();
    _horaSeleccionada = widget.tarea != null
        ? TimeOfDay.fromDateTime(widget.tarea!.fecha)
        : TimeOfDay.now();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _asignaturaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _horaSeleccionada) {
      setState(() {
        _horaSeleccionada = picked;
      });
    }
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      if (_fechaSeleccionada == null || _horaSeleccionada == null) return;

      final fechaCompleta = DateTime(
        _fechaSeleccionada!.year,
        _fechaSeleccionada!.month,
        _fechaSeleccionada!.day,
        _horaSeleccionada!.hour,
        _horaSeleccionada!.minute,
      );

      final nuevaTarea = Tarea(
        id:
            widget.tarea?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text,
        asignatura: _asignaturaController.text,
        descripcion: _descripcionController.text,
        fecha: fechaCompleta,
        completada: widget.tarea?.completada ?? false,
      );

      if (widget.tarea == null) {
        await widget.controller.createTarea(nuevaTarea);
      } else {
        await widget.controller.updateTarea(nuevaTarea);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
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
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? "El título es requerido"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _asignaturaController,
                decoration: const InputDecoration(
                  labelText: "Asignatura",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
