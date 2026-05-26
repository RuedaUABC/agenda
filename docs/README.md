# Documentacion del Proyecto

Esta carpeta concentra la documentacion tecnica de Agenda. El README de la
raiz queda como entrada rapida, mientras que estos documentos explican como
esta organizado el proyecto y como trabajar con el.

## Indice

- [`arquitectura.md`](arquitectura.md): estructura del codigo, capas por
  feature, dependencias internas y flujo de datos.
- [`casos_prueba.md`](casos_prueba.md): casos de prueba completos por
  funcionalidad usando el template formal de test case.
- [`desarrollo.md`](desarrollo.md): requisitos, instalacion, ejecucion,
  comandos de mantenimiento y notas de servicios externos.
- [`diseno_material3.md`](diseno_material3.md): guia objetivo de interfaz
  Material 3 inspirada en patrones de Google Calendar, Tasks, Keep y Gmail.
- [`pruebas.md`](pruebas.md): resumen de cobertura y comandos para correr
  pruebas por modulo.
- [`requerimientos/README.md`](requerimientos/README.md): indice de
  requerimientos funcionales, no funcionales, reglas de negocio, casos de uso,
  trazabilidad y versiones tabulares con atributos de calidad.
- [`plan_verificacion_validacion.md`](plan_verificacion_validacion.md): plan
  de verificacion y validacion del proyecto.
- [`reporte_vyv_borrador.md`](reporte_vyv_borrador.md): borrador del reporte
  de verificacion y validacion, con pendientes marcados.
- [`auditoria_heuristicas_nielsen.md`](auditoria_heuristicas_nielsen.md):
  auditoria de usabilidad basada en heuristicas de Nielsen.
- [`red_green_refactor_eventos.md`](red_green_refactor_eventos.md): evidencia
  TDD para creacion, edicion, eliminacion y validaciones de eventos.
- [`red_green_refactor_diseno_material3.md`](red_green_refactor_diseno_material3.md):
  evidencia TDD del rediseno Material 3.
- [`red_green_refactor_horario_material3.md`](red_green_refactor_horario_material3.md):
  evidencia TDD del refinamiento Material 3 de la pantalla Horario.
- [`red_green_refactor_calendario_material3.md`](red_green_refactor_calendario_material3.md):
  evidencia TDD del refinamiento Material 3 del calendario de eventos.
- [`red_green_refactor_ajustes_avanzados.md`](red_green_refactor_ajustes_avanzados.md):
  evidencia TDD para ajustes avanzados Material 3.
- [`red_green_refactor_validaciones.md`](red_green_refactor_validaciones.md):
  evidencia TDD para validaciones completas de tareas y clases.
- [`red_green_refactor_tareas_configuracion_robustez.md`](red_green_refactor_tareas_configuracion_robustez.md):
  evidencia TDD para borrado definitivo, filtros, preferencias,
  superposiciones y errores visibles.
- [`red_green_refactor_recuperacion_confirmaciones.md`](red_green_refactor_recuperacion_confirmaciones.md):
  evidencia TDD para recuperacion, confirmaciones reforzadas, feedback de
  carga/guardado, estados vacios accionables y diagnostico de conflictos.

## Resumen Funcional

Agenda permite administrar:

- Tareas academicas o personales, con clasificacion por vencidas, pendientes de
  la semana, proximas y completadas.
- Papelera de tareas para restaurar elementos eliminados.
- Horario de clases con recurrencia semanal.
- Eventos de calendario.
- Preferencias globales para recordatorios.

## Convenciones de Documentacion

- Mantener la documentacion cercana al comportamiento real del codigo.
- Actualizar `docs/pruebas.md` cuando se agreguen pruebas relevantes.
- Actualizar `docs/arquitectura.md` si cambia la estructura de `lib/`.
- Actualizar `docs/desarrollo.md` cuando cambien requisitos, comandos o pasos
  de configuracion.
- Actualizar `docs/diseno_material3.md` cuando cambien lineamientos visuales,
  componentes compartidos o patrones responsive.
- Actualizar `docs/requerimientos/README.md` y los documentos tabulares cuando
  cambie el alcance o el formato de requerimientos.
