# Red-Green-Refactor: recuperacion, confirmaciones y feedback

## Alcance

Este ciclo completa RF-048, RF-049 y RF-051 a RF-055, y refuerza RNF-011,
RNF-012, RNF-013 y RNF-022. El trabajo se centro en acciones destructivas,
gestion de datos locales, recuperacion, estados de progreso, estados vacios y
diagnostico de conflictos.

## Red

Se agregaron pruebas que fallaban antes de la implementacion:

- Borrado total de datos debe exigir escribir `BORRAR`, explicar alcance y usar
  tratamiento destructivo.
- Enviar una tarea a papelera debe mostrar `SnackBar` con `Deshacer`.
- Eliminar clases y eventos desde sus paginas debe permitir `Deshacer`.
- `TareaForm`, `ClaseForm` y `EventoForm` deben mostrar estado `Guardando...`
  y deshabilitar el boton mientras persisten.
- Conflictos de clases y eventos deben nombrar el elemento y el rango horario
  conflictivo.

## Green

Cambios implementados:

- `AdvancedSettingsWidget` ahora muestra estado de operacion para exportar,
  importar y borrar datos, y usa un dialogo reforzado para borrado total.
- Las eliminaciones reversibles de tareas, clases y eventos muestran accion
  `Deshacer`.
- Los formularios de tareas, clases y eventos bloquean guardados duplicados y
  muestran texto de progreso.
- Los conflictos de clase se muestran junto a `Fecha y hora`; los eventos
  superpuestos indican evento y rango dentro del dialogo.
- Los estados vacios de tareas, horario y calendario ofrecen una accion directa
  cuando existe una creacion natural.
- Las pantallas principales muestran textos de carga contextuales.

## Refactor

Se mantuvieron los patrones existentes:

- Material 3 y `ColorScheme.error` para acciones destructivas.
- `SnackBarAction` para recuperacion sin introducir nuevos servicios.
- Callbacks opcionales para acciones de estados vacios, conservando los tests y
  usos existentes.
- Validaciones y feedback en los formularios donde el usuario puede corregir el
  dato.

## Verificacion

Comando ejecutado:

```powershell
flutter test test\features\configuracion\settings_effects_test.dart test\features\calendario\calendario_widgets_test.dart test\features\horario\horario_widgets_test.dart test\features\horario\clase_form_test.dart test\features\calendario\evento_form_test.dart test\features\tareas\tarea_form_test.dart test\widget_test.dart
```

Resultado: `All tests passed`.

## Correccion posterior: guardado de tareas

Se detecto un fallo al guardar una tarea desde el formulario cuando la fecha de
la tarea quedaba cerca del recordatorio global configurado. Con el valor por
defecto de 60 minutos, una tarea creada para una hora adelante podia calcular
la notificacion para el instante actual o para unos segundos en el pasado; el
scheduler nativo podia rechazar esa fecha y el formulario mostraba error de
guardado aunque la tarea ya se hubiera insertado.

### Red

Se agrego `test/features/tareas/tarea_repository_notifications_test.dart` con
un scheduler falso que falla si recibe una fecha no futura. Antes del fix,
`TareaRepositoryImpl.addTarea` fallaba al intentar programar ese recordatorio.

### Green

`TareaRepositoryImpl.programarNotificacionesTarea` ahora omite recordatorios
cuya fecha calculada no sea posterior a `DateTime.now()`. La tarea se guarda y
solo se programan notificaciones futuras.

### Verificacion

```powershell
flutter test test\features\tareas\tarea_repository_notifications_test.dart test\features\tareas\tarea_form_test.dart test\widget_test.dart
```

Resultado: `All tests passed`.
