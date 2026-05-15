# Requerimientos

Requerimientos extraidos por ingenieria inversa desde el codigo fuente, las
pantallas, los controllers, repositorios, modelos y pruebas automatizadas del
proyecto Agenda.

Fecha de extraccion: 2026-05-14.

## Fuentes Revisadas

- `lib/main.dart`
- `lib/core/`
- `lib/features/tareas/`
- `lib/features/horario/`
- `lib/features/calendario/`
- `lib/features/configuracion/`
- `lib/features/auth/`
- `test/features/`
- `test/widget_test.dart`

## Documentos

- [`requerimientos_funcionales.md`](requerimientos_funcionales.md): funciones
  que el sistema debe ofrecer.
- [`requerimientos_no_funcionales.md`](requerimientos_no_funcionales.md):
  restricciones de plataforma, persistencia, arquitectura, pruebas y UX.
- [`casos_de_uso.md`](casos_de_uso.md): casos de uso derivados de las pantallas
  y controllers.
- [`reglas_de_negocio.md`](reglas_de_negocio.md): reglas observadas en modelos,
  controllers, DAOs y pruebas.
- [`trazabilidad.md`](trazabilidad.md): relacion entre requerimientos y archivos
  del proyecto.

## Alcance Observado

El sistema implementa una agenda academica/persona con modulos de tareas,
horario, calendario, configuracion y navegacion.

Tambien existen piezas de autenticacion con Google/Firebase y configuracion
generada de Firebase, pero el flujo no esta conectado al arranque actual de la
app porque `lib/main.dart` abre directamente la navegacion principal y mantiene
comentada la inicializacion de Firebase.

## Estado de Implementacion Detectado

- Implementado: gestion de tareas, papelera, clasificacion, progreso, horario,
  calendario de lectura, configuracion de preferencias y persistencia local.
- Parcial: notificaciones, porque el scheduler actual funciona como mock con
  `print` y la dependencia real esta comentada.
- Parcial: autenticacion, porque existe `LoginPage` y `AuthService`, pero no se
  usan como pantalla inicial.
- Pendiente: creacion y edicion de eventos desde la UI de calendario, marcadas
  como `TODO` en la pantalla.
