# Auditoria UX con heuristicas de Nielsen

Fecha de revision: 2026-05-26

Alcance: revision por codigo de la interfaz Flutter de Agenda, centrada en
navegacion, tareas, horario, calendario, ajustes, formularios, estados vacios,
feedback y acciones destructivas.

## Resumen ejecutivo

La interfaz tiene una base solida para una app de productividad: usa Material 3,
navegacion adaptativa, tema claro/oscuro, formularios con validacion y estados
vacios reutilizables. Los principales riesgos de usabilidad estan en recuperacion
ante errores, control del usuario en acciones destructivas, consistencia de textos
y claridad del feedback en cargas o conflictos.

Prioridad recomendada:

1. Corregir textos con mojibake y acentos rotos en dialogs.
2. Agregar Deshacer a eliminaciones reversibles y confirmaciones mas claras para
   borrado total.
3. Mostrar errores de horario/conflictos junto al campo afectado, no solo en
   snackbars.
4. Mejorar estados de carga y estados vacios con acciones directas.
5. Revisar responsividad de grupos de botones en sheets estrechos.

## Hallazgos por heuristica

| Heuristica | Estado | Hallazgos principales |
| --- | --- | --- |
| 1. Visibilidad del estado del sistema | Parcial | Hay indicadores de carga, snackbars y estado de guardado en eventos, pero las pantallas principales muestran solo spinner sin contexto. TareaForm no deshabilita Guardar durante persistencia. |
| 2. Correspondencia sistema-mundo real | Buena | Etiquetas como Tareas, Horario, Calendario, Hoy, Semana/Dia y Fecha y hora son comprensibles. Hay friccion por textos sin acentos y mojibake en dialogs. |
| 3. Control y libertad del usuario | Parcial | Hay cerrar/cancelar en sheets y confirmaciones. Falta Deshacer para eliminaciones reversibles de tareas, clases y eventos. Borrado total dice "confirmacion reforzada", pero solo requiere un tap en Eliminar. |
| 4. Consistencia y estandares | Buena con ajustes | Material 3, NavigationBar/Rail, SegmentedButton y DropdownMenu estan bien usados. Inconsistencias: eventos tienen _isSaving, tareas y clases no; acciones destructivas no siempre usan color de error. |
| 5. Prevencion de errores | Parcial | Validaciones de titulo, rangos, superposiciones y confirmacion de fecha pasada ayudan. El borrado masivo necesita una defensa real: texto de confirmacion, doble paso o frase obligatoria. |
| 6. Reconocer antes que recordar | Buena | Navegacion persistente, iconos con texto y controles visibles reducen memoria. En tareas, la distribucion desktop separa Completadas/Papelera en panel secundario, lo que puede requerir aprendizaje. |
| 7. Flexibilidad y eficiencia | Buena | Preferencias de vista inicial, tema, densidad visual e inicio de semana son utiles. Falta atajo visible para crear desde estados vacios y no hay busqueda/filtro avanzado en calendario u horario. |
| 8. Diseno estetico y minimalista | Buena | La UI es sobria, productiva y consistente. Algunos estados vacios son genericos y repetitivos, lo que baja la utilidad de la pantalla cuando no hay datos. |
| 9. Ayudar a reconocer, diagnosticar y recuperarse de errores | Parcial | Existen mensajes de error, pero son genericos. Conflictos de clase/evento no indican con cual elemento se cruza ni llevan al campo concreto. |
| 10. Ayuda y documentacion | Parcial | La UI contiene descripciones utiles en ajustes. No hay microayuda para permisos de notificaciones, restauracion/importacion o consecuencias de borrado total. |

## Hallazgos priorizados

### Alta prioridad

**Textos corruptos en confirmaciones de tareas.** En
`lib/features/tareas/presentation/widgets/lista_tareas_categoria.dart`, los
dialogs muestran `Â¿` y `SÃ­`. Esto afecta confianza, profesionalismo y claridad
en acciones criticas.

Impacta heuristicas 2, 4 y 5.

**Borrado total sin confirmacion reforzada real.** En
`lib/features/configuracion/presentation/advanced_settings_widget.dart`, la UI
promete "Siempre requiere confirmacion reforzada", pero el dialog solo muestra
Cancelar y Eliminar. Se recomienda exigir una frase como `BORRAR`, mostrar el
alcance exacto de datos y usar boton destructivo con color de error.

Impacta heuristicas 3 y 5.

**Eliminaciones sin Deshacer.** Eventos y clases muestran snackbars de eliminado,
pero no dan accion de recuperacion. En tareas, eliminar manda a papelera, pero
el snackbar/accion de deshacer no aparece en el flujo principal.

Impacta heuristicas 3 y 9.

### Media prioridad

**Errores de horario y conflictos en snackbar.** En `ClaseForm`, los errores de
rango y superposicion aparecen como snackbar. Se recomienda mostrarlos bajo la
seccion Fecha y hora, igual que EventoForm hace con `_rangeError`, y explicar
con que clase se cruza cuando sea posible.

Impacta heuristicas 5 y 9.

**Estados de carga sin contexto.** Tareas, horario, calendario y ajustes usan
`CircularProgressIndicator` centrado. Para cargas largas, conviene mostrar texto
como "Cargando tareas..." y mantener estructura basica de pantalla.

Impacta heuristica 1.

**Guardar en tareas y clases no muestra estado de progreso.** EventoForm
deshabilita el boton con `_isSaving`; TareaForm y ClaseForm no tienen estado
equivalente. Esto puede permitir taps repetidos o incertidumbre.

Impacta heuristicas 1 y 5.

### Baja prioridad

**Estados vacios genericos.** En tareas se repite "Cuando haya elementos para
esta seccion apareceran aqui". Conviene personalizar por categoria y agregar
accion contextual cuando aplique.

Impacta heuristicas 7, 8 y 10.

**Grupos de tres acciones en sheets.** El detalle de tarea usa tres botones en
fila: Completar/Pendiente, Editar, Eliminar. En pantallas estrechas o con texto
grande puede saturarse; conviene apilarlos o mover acciones secundarias a menu.

Impacta heuristicas 8 y accesibilidad.

## Fortalezas encontradas

- Navegacion adaptativa con `NavigationBar` en movil y `NavigationRail` en
  pantallas amplias.
- Uso de Material 3, `ColorScheme.fromSeed`, tema claro/oscuro y preferencia del
  sistema.
- Formularios con titulo, cierre visible, cancelar y accion primaria.
- Calendario y horario incluyen accion Hoy y selector Mes/Dia o Semana/Dia.
- Ajustes usan controles reconocibles: `SegmentedButton`, `DropdownMenu`,
  `SwitchListTile` y `ListTile`.
- Selectores de color tienen area tactil de 48x48, tooltip y check visual.

## Verificacion realizada

- `flutter analyze`: sin issues.
- Pruebas ejecutadas: `flutter test test\features\diseno_material3
  test\features\tareas test\features\calendario\calendario_widgets_test.dart
  test\features\horario\horario_widgets_test.dart
  test\features\configuracion\settings_advanced_test.dart`
- Resultado: 56 pruebas pasaron.

Limitacion: no se pudo completar captura visual en navegador. `flutter run -d
web-server` y `flutter build web` quedaron sin salida hasta timeout, por lo que
esta auditoria se basa en codigo, documentacion y pruebas de widgets.
