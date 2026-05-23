# Red-Green-Refactor: Diseno Material 3

Este documento registra el ciclo TDD aplicado al rediseno Material 3 de
Agenda. El alcance implementado corresponde a "Base + UI clave": tema,
navegacion adaptativa, componentes compartidos, tareas, formularios principales
y ajustes. No incluye flujos nuevos de Deshacer ni permisos nativos de
notificaciones.

## Baseline

Comandos ejecutados antes de implementar:

```powershell
flutter analyze
flutter test
```

Resultado observado:

- `flutter test`: Pass, 77 pruebas.
- `flutter analyze`: 12 issues existentes, principalmente imports no usados,
  `withOpacity`, nombre `nav`, prints mock y dependencia `path` no declarada.

## Red

Se agregaron pruebas en `test/features/diseno_material3/` para expresar el
comportamiento ausente:

- `material3_app_test.dart`: tema claro/oscuro, `ThemeMode.system` y titulo
  `Agenda`.
- `material3_navigation_test.dart`: `NavigationBar` movil, `NavigationRail`
  tablet/escritorio e `IndexedStack`.
- `material3_tareas_test.dart`: `SearchBar`, `SegmentedButton`, contador,
  checkbox visible y estado vacio.
- `material3_forms_settings_test.dart`: cierre/cancelacion en formularios,
  color picker `48x48`, seccion de fecha/hora y ajustes con `DropdownMenu`.

Comando:

```powershell
flutter test test\features\diseno_material3
```

Fallo esperado:

- `AppTheme.lightTheme` no existia.
- `AgendaNavigation` no existia.
- `EventoForm`, `ClaseForm`, `TareaForm`, `TareasFilterBar`,
  `ListaTareasCategoria` y `NotificacionConfigWidget` no exponian los widgets
  Material 3 esperados.

## Green

Cambios minimos para pasar las pruebas:

- `AppTheme` ahora define `lightTheme` y `darkTheme` con
  `ColorScheme.fromSeed`.
- `MyApp` usa titulo `Agenda`, `ThemeMode.system` y `AgendaNavigation`.
- `AgendaNavigation` reemplaza `GNav` con `NavigationBar` y `NavigationRail`.
- Se agregaron `AgendaEmptyState`, `AgendaSectionHeader`,
  `AgendaDateTimeButton` y `AgendaColorPicker`.
- Tareas migro a `SearchBar`, `SegmentedButton`, `DropdownMenu`, checkbox
  visible y estado vacio.
- Formularios de tarea, evento y clase exponen cierre/cancelacion, fecha/hora
  como botones y selector de color accesible.
- Ajustes migro de `Card` + `DropdownButton` a `ListTile` + `DropdownMenu`.

Comandos focalizados:

```powershell
flutter test test\features\diseno_material3
flutter test test\features\configuracion\notificacion_config_widget_test.dart test\features\calendario\calendario_widgets_test.dart test\features\tareas\tareas_filter_bar_test.dart test\widget_test.dart
```

Resultado:

- Ambos comandos finalizaron en Pass.

## Refactor

Limpieza aplicada:

- Se removio `google_nav_bar` de `pubspec.yaml` y `pubspec.lock`.
- Se agrego `path` como dependencia directa porque se importa desde
  `database_helper.dart`.
- Se reemplazaron `print` mock por `debugPrint`.
- Se removieron imports no usados en `main.dart`.
- Se actualizaron pruebas antiguas para medir los nuevos widgets Material 3 en
  lugar de `DropdownButton`, `GNav` o textos antiguos.
- Se ejecuto formato Dart.

Comandos finales:

```powershell
dart format lib test
flutter analyze
flutter test
```

Resultado final:

- `flutter analyze`: No issues found.
- `flutter test`: Pass, 90 pruebas.

## Archivos de prueba agregados

- `test/features/diseno_material3/material3_app_test.dart`
- `test/features/diseno_material3/material3_navigation_test.dart`
- `test/features/diseno_material3/material3_tareas_test.dart`
- `test/features/diseno_material3/material3_forms_settings_test.dart`
