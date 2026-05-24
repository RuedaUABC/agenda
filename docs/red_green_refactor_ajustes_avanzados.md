# Red-Green-Refactor: Ajustes avanzados Material 3

Fecha: 2026-05-24.

## Alcance

Implementar la base de ajustes avanzados definida para la app Agenda:

- Aviso global de eventos.
- Tema visual sistema/claro/oscuro.
- Vista inicial configurable.
- Preferencias de densidad visual, inicio de semana y confirmaciones.
- Gestion local de respaldo JSON validado desde controller.
- Informacion de version, almacenamiento y estado de notificaciones.

Quedan fuera de esta iteracion las integraciones transversales que requieren
coordinar DAOs, scheduler nativo o widgets de otros modulos: aplicar densidad
en todas las listas, inicio de semana en calendario/horario, confirmaciones en
cada eliminacion comun, escritura/seleccion real de archivos y borrado masivo
de datos.

## Red

Pruebas agregadas:

- `test/features/configuracion/settings_advanced_test.dart`.
- `test/features/diseno_material3/material3_settings_advanced_test.dart`.

Comando ejecutado:

```powershell
flutter test test\features\configuracion\settings_advanced_test.dart test\features\diseno_material3\material3_settings_advanced_test.dart
```

Fallo esperado:

- Faltaban enums de preferencias avanzadas.
- Faltaban propiedades y metodos en `SettingsController`.
- Faltaba `AdvancedSettingsWidget`.
- `NotificacionConfigWidget` no exponia aviso global de eventos.

## Green

Cambios implementados:

- `PreferencesHelper` persiste evento, tema, vista inicial, densidad, inicio de
  semana y confirmaciones.
- `SettingsController` expone estado observable, mapping a `ThemeMode`, indice
  inicial de navegacion, respaldo JSON e importacion validada de preferencias.
- `MyApp` escucha el controller y aplica tema configurable con fallback al modo
  del sistema.
- `AgendaNavigation` acepta indice inicial y conserva `IndexedStack`.
- `NotificacionConfigWidget` agrega selector de eventos con `DropdownMenu`.
- `AdvancedSettingsWidget` crea secciones Material 3 con `SegmentedButton`,
  `DropdownMenu`, `SwitchListTile`, acciones de datos e informacion solo
  lectura.
- `SettingsPage` permite inyectar controller para compartir preferencias con la
  app shell.

Comandos verdes:

```powershell
flutter test test\features\configuracion\settings_advanced_test.dart test\features\diseno_material3\material3_settings_advanced_test.dart
flutter test test\features\configuracion test\features\diseno_material3
```

Resultado:

- Ambas tandas pasaron.
- Se actualizaron fixtures antiguos que asumian dos selectores de notificacion;
  el comportamiento correcto ahora incluye Clases, Eventos y Tareas.

## Refactor

Limpieza aplicada:

- `AdvancedSettingsWidget` quedo desplazable para evitar overflow en pantallas
  completas o contenedores reducidos.
- La UI de notificaciones comparte una estructura de tile por cada preferencia.
- La documentacion marca estados `Implementado`, `Implementado parcial` y
  pendientes reales por requerimiento.

## Segundo ciclo: efectos reales de ajustes

### Red

Prueba agregada:

- `test/features/configuracion/settings_effects_test.dart`.

Comando ejecutado:

```powershell
flutter test test\features\configuracion\settings_effects_test.dart
```

Fallo esperado:

- Faltaba contrato `SettingsDataStore`.
- Las pantallas de calendario y horario no recibian `weekStart`.
- Las listas no recibian densidad visual.
- Las eliminaciones comunes no podian omitir dialogo cuando la preferencia se
  desactivaba.
- Faltaban metodos de exportacion/importacion/borrado completos en
  `SettingsController`.

### Green

Cambios implementados:

- `AgendaNavigation` inyecta `SettingsController` en Tareas, Horario y
  Calendario.
