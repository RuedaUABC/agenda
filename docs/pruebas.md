# Plan de pruebas

Este documento resume la cobertura agregada y mantenida para la aplicacion.
Los nombres de los tests describen el comportamiento esperado y sirven como
documentacion ejecutable.

## Feature: Tareas

Ubicacion principal: `test/features/tareas/taskcontroller_test.dart` y
`test/widget_test.dart`. Las validaciones del formulario tambien se cubren en
`test/features/tareas/tarea_form_test.dart`. La programacion de recordatorios
al guardar tareas se cubre en
`test/features/tareas/tarea_repository_notifications_test.dart`.

- Carga tareas activas y papelera desde el repositorio.
- Crea, actualiza y envia tareas a papelera recargando el estado.
- Restaura tareas eliminadas desde papelera.
- Elimina definitivamente tareas desde papelera previa confirmacion.
- Muestra un error visible cuando falla una operacion de persistencia de tarea.
- Clasifica tareas vencidas, pendientes de la semana, proximas y completadas.
- Busca tareas por titulo, asignatura o descripcion.
- Filtra tareas por estado desde la UI y conserva busqueda/rango de fecha en
  pruebas de controller.
- Calcula estadisticas semanales ignorando tareas completadas.
- Calcula progreso diario.
- Valida el formulario cuando falta el titulo.
- Rechaza titulos compuestos solo por espacios.
- Normaliza titulo, asignatura y descripcion antes de guardar.
- Aplica longitudes maximas para titulo, asignatura y descripcion.
- Solicita confirmacion cuando la fecha y hora de la tarea estan en el pasado.
- Rechaza tareas duplicadas con titulo, asignatura, descripcion, fecha y hora
  identicos despues de normalizar textos; en edicion excluye el mismo id.
- Permite completar, devolver a pendiente, editar, eliminar y recuperar tareas
  desde widgets.
- Al enviar una tarea a papelera, muestra `SnackBarAction` con `Deshacer` y
  restaura la tarea sin perder datos.
- `TareaForm` muestra `Guardando tarea...` y bloquea taps duplicados mientras
  persiste.
- `TareaRepositoryImpl` omite recordatorios calculados para el presente o el
  pasado, evitando que el scheduler nativo haga fallar el guardado de la tarea.

## Feature: Calendario

Ubicacion principal: `test/features/calendario/calendario_controller_test.dart`
y `test/features/calendario/calendario_widgets_test.dart`. La programacion de
avisos se cubre en `test/features/calendario/calendario_repository_notifications_test.dart`.

- Carga eventos y apaga el estado de carga.
- Agrega, actualiza y elimina eventos recargando el estado.
- Mantiene la fecha seleccionada con `ValueNotifier`.
- Inserta eventos mediante actualizacion cuando el id no existe.
- Ignora eliminaciones de ids inexistentes sin romper el estado.
- Transforma eventos a `Appointment` de Syncfusion conservando titulo,
  descripcion, color, inicio y fin.
- Valida eventos con titulo obligatorio, longitudes maximas, rango de fechas,
  evento puntual permitido, color por defecto y deteccion de superposiciones.
- `EventoForm` valida el titulo, normaliza titulo y descripcion, crea eventos
  con horario por defecto, edita conservando el id y advierte superposiciones
  antes de permitir guardar identificando el evento y rango conflictivo.
- `EventoForm` muestra `Guardando evento...` y bloquea taps duplicados mientras
  persiste.
- `CalendarioPage` abre el formulario desde el boton agregar y crea el evento
  mediante el controller.
- El widget mobile lista eventos del dia seleccionado y muestra estado vacio.
- El widget desktop lista eventos de varios dias y muestra estado vacio.
- El widget desktop permite editar al tocar un evento y confirma eliminacion
  desde una accion visible.
- `CalendarioPage` permite deshacer la eliminacion de eventos desde el
  `SnackBar`.
- La pantalla Calendario usa selector segmentado en mobile, panel secundario
  Material 3 en desktop, chips de fechas y estado vacio consistente.
- El repositorio programa avisos nativos para eventos futuros, cancela al
  eliminar, reprograma al cambiar anticipacion y respeta `Sin recordatorio`.

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
- Aplica longitudes maximas para materia y aula.
- Impide guardar clases que se solapan con otra clase del mismo dia y horario.
  El mensaje identifica la clase y rango conflictivo junto a fecha y hora.
- `ClaseForm` muestra `Guardando clase...` y bloquea taps duplicados mientras
  persiste.
- `ClaseListItem` renderiza materia, aula, rango horario e iconos Material 3.
- `ClaseListItem` expone accion visible de eliminar y respeta la preferencia
  global de confirmaciones.
- La pantalla Horario usa selector segmentado en mobile, panel secundario
  Material 3 en desktop, chips de dias y estado vacio consistente.
- `HorarioPage` permite deshacer la eliminacion de clases desde el `SnackBar`.

