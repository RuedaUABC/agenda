# Documentacion del Proyecto

Esta carpeta concentra la documentacion tecnica de Agenda. El README de la
raiz queda como entrada rapida, mientras que estos documentos explican como
esta organizado el proyecto y como trabajar con el.

## Indice

- [`arquitectura.md`](arquitectura.md): estructura del codigo, capas por
  feature, dependencias internas y flujo de datos.
- [`desarrollo.md`](desarrollo.md): requisitos, instalacion, ejecucion,
  comandos de mantenimiento y notas de Firebase.
- [`pruebas.md`](pruebas.md): resumen de cobertura y comandos para correr
  pruebas por modulo.

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
