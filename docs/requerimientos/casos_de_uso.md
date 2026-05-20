# Casos de Uso

## CU-001. Navegar entre modulos

Actor: Usuario.

Precondicion: La aplicacion esta abierta.

Flujo principal:

1. El usuario toca una opcion de la navegacion principal.
2. El sistema cambia al modulo seleccionado.
3. El sistema conserva el estado de los modulos ya cargados.

Resultado: El usuario visualiza Tareas, Horario, Calendario o Ajustes.

Requisitos relacionados: RF-001, RF-002.

## CU-002. Crear tarea

Actor: Usuario.

Precondicion: El usuario esta en el modulo Tareas.

Flujo principal:

1. El usuario toca el boton de agregar.
2. El sistema abre el formulario de tarea.
3. El usuario captura titulo, asignatura, descripcion, fecha y hora.
4. El usuario guarda.
5. El sistema valida los datos.
6. El sistema persiste la tarea localmente.
7. El sistema recarga la lista y clasifica la tarea.

Flujos alternativos:

- Si el titulo esta vacio o solo contiene espacios, el sistema muestra un
  mensaje de validacion y no guarda.
- Si falta fecha u hora, el sistema muestra un mensaje de validacion y no
  guarda.
- Si la fecha y hora estan en el pasado, el sistema advierte al usuario o pide
  confirmacion antes de guardar.
- Si el usuario cancela, el sistema cierra el formulario sin crear la tarea.

Resultado: La tarea aparece en la categoria correspondiente.

Requisitos relacionados: RF-005, RF-006, RF-012.

## CU-003. Gestionar tarea existente

Actor: Usuario.

Precondicion: Existe al menos una tarea activa.

Flujo principal:

1. El usuario abre el detalle de una tarea.
2. El sistema muestra los datos de la tarea.
3. El usuario completa, devuelve a pendiente, edita o elimina la tarea.
4. El sistema valida la accion solicitada.
5. El sistema actualiza la tarea y recarga las listas.

Flujos alternativos:

- Si el usuario edita la tarea con datos invalidos, el sistema informa los
  errores y no guarda.
- Si el usuario elimina la tarea, el sistema solicita confirmacion.
- Si el usuario cancela la confirmacion, la tarea no cambia.

Resultado: La tarea refleja la accion realizada.

Requisitos relacionados: RF-007, RF-008, RF-009, RF-015.

## CU-004. Recuperar tarea de papelera

Actor: Usuario.

Precondicion: Existe una tarea marcada como eliminada.

Flujo principal:

1. El usuario abre la seccion Papelera.
2. El sistema muestra tareas eliminadas.
3. El usuario selecciona una tarea.
4. El usuario toca Recuperar.
5. El sistema cambia la tarea a activa.
6. El sistema recarga tareas activas y papelera.

Resultado: La tarea vuelve a las tareas activas.

Requisitos relacionados: RF-004, RF-010.

## CU-005. Consultar progreso de tareas

Actor: Usuario.

Precondicion: El modulo Tareas puede cargar datos locales.

Flujo principal:

1. El usuario entra al modulo Tareas.
2. El sistema carga tareas activas.
3. El sistema calcula progreso diario.
4. El sistema calcula estadisticas de los proximos siete dias.
5. El sistema muestra el panel de progreso.

Resultado: El usuario visualiza avance diario y carga de trabajo proxima.

Requisitos relacionados: RF-013, RF-014.

## CU-006. Crear clase semanal

Actor: Usuario.

Precondicion: El usuario esta en el modulo Horario.

Flujo principal:

1. El usuario toca el boton de agregar.
2. El sistema abre el formulario de clase.
3. El usuario captura materia, aula, dia, hora de inicio, hora de fin y color.
4. El usuario guarda.
5. El sistema valida materia, dia y rango horario.
6. El sistema verifica posibles conflictos de horario.
7. El sistema crea la recurrencia semanal.
8. El sistema guarda la clase y recarga el horario.

Flujos alternativos:

- Si la materia esta vacia o solo contiene espacios, el sistema muestra
  validacion y no guarda.
- Si la hora de fin no es posterior a la de inicio, el sistema muestra
  validacion y no guarda.
- Si existe conflicto con otra clase, el sistema advierte al usuario o impide
  guardar segun la politica definida.
- Si el usuario cancela, el sistema cierra el formulario sin crear la clase.

Resultado: La clase aparece en el horario semanal y en la lista del dia.

Requisitos relacionados: RF-018, RF-019, RF-020, RF-021, RF-022.

## CU-007. Consultar horario

Actor: Usuario.

Precondicion: El modulo Horario puede cargar datos locales.

Flujo principal:

1. El usuario entra al modulo Horario.
2. El sistema muestra el calendario semanal.
3. El usuario selecciona una fecha.
4. El sistema lista clases cuyo dia coincide con la fecha seleccionada.

Resultado: El usuario consulta clases del dia seleccionado.

Requisitos relacionados: RF-017, RF-021, RF-022.

## CU-008. Consultar calendario de eventos

Actor: Usuario.

Precondicion: El modulo Calendario puede cargar datos locales.

Flujo principal:

1. El usuario entra al modulo Calendario.
2. El sistema muestra una vista mensual.
3. El usuario selecciona una fecha.
4. El sistema lista eventos que ocurren en esa fecha.

Resultado: El usuario consulta los eventos del dia seleccionado.

Requisitos relacionados: RF-025, RF-026, RF-027, RF-028, RF-029.

## CU-009. Crear o editar evento

Actor: Usuario.

Precondicion: El usuario esta en el modulo Calendario.

Flujo principal:

1. El usuario solicita crear o editar un evento.
2. El sistema abre el formulario de evento.
3. El usuario captura titulo, descripcion, inicio, fin y color.
4. El usuario guarda.
5. El sistema valida los datos.
6. El sistema guarda el evento localmente.
7. El sistema recarga el calendario y la lista del dia seleccionado.

Flujos alternativos:

- Si el titulo esta vacio o solo contiene espacios, el sistema muestra
  validacion y no guarda.
- Si falta inicio o fin, el sistema muestra validacion y no guarda.
- Si el fin es anterior al inicio, el sistema muestra validacion y no guarda.
- Si el evento se superpone con otro, el sistema advierte al usuario o impide
  guardar segun la politica definida.

Resultado: El evento queda disponible en el calendario.

Estado actual: pendiente desde la interfaz.

Requisitos relacionados: RF-030, RF-031, RF-032, RF-033.

## CU-010. Configurar notificaciones globales

Actor: Usuario.

Precondicion: El usuario esta en Ajustes.

Flujo principal:

1. El sistema muestra las preferencias actuales.
2. El usuario selecciona anticipacion para clases.
3. El usuario selecciona anticipacion para el primer aviso de tareas.
4. El sistema valida que los valores seleccionados sean permitidos.
5. El sistema guarda las preferencias.
6. El sistema reprograma tareas pendientes cuando corresponde.

Flujos alternativos:

- Si se recibe un valor no permitido, el sistema lo rechaza y conserva la
  preferencia anterior.
- Si ocurre un error al guardar, el sistema informa el problema.

Resultado: Las preferencias quedan persistidas localmente.

Requisitos relacionados: RF-034, RF-035, RF-036, RF-037, RF-038, RF-039.
