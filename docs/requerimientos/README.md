# Requerimientos

Requerimientos extraidos por ingenieria inversa desde el codigo fuente, las
pantallas, los controllers, repositorios, modelos y pruebas automatizadas del
proyecto Agenda.

Fecha de extraccion inicial: 2026-05-14.  
Ultima revision de requerimientos: 2026-05-26.

## Fuentes Revisadas

- `lib/main.dart`
- `lib/core/`
- `lib/features/tareas/`
- `lib/features/horario/`
- `lib/features/calendario/`
- `lib/features/configuracion/`
- `test/features/`
- `test/widget_test.dart`
- `docs/auditoria_heuristicas_nielsen.md`
- Presentacion de referencia:
  `Calidad de los requerimientos de software_atributos (1).pptx`

## Documentos

- [`requerimientos_funcionales.md`](requerimientos_funcionales.md): funciones
  que el sistema debe ofrecer, con prioridad, estado, criterios de aceptacion y
  validaciones sugeridas.
- [`requerimientos_funcionales_formato.md`](requerimientos_funcionales_formato.md):
  version tabular de los requerimientos funcionales con el patron
  Actor / Accion / Objeto de accion / Datos de entrada / Resultado esperado.
- [`requerimientos_no_funcionales.md`](requerimientos_no_funcionales.md):
  restricciones de plataforma, arquitectura, datos, pruebas, usabilidad,
  robustez y notificaciones.
- [`requerimientos_no_funcionales_formato.md`](requerimientos_no_funcionales_formato.md):
  version tabular de los RNF con actor responsable, accion esperada, objeto de
  calidad, condicion y resultado esperado.
- [`casos_de_uso.md`](casos_de_uso.md): casos de uso principales, flujos
  alternativos y requisitos relacionados.
- [`reglas_de_negocio.md`](reglas_de_negocio.md): reglas de validacion,
  clasificacion, recurrencia, calendario, configuracion y persistencia.
- [`reglas_de_negocio_formato.md`](reglas_de_negocio_formato.md): version
  tabular de reglas de negocio con actor responsable, accion regulada, objeto,
  condicion, resultado esperado y verificacion.
- [`trazabilidad.md`](trazabilidad.md): relacion entre requerimientos, casos de
  uso, reglas de negocio, pruebas y evidencia tecnica.

## Alcance Observado

El sistema implementa una agenda academica/personal con modulos de tareas,
horario, calendario, configuracion y navegacion.

El alcance funcional documentado se concentra en:

- Gestion de tareas y papelera.
- Clasificacion de tareas y progreso.
- Horario de clases recurrentes.
- Consulta de eventos de calendario.
- Configuracion local de preferencias de notificacion.
- Persistencia local y uso offline.

## Estado de Implementacion Detectado

- Implementado: gestion de tareas, papelera, clasificacion, progreso, horario,
  calendario de lectura y escritura, configuracion de preferencias y
  persistencia local.
- Implementado: notificaciones nativas encapsuladas en scheduler reemplazable,
  con programacion/cancelacion de avisos de eventos y pruebas automatizadas.
- Implementado: validaciones principales de tareas, clases y eventos. Tareas
  cubre normalizacion, longitudes, confirmacion de fechas pasadas y rechazo de
  duplicados exactos normalizados; clases cubre longitudes, rango horario y
  bloqueo de solapamientos; eventos cubre normalizacion, longitudes, rango,
  color por defecto y superposiciones.
- Sugerido desde auditoria Nielsen: corregir textos criticos con codificacion
  rota, agregar deshacer a acciones reversibles, reforzar borrado masivo,
  mejorar feedback de carga/guardado, estados vacios accionables y diagnostico
  de conflictos junto al campo afectado.

## Convencion Recomendada

Cada requisito debe mantenerse con:

- Identificador unico.
- Actor o responsable, accion, objeto de accion o calidad, condicion/datos de
  entrada y resultado esperado.
- Prioridad.
- Estado.
- Descripcion clara del comportamiento esperado.
- Criterios de aceptacion o validaciones cuando aplique.
- Trazabilidad hacia caso de uso, regla de negocio, prueba o evidencia tecnica.
