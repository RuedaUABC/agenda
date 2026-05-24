# Guia de Diseno Material 3

Esta guia define el rediseno objetivo de Agenda. El criterio principal es usar
Material 3 nativo de Flutter y tomar como referencia patrones de productos de
Google como Calendar, Tasks, Keep y Gmail: superficies limpias, jerarquia clara,
navegacion adaptativa, acciones principales visibles y estados vacios utiles.

No se busca copiar la marca visual de Google. La intencion es usar la misma
logica de producto: interfaces calmadas, previsibles y muy legibles para uso
frecuente.

## Objetivos

- Hacer que la aplicacion se sienta coherente entre tareas, horario,
  calendario y ajustes.
- Priorizar componentes Material 3 nativos antes que paquetes visuales
  externos.
- Soportar tema claro, oscuro y preferencia del sistema.
- Mejorar lectura, escaneo rapido y acciones frecuentes.
- Mantener una experiencia usable en telefono, tablet, escritorio y web.

## Fuentes de Inspiracion

- Google Calendar: calendario como superficie principal, panel lateral de
  agenda, colores discretos por evento y FAB para crear.
- Google Tasks: listas simples, checkbox visible, agrupacion por estado o
  fecha, acciones secundarias contenidas en detalle.
- Google Keep: tarjetas ligeras, estados vacios claros, chips para filtrar y
  busqueda prominente.
- Gmail: navegacion adaptativa con barra inferior en movil y rail/sidebar en
  pantallas amplias.

## Sistema Visual

### Tema

Cambios propuestos:

- Reemplazar el tema oscuro forzado por `ThemeMode.system`.
- Crear `AppTheme.lightTheme` y `AppTheme.darkTheme`.
- Generar `ColorScheme` con `ColorScheme.fromSeed`.
- Usar un seed sobrio, cercano al azul actual: `0xFF3B82F6`.
- Evitar negro puro como fondo. Usar roles Material 3 como `surface`,
  `surfaceContainer`, `surfaceContainerLow` y `surfaceContainerHighest`.
- Quitar colores directos en widgets cuando exista un rol del `ColorScheme`.

Resultado esperado:

- Modo claro como experiencia principal de productividad.
- Modo oscuro legible, sin contrastes duros ni superficies completamente negras.
- Componentes con estados hover, focus, pressed, selected y disabled coherentes.

### Tipografia

Cambios propuestos:

- Usar una sola familia desde el tema.
- Preferencia: Roboto para alinearse con Material/Google, o Inter si se quiere
  un tono mas editorial. No mezclar `Roboto` global con `GoogleFonts.outfit`
  por componente.
- Mapear estilos mediante `textTheme`: `headlineSmall`, `titleLarge`,
  `titleMedium`, `bodyLarge`, `bodyMedium`, `labelLarge`.
- Evitar tamanos hardcodeados en widgets salvo componentes muy especificos.

### Forma y Elevacion

Escala sugerida:

- `4`: indicadores pequenos, barras de color, elementos internos.
- `8`: tarjetas, inputs y chips.
- `12`: dialogs, sheets y contenedores destacados.
- `16`: FAB extendido y contenedores de alto protagonismo.

Cambios propuestos:

- Reducir radios grandes como `24` en cards de productividad.
- Usar elevacion baja y contenedores tonales en lugar de sombras fuertes.
- Usar `CardTheme`, `DialogTheme`, `BottomSheetThemeData` y `InputDecorationTheme`.

## Navegacion Adaptativa

Cambios propuestos:

- Reemplazar `GNav` por componentes Material 3 nativos.
- En movil: usar `NavigationBar` con 4 destinos.
- En tablet/escritorio: usar `NavigationRail` o sidebar expandible.
- Mantener `IndexedStack` para conservar estado entre modulos.
- Usar etiquetas consistentes:
  - Tareas
  - Horario
  - Calendario
  - Ajustes

Regla responsive:

- Menos de `600dp`: `NavigationBar`.
- Entre `600dp` y `1024dp`: `NavigationRail`.
- Desde `1024dp`: rail extendido o sidebar con contenido en dos columnas.

## Pantalla de Tareas

Inspiracion principal: Google Tasks + Keep.

Cambios concretos:

- Convertir cada tarea en un item escaneable con checkbox a la izquierda.
- Mostrar fecha/hora con icono pequeno y texto secundario.
- Usar color semantico para vencidas, no solo ubicacion en una seccion.
- Mantener categorias, pero mostrar encabezados compactos con contador:
  `Vencidas (3)`, `Hoy (2)`, `Esta semana (5)`.