- Horario y Calendario aplican `weekStart` a `SfCalendar` y selectores de dia.
- Tareas, clases y eventos aplican densidad visual compacta en sus listas.
- Tareas y eventos omiten el dialogo de eliminacion comun cuando la preferencia
  de confirmaciones esta desactivada; el borrado masivo conserva confirmacion
  reforzada.
- `SettingsDataStore` y `SqliteSettingsDataStore` exportan, importan y borran
  datos reales de tareas, clases y eventos mediante DAOs.
- La UI de gestion de datos permite generar/ver JSON, pegar JSON para importar
  y ejecutar borrado local reforzado.

Resultado:

- `flutter test test\features\configuracion\settings_effects_test.dart`: 4
  pruebas pasaron.

### Refactor: aplicacion en tiempo real

Prueba agregada al mismo archivo:

- `cambios de ajustes se aplican en tiempo real en pantallas`.
- `tema cambia en tiempo real desde MyApp`.
- `recordatorios reflejan cambios externos del controller`.
- `vista inicial muestra efecto diferido sin navegar`.
- `borrado de datos emite cambio para refresco en vivo`.

Fallo Red:

- `TasksPage` y `HorarioPage` no permitian inyectar controllers para verificar
  la pantalla viva.
- Calendario, Horario y Tareas calculaban preferencias al construir, pero no
  escuchaban directamente cambios posteriores del `SettingsController`.
- `NotificacionConfigWidget` no escuchaba cambios externos del controller.
- El borrado completo de datos no emitia `notifyListeners`.
- Vista inicial no comunicaba que su efecto es diferido al siguiente arranque.

Cambios Green:

- `TasksPage`, `HorarioPage` y `CalendarioPage` envuelven su scaffold en
  `ListenableBuilder` cuando reciben `SettingsController`.
- Las pantallas recalculan densidad, inicio de semana y confirmaciones en cada
  notificacion del controller.
- `TasksPage` y `HorarioPage` aceptan controllers inyectados para pruebas de
  comportamiento sin depender de SQLite o scheduler.
- `NotificacionConfigWidget` escucha el controller y sincroniza sus
  `DropdownMenu` cuando cambian preferencias externas o importadas.
- `deleteAllLocalData` emite cambio para refrescar consumidores activos.
- Vista inicial conserva la decision UX de no navegar y muestra
  `Se aplicara al abrir Agenda`.

Resultado:

- `flutter test test\features\configuracion\settings_effects_test.dart`: 9
  pruebas pasaron.

Comandos finales de verificacion:

```powershell
dart format lib\features\configuracion lib\features\navegacion\presentation\navegacion.dart lib\main.dart test\features\configuracion test\features\diseno_material3
flutter test
flutter analyze
```

Resultado final:

- `dart format`: sin cambios pendientes despues del formateo.
- `flutter test`: suite completa en verde con 112 pruebas.
- `flutter analyze`: sin issues.

## Evidencia

Archivos de prueba relevantes:

- `test/features/configuracion/settings_advanced_test.dart`.
- `test/features/configuracion/notificacion_config_widget_test.dart`.
- `test/features/diseno_material3/material3_settings_advanced_test.dart`.
- `test/features/diseno_material3/material3_forms_settings_test.dart`.

Requerimientos cubiertos:

- RF-043: parcial, preferencia y UI de aviso de eventos.
- RF-044: completo, tema visual configurable.
- RF-045: completo, vista inicial configurable.
- RF-046: completo, densidad aplicada a listas principales.
- RF-047: completo, inicio de semana aplicado a calendario y horario.
- RF-048: parcial, confirmaciones aplicadas a tareas/eventos; pendiente clases
  cuando exista accion visible.
- RF-049: parcial, respaldo/importacion/borrado usan store real; pendiente
  selector/escritura de archivo nativo.
- RF-050: completo, informacion de aplicacion en Ajustes.
