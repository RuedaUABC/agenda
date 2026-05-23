# Red-Green-Refactor: Calendario Material 3

Este documento registra el ciclo TDD aplicado al rediseno especifico del
calendario de eventos. El objetivo fue acercarlo a patrones Material 3
inspirados en Google Calendar: vista mensual como foco, panel diario
secundario, accion `Hoy`, estados vacios consistentes y tarjetas de evento con
metadatos legibles.

## Red

Se agrego `test/features/diseno_material3/material3_calendario_test.dart` con
pruebas para comportamiento ausente:

- Mobile usa `SegmentedButton` para alternar `Mes` y `Dia` en lugar de
  `TabBar`.
- Mobile muestra panel diario con encabezado, contador y `AgendaEmptyState`.
- Desktop usa panel secundario Material 3 con `AgendaSectionHeader`, accion
  `Hoy` y chips de fechas.
- `EventoListItem` muestra icono de evento, rango horario y descripcion como
  metadatos Material 3.

Comando:

```powershell
flutter test test\features\diseno_material3\material3_calendario_test.dart
```

Fallo esperado:

- No existia `SegmentedButton` en Calendario mobile.
- No existia `AgendaSectionHeader` en el panel desktop.
- El estado vacio era texto simple.
- `EventoListItem` no exponia metadatos Material 3.

## Green

Cambios minimos implementados:

- `MyMobileBody` migro de `TabBar` a
  `SegmentedButton<CalendarioMobileView>`.
- Se agrego `CalendarioDayPanel` como panel reutilizable para mobile y
  desktop.
- `CalendarioDayPanel` muestra contador, accion `Hoy`, chips de fechas y
  `AgendaEmptyState`.
- `MyDesktopBody` usa superficies Material 3 con calendario mensual y panel
  lateral de eventos.
- `EventoListItem` se redisenio como `Card.filled` con barra de color, icono de
  evento, horario y descripcion como metadatos.
- Se ajusto `test/features/calendario/calendario_widgets_test.dart` al nuevo
  contrato visual Material 3.

Comandos focalizados:

```powershell
flutter test test\features\diseno_material3\material3_calendario_test.dart
flutter test test\features\calendario test\features\diseno_material3
```

Resultado:

- Ambos comandos finalizaron en Pass.

## Refactor

Limpieza aplicada:

- La lista diaria se centralizo en `CalendarioDayPanel` para evitar duplicacion
  entre mobile y desktop.
- Los metadatos de evento evitan overflow al usar lineas con `Expanded`.
- Se mantuvo la seleccion de fecha mediante el `ValueNotifier` existente del
  controller, sin modificar persistencia ni reglas de negocio.
- Se ejecuto formato Dart sobre los archivos de Calendario y la prueba nueva.

Comandos finales:

```powershell
dart format lib\features\calendario test\features\calendario\calendario_widgets_test.dart test\features\diseno_material3\material3_calendario_test.dart
flutter analyze
flutter test
```

Resultado final:

- `flutter analyze`: No issues found.
- `flutter test`: Pass, 98 pruebas.

## Archivos de prueba agregados

- `test/features/diseno_material3/material3_calendario_test.dart`