- Mantener un unico filtro visible mediante `SegmentedButton` de estado.
- No mostrar `SearchBar` ni selector de fecha en esta pantalla para evitar una
  cabecera de filtros inconexa.
- Agregar estado vacio cuando no haya tareas filtradas.
- Agregar snackbar con accion `Deshacer` al completar, eliminar o restaurar.
- En desktop, usar panel principal de tareas y panel derecho de detalle o
  resumen, no una segunda columna vacia o secundaria sin jerarquia.

Cambios en formularios de tareas:

- El titulo del sheet debe ir primero: `Nueva tarea` o `Editar tarea`.
- El boton primario debe ir al final o en una barra fija inferior.
- Usar `FilledButton` para guardar y `TextButton` para cancelar.
- Mostrar estado de guardado deshabilitando el boton y cambiando el texto a
  `Guardando...`.
- Date/time pickers deben presentarse como filas/botones con icono, no como
  texto suelto + `Cambiar`.
- Los errores deben aparecer cerca del campo afectado.

## Pantalla de Calendario

Inspiracion principal: Google Calendar.

Cambios concretos:

- Mantener vista mensual en movil, pero con encabezado que indique mes actual y
  acceso claro a `Hoy`.
- En desktop, calendario a la izquierda y agenda del dia a la derecha.
- En eventos, usar una barra de color fina o punto de color, no bloques
  saturados.
- Agregar estado vacio con icono, texto y accion: `Crear evento`.
- Al tocar un evento, abrir detalle en sheet con acciones editar/eliminar.
- La accion destructiva debe usar `colorScheme.error`.
- Agregar accion `Hoy` para volver rapidamente a la fecha actual.
- En mobile, usar selector segmentado Material 3 para alternar `Mes` y `Dia`.
- Mostrar contador de eventos y chips de fechas en la agenda diaria.

Estado de esta iteracion: implementado en mobile y desktop con
`SegmentedButton`, `ChoiceChip`, `AgendaSectionHeader`, `AgendaEmptyState` y
tarjetas `Card.filled` para eventos.

Cambios en formulario de eventos:

- Mantener `FilledButton.icon` para guardar.
- Agregar boton cancelar/cerrar visible.
- Agrupar inicio y fin en una seccion `Fecha y hora`.
- El selector de color debe tener area tactil minima de `48x48`.
- El color seleccionado debe comunicarse con borde, check y tooltip especifico.
- Cuando haya superposicion, el dialogo debe explicar con que evento se cruza
  si la informacion esta disponible.

## Pantalla de Horario

Inspiracion principal: Google Calendar en vista semanal.

Cambios concretos:

- Vista semanal como foco principal.
- Lista del dia seleccionado como panel secundario.
- Agregar accion `Hoy` o `Esta semana`.
- Usar colores suaves por clase y alto contraste en texto.
- Mostrar aula como metadato secundario con icono.
- En movil, usar selector segmentado Material 3 para alternar `Semana` y
  `Dia`.
- Mostrar contador de clases, chips de dias laborables y estado vacio
  consistente cuando no haya clases del dia seleccionado.

Estado de esta iteracion: implementado en mobile y desktop con
`SegmentedButton`, `ChoiceChip`, `AgendaSectionHeader`, `AgendaEmptyState` y
tarjetas `Card.filled` para clases.

Cambios en formulario de clases:

- Usar la misma estructura que eventos para fecha y hora.
- Mantener validacion de conflictos cerca de la seccion horario.
- Explicar la recurrencia semanal en texto secundario discreto:
  `Se repetira cada semana este dia`.

## Pantalla de Ajustes

Inspiracion principal: ajustes de apps Google.

Cambios concretos:

- Reemplazar card unica por una lista de secciones.
- Usar `ListTile` con icono, titulo, descripcion y trailing control.
- Reemplazar `DropdownButton` por `DropdownMenu` o selector en dialog/sheet.
- Agregar selector de tema con `SegmentedButton` para Sistema, Claro y Oscuro.
- Agregar preferencia de vista inicial con `DropdownMenu`.
- Agregar preferencias de densidad visual e inicio de semana con
  `SegmentedButton` y aplicarlas en listas, calendario y horario.
- Agregar switch de confirmaciones destructivas y mantener confirmacion
  reforzada obligatoria para borrado masivo.
- Agregar seccion de gestion de datos con exportacion/importacion validada y
  borrado total protegido sobre datos locales reales.
