# Red-Green-Refactor: Horario Material 3

Este documento registra el ciclo TDD aplicado al rediseno especifico de la
pantalla Horario. El objetivo fue acercarla a patrones Material 3 inspirados en
Google Calendar: vista semanal como foco, lista diaria secundaria, seleccion de
dia visible, estados vacios consistentes y tarjetas de clase con metadatos
legibles.

## Red

Se agrego `test/features/diseno_material3/material3_horario_test.dart` con
pruebas para comportamiento ausente:

- Mobile usa `SegmentedButton` para alternar `Semana` y `Dia` en lugar de
  `TabBar`.
- Mobile muestra encabezado con contador y `AgendaEmptyState` para dias sin
  clases.
- Desktop usa un panel secundario Material 3 con `AgendaSectionHeader`, accion
  `Hoy` y chips de dias.
- `ClaseListItem` muestra horario y aula con iconos Material 3, sin texto
  mojibake.

Comando:

```powershell
flutter test test\features\diseno_material3\material3_horario_test.dart
```

Fallo esperado:

- No existia `SegmentedButton` en Horario mobile.
- No existia `AgendaSectionHeader` en el panel desktop.
- La lista vacia era texto simple.
- `ClaseListItem` seguia usando el icono anterior y texto con mojibake.

## Green

Cambios minimos implementados:

- `MyMobileBody` migro de `TabBar` a `SegmentedButton<HorarioMobileView>`.
- Se agrego `HorarioDayPanel` como panel reutilizable para mobile y desktop.
- `HorarioDayPanel` muestra contador, accion `Hoy`, chips de lunes a viernes y
  `AgendaEmptyState`.
- `MyDesktopBody` usa superficies Material 3 con calendario semanal y panel
  lateral de clases.
- `ClaseListItem` se redisenio como `Card.filled` con barra de color, icono de
  clase, horario y aula como metadatos.
- Se ajusto `test/features/horario/horario_widgets_test.dart` al nuevo contrato
  visual Material 3.

Comandos focalizados:

```powershell
flutter test test\features\diseno_material3\material3_horario_test.dart
flutter test test\features\horario test\features\diseno_material3
```

Resultado:

- Ambos comandos finalizaron en Pass.

## Refactor

Limpieza aplicada:

- La lista diaria se centralizo en `HorarioDayPanel` para evitar duplicacion
  entre mobile y desktop.
- Se corrigieron textos visibles sin acentos rotos en Horario.
- Se mantuvo la seleccion de fecha mediante el `ValueNotifier` existente del
  controller, sin modificar persistencia ni reglas de negocio.
- Se ejecuto formato Dart sobre los archivos de Horario y la prueba nueva.

Comandos finales:

```powershell
dart format lib\features\horario test\features\diseno_material3\material3_horario_test.dart
flutter analyze
flutter test
```

Resultado final:

- `flutter analyze`: No issues found.
- `flutter test`: Pass, 94 pruebas.

## Archivos de prueba agregados

- `test/features/diseno_material3/material3_horario_test.dart`