## Feature: Configuracion

Ubicacion principal:
`test/features/configuracion/settings_controller_test.dart` y
`test/features/configuracion/notificacion_config_widget_test.dart`.
Cobertura avanzada:
`test/features/configuracion/settings_advanced_test.dart` y
`test/features/configuracion/settings_effects_test.dart`.

- Carga valores por defecto desde preferencias vacias.
- Guarda preferencias globales de clases y tareas.
- Rechaza preferencias de notificacion vacias, negativas o no soportadas.
- Recupera valores por defecto cuando hay preferencias persistidas invalidas.
- Carga preferencias previamente persistidas.
- Reprograma solo tareas pendientes cuando cambian avisos de tareas.
- Mantiene en memoria listas vacias de avisos de tareas.
- Actualiza avisos sin repositorio de tareas inyectado.
- El widget muestra los valores actuales.
- El widget permite cambiar aviso global de clases.
- El widget permite cambiar el primer aviso de tareas y dispara la
  reprogramacion de tareas pendientes.
- El widget incluye aviso global de eventos y persiste su valor.
- El controller reprograma eventos futuros cuando cambia el aviso global de
  eventos.
- El controller persiste tema visual, vista inicial, densidad visual, inicio de
  semana y confirmaciones.
- El controller mapea tema a `ThemeMode` e indice inicial de navegacion.
- El controller genera respaldo JSON local y valida version/formato antes de
  importar preferencias.
- El controller expone informacion de version, almacenamiento local y estado de
  notificaciones.
- El inicio de semana afecta `SfCalendar` en calendario y horario.
- La densidad compacta se aplica a listas de tareas.
- Las confirmaciones desactivadas omiten dialogos en eliminaciones comunes de
  tareas, clases y eventos.
- La gestion de datos usa un store real y un servicio nativo inyectable para
  exportar, importar y borrar datos.
- Las pantallas de Tareas, Horario y Calendario escuchan cambios del
  `SettingsController` y aplican preferencias en tiempo real.
- `MyApp` escucha cambios de tema y actualiza `ThemeMode` durante la sesion.
- `NotificacionConfigWidget` escucha cambios externos del controller y
  sincroniza sus `DropdownMenu`.
- La vista inicial informa que se aplicara al abrir Agenda y no fuerza
  navegacion inmediata.
- El borrado de datos locales emite notificacion para refrescar consumidores
  activos.
- El borrado total de datos requiere escribir `BORRAR`, explica el alcance y
  usa tratamiento visual destructivo.
- Exportacion, importacion y borrado muestran estado de operacion visible.

## Feature: Diseno Material 3

Ubicacion principal: `test/features/diseno_material3/`.

- `AppTheme` define temas claro y oscuro con Material 3.
- `MyApp` usa `ThemeMode.system` y titulo `Agenda`.
- `AgendaNavigation` usa `NavigationBar` en movil y `NavigationRail` en
  pantallas medianas o grandes.
- Los filtros de tareas usan solo `SegmentedButton` visible para estado; la UI
  no muestra `SearchBar` ni selector de fecha.
- Las listas de tareas muestran contador, checkbox visible y estado vacio.
- Los formularios de tareas, eventos y clases exponen cancelar/cerrar,
  acciones Material 3 y botones de fecha/hora.
- Los selectores de color de eventos y clases tienen objetivos de `48x48`.
- La configuracion usa secciones `ListTile` y `DropdownMenu`.
- Los ajustes avanzados usan `SegmentedButton`, `DropdownMenu`,
  `SwitchListTile` y secciones Material 3.
- Horario usa `SegmentedButton`, `ChoiceChip`, `AgendaSectionHeader`,
  `AgendaEmptyState` y tarjetas `Card.filled` para clases.
- Calendario usa `SegmentedButton`, `ChoiceChip`, `AgendaSectionHeader`,
  `AgendaEmptyState` y tarjetas `Card.filled` para eventos.

## Feature: Modelos de dominio

Ubicacion principal: `test/features/models_serialization_test.dart`.

- `Tarea` serializa booleanos como enteros para SQLite y restaura fechas.
- `Evento` conserva fechas, descripcion y color.
- `Clase` conserva aula, recurrencia y color.

## Feature: Persistencia SQLite

Ubicacion principal: `test/features/persistencia/`.

- Migra una base SQLite antigua a la version actual conservando tareas y
  agregando columnas/tablas requeridas.
- Valida que Windows y Linux usen SQLite FFI.
- Ejecuta un smoke test que abre una base FFI en memoria, crea una tabla,
  inserta y consulta datos.

## Ejecucion recomendada

```powershell
flutter test
```

Para revisar una feature concreta:

```powershell
flutter test test/features/calendario
flutter test test/features/horario
flutter test test/features/configuracion
flutter test test/features/diseno_material3
flutter test test/features/tareas
flutter test test/features/persistencia
```