- Agregar seccion de informacion solo lectura con version, almacenamiento y
  estado de notificaciones.
- En desktop, usar el espacio derecho para una descripcion de la opcion
  seleccionada o vista previa de recordatorios.
- Agregar estado de permisos de notificacion cuando existan notificaciones
  nativas.

## Componentes Compartidos

Crear o consolidar componentes en `lib/core/widgets/`:

- `AgendaEmptyState`: icono, titulo, descripcion y accion opcional.
- `AgendaSectionHeader`: titulo, contador y accion opcional.
- `AgendaDateTimeButton`: boton tonal para seleccionar fecha u hora.
- `AgendaColorPicker`: selector accesible de colores.
- `AgendaResponsiveScaffold`: decide entre `NavigationBar`, `NavigationRail`
  y sidebar.
- `AgendaConfirmDialog`: dialogo consistente para acciones destructivas.

## Accesibilidad

Cambios obligatorios:

- Area tactil minima de `48x48` para iconos, chips y colores.
- Tooltips o labels para botones icon-only.
- No transmitir estado solo por color.
- Mantener contraste minimo de texto normal `4.5:1`.
- Permitir escalado de texto sin overflow en botones, cards y sheets.
- Dialogos y sheets con cierre visible y ruta de escape.

## Motion

Cambios propuestos:

- Duraciones de microinteraccion entre `150ms` y `250ms`.
- Evitar animaciones decorativas.
- Usar animacion solo para seleccion, apertura de sheets, cambios de filtro y
  feedback de acciones.
- Respetar `MediaQuery.disableAnimations` cuando aplique.

## Fases de Implementacion

Estado de esta iteracion: implementado el alcance **Base + UI clave**. Quedan
fuera de esta iteracion los flujos nuevos de `Deshacer` en snackbars y el
estado de permisos de notificaciones nativas.

### Fase 1: Base Material 3

- Crear tema claro y oscuro con `ColorScheme.fromSeed`.
- Cambiar `ThemeMode.dark` a `ThemeMode.system`.
- Unificar tipografia desde `AppTheme`.
- Definir temas globales de inputs, cards, buttons, dialogs, sheets y FAB.
- Reemplazar usos de `withOpacity` por `withValues`.

### Fase 2: Navegacion y Layout

- Sustituir `GNav` por `NavigationBar`.
- Agregar `NavigationRail` para pantallas medianas y grandes.
- Crear scaffold responsivo compartido.
- Revisar paddings para que ningun contenido quede oculto por barras fijas.

### Fase 3: Tareas

- Redisenar filtros con un unico `SegmentedButton` de estado.
- Redisenar items con checkbox, fecha y acciones secundarias.
- Agregar estados vacios.
- Agregar undo en snackbars para acciones reversibles.
- Reordenar `TareaForm`.

### Fase 4: Calendario y Horario

- Unificar patrones de agenda diaria.
- Mejorar sheets de detalle.
- Redisenar formularios de evento y clase con secciones.
- Ajustar selectores de color a area tactil minima.

### Fase 5: Ajustes y Pulido

- Redisenar ajustes como lista de secciones.
- Revisar textos, acentos y consistencia de etiquetas.
- Implementar ajustes avanzados base: tema, vista inicial, aviso de eventos,
  densidad, inicio de semana, confirmaciones, gestion de datos e informacion de
  app.
- Probar light/dark, movil, tablet y desktop.
- Ejecutar `flutter analyze` y pruebas de widgets criticos.

## Checklist de Aceptacion

- La app usa `useMaterial3: true` y componentes Material 3 nativos.
- La navegacion cambia entre barra inferior y rail/sidebar segun ancho.
- La app respeta el modo del sistema.
- No hay colores hardcodeados para superficies, texto o estados comunes.
- Los formularios tienen titulo, campos, errores cercanos y accion primaria al
  final.
- Las listas tienen estados vacios utiles.
- Las acciones destructivas usan color de error y confirmacion.
- Los selectores de color y botones icon-only cumplen area minima tactil.
- La experiencia se verifica en al menos 375, 768, 1024 y 1440 px de ancho.

## Referencias

- Flutter Material Design: https://docs.flutter.dev/ui/design/material
- Migracion Material 3 en Flutter: https://docs.flutter.dev/release/breaking-changes/material-3-migration
- `ColorScheme` en Flutter: https://api.flutter.dev/flutter/material/ColorScheme-class.html
- Material 3: https://m3.material.io/
