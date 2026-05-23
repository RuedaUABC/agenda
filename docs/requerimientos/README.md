# Requerimientos

Requerimientos extraidos por ingenieria inversa desde el codigo fuente, las
pantallas, los controllers, repositorios, modelos y pruebas automatizadas del
proyecto Agenda.

Fecha de extraccion inicial: 2026-05-14.  
Ultima revision de requerimientos: 2026-05-23.

## Fuentes Revisadas

- `lib/main.dart`
- `lib/core/`
- `lib/features/tareas/`
- `lib/features/horario/`
- `lib/features/calendario/`
- `lib/features/configuracion/`
- `test/features/`
- `test/widget_test.dart`

## Documentos

- [`requerimientos_funcionales.md`](requerimientos_funcionales.md): funciones
  que el sistema debe ofrecer, con prioridad, estado, criterios de aceptacion y
  validaciones sugeridas.
- [`requerimientos_no_funcionales.md`](requerimientos_no_funcionales.md):
  restricciones de plataforma, arquitectura, datos, pruebas, usabilidad,
  robustez y notificaciones.
- [`casos_de_uso.md`](casos_de_uso.md): casos de uso principales, flujos
  alternativos y requisitos relacionados.
- [`reglas_de_negocio.md`](reglas_de_negocio.md): reglas de validacion,
  clasificacion, recurrencia, calendario, configuracion y persistencia.
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
- Parcial: notificaciones, porque el scheduler actual funciona como mock o
  implementacion reemplazable y no debe considerarse notificacion nativa real
  completa.
- Implementado: validaciones principales de tareas, clases y eventos. Tareas
  cubre normalizacion, longitudes y confirmacion de fechas pasadas; clases
  cubre longitudes, rango horario y bloqueo de conflictos; eventos cubre
  normalizacion, longitudes, rango, color por defecto y superposiciones.

## Convencion Recomendada

Cada requisito debe mantenerse con:

- Identificador unico.
- Prioridad.
- Estado.
- Descripcion clara del comportamiento esperado.
- Criterios de aceptacion o validaciones cuando aplique.
- Trazabilidad hacia caso de uso, regla de negocio, prueba o evidencia tecnica.
