# Plan de pruebas

Este documento resume la cobertura agregada y mantenida para la aplicacion.
Los nombres de los tests describen el comportamiento esperado y sirven como
documentacion ejecutable.

## Feature: Tareas

Ubicacion principal: `test/features/tareas/taskcontroller_test.dart` y
`test/widget_test.dart`.

- Carga tareas activas y papelera desde el repositorio.
- Crea, actualiza y envia tareas a papelera recargando el estado.
- Restaura tareas eliminadas desde papelera.
- Clasifica tareas vencidas, pendientes de la semana, proximas y completadas.
- Calcula estadisticas semanales ignorando tareas completadas.
- Calcula progreso diario.
- Valida el formulario cuando falta el titulo.
- Permite completar, devolver a pendiente, editar, eliminar y recuperar tareas
  desde widgets.

## Feature: Calendario

Ubicacion principal: `test/features/calendario/calendario_controller_test.dart`
y `test/features/calendario/calendario_widgets_test.dart`.

- Carga eventos y apaga el estado de carga.
- Agrega, actualiza y elimina eventos recargando el estado.
- Mantiene la fecha seleccionada con `ValueNotifier`.
- Inserta eventos mediante actualizacion cuando el id no existe.
- Ignora eliminaciones de ids inexistentes sin romper el estado.
- Transforma eventos a `Appointment` de Syncfusion conservando titulo,
  descripcion, color, inicio y fin.
- El widget mobile lista eventos del dia seleccionado y muestra estado vacio.
- El widget desktop lista eventos de varios dias y muestra estado vacio.

## Feature: Horario

Ubicacion principal: `test/features/horario/horario_controller_test.dart`,
`test/features/horario/clase_form_test.dart` y
`test/features/horario/horario_widgets_test.dart`.

- Carga clases y apaga el estado de carga.
- Agrega, actualiza y elimina clases recargando el estado.
- Mantiene la fecha seleccionada con `ValueNotifier`.
- Inserta clases mediante actualizacion cuando el id no existe.
- Ignora eliminaciones de ids inexistentes sin romper el estado.
- Transforma clases a `Appointment` conservando aula, color y recurrencia.
- Normaliza recurrencias semanales antiguas sin `BYDAY`.
- Conserva reglas nulas, vacias o no semanales.
- Mapea todos los dias de semana a codigos RRULE y rechaza dias invalidos.
- Valida que `ClaseForm` requiera materia y cree clases semanales validas.
- `ClaseListItem` renderiza materia, aula, rango horario e icono.

## Feature: Configuracion

Ubicacion principal:
`test/features/configuracion/settings_controller_test.dart` y
`test/features/configuracion/notificacion_config_widget_test.dart`.

- Carga valores por defecto desde preferencias vacias.
- Guarda preferencias globales de clases y tareas.
- Carga preferencias previamente persistidas.
- Reprograma solo tareas pendientes cuando cambian avisos de tareas.
- Mantiene en memoria listas vacias de avisos de tareas.
- Actualiza avisos sin repositorio de tareas inyectado.
- El widget muestra los valores actuales.
- El widget permite cambiar aviso global de clases.
- El widget permite cambiar el primer aviso de tareas y dispara la
  reprogramacion de tareas pendientes.

## Feature: Modelos de dominio

Ubicacion principal: `test/features/models_serialization_test.dart`.

- `Tarea` serializa booleanos como enteros para SQLite y restaura fechas.
- `Evento` conserva fechas, descripcion y color.
- `Clase` conserva aula, recurrencia y color.

## Ejecucion recomendada

```powershell
flutter test
```

Para revisar una feature concreta:

```powershell
flutter test test/features/calendario
flutter test test/features/horario
flutter test test/features/configuracion
flutter test test/features/tareas
```
