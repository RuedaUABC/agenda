# Requerimientos Funcionales

Este documento describe las funciones que debe ofrecer la aplicacion Agenda.
Los requisitos estan redactados desde la perspectiva del comportamiento
esperado, no desde la implementacion interna.

Estados usados:

- Implementado: el comportamiento existe en la aplicacion.
- Parcial: existe una parte del comportamiento, pero falta integracion,
  validacion o experiencia de usuario.
- Pendiente: no esta implementado o solo existe como TODO.
- Sugerido: mejora propuesta para reforzar calidad, seguridad de datos o
  experiencia de usuario.

## Navegacion

**RF-001. Navegacion principal por modulos**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe permitir navegar entre los modulos Tareas, Horario, Calendario
y Ajustes desde una navegacion principal siempre disponible.

Criterios de aceptacion:

- El usuario puede cambiar de modulo sin cerrar la aplicacion.
- El modulo seleccionado queda visualmente identificado.
- La navegacion no debe eliminar los datos cargados en los otros modulos.
- En pantallas moviles se usa barra inferior Material 3.
- En pantallas medianas o grandes se usa `NavigationRail`.

**RF-002. Conservacion de estado entre modulos**  
Prioridad: Media. Estado: Implementado.  
El sistema debe conservar el estado de cada modulo cuando el usuario cambia a
otro modulo y regresa.

Criterios de aceptacion:

- La fecha seleccionada en Horario o Calendario se conserva al volver.
- Las listas ya cargadas no se reinician innecesariamente al cambiar de modulo.

## Tareas

**RF-003. Consulta de tareas activas**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe mostrar al usuario las tareas activas almacenadas localmente.

Criterios de aceptacion:

- Solo se muestran tareas no enviadas a papelera.
- Si no existen tareas activas, se muestra un estado vacio comprensible.

**RF-004. Consulta de papelera**  
Prioridad: Media. Estado: Implementado.  
El sistema debe permitir consultar las tareas enviadas a papelera.

Criterios de aceptacion:

- La papelera muestra solo tareas eliminadas logicamente.
- Si la papelera esta vacia, el sistema informa que no hay tareas eliminadas.

**RF-005. Creacion de tareas**  
Prioridad: Alta. Estado: Implementado.  
El usuario debe poder crear una tarea con titulo, asignatura, descripcion,
fecha y hora.

Criterios de aceptacion:

- Al guardar una tarea valida, esta queda persistida localmente.
- La tarea creada aparece en la categoria que le corresponda.
- El formulario no debe cerrarse si existen errores de validacion.
- El formulario muestra titulo, accion de cancelar/cerrar y accion primaria de
  guardado en controles Material 3.

**RF-006. Validacion de datos de tarea**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe validar los datos capturados antes de guardar una tarea.

Validaciones requeridas:

- El titulo es obligatorio.
- El titulo no debe quedar compuesto solo por espacios.
- La fecha es obligatoria.
- La hora es obligatoria.
- La asignatura debe tener una longitud maxima definida por el sistema.
- La descripcion debe tener una longitud maxima definida por el sistema.
- Si la tarea se programa en una fecha pasada, el sistema debe advertir al
  usuario o solicitar confirmacion.

**RF-007. Edicion de tareas**  
Prioridad: Alta. Estado: Implementado.  
El usuario debe poder editar los datos de una tarea existente.

Criterios de aceptacion:

- El sistema precarga los datos actuales de la tarea.
- Al guardar cambios validos, la tarea se actualiza localmente.
- Las mismas validaciones de creacion aplican para la edicion.

**RF-008. Cambio de estado de tarea**  
Prioridad: Alta. Estado: Implementado.  
El usuario debe poder marcar una tarea como completada y devolver una tarea
completada al estado pendiente.

Criterios de aceptacion:

- El cambio de estado se refleja en la lista correspondiente.
- El cambio de estado se conserva al cerrar y abrir la aplicacion.

**RF-009. Eliminacion logica de tareas**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe enviar las tareas eliminadas a papelera en lugar de borrarlas
definitivamente.

Criterios de aceptacion:

- La tarea eliminada deja de mostrarse en tareas activas.
- La tarea eliminada aparece en papelera.
- El sistema debe pedir confirmacion antes de enviar una tarea a papelera.

**RF-010. Restauracion de tareas**  
Prioridad: Media. Estado: Implementado.  
El usuario debe poder restaurar una tarea desde papelera.

Criterios de aceptacion:

- La tarea restaurada vuelve a tareas activas.
- La tarea restaurada conserva sus datos originales.

**RF-011. Eliminacion definitiva de tareas**  
Prioridad: Baja. Estado: Implementado.  
El sistema deberia permitir eliminar definitivamente una tarea desde papelera,
previa confirmacion explicita del usuario.

Criterios de aceptacion:

- El sistema solicita confirmacion antes de eliminar definitivamente.
- Una tarea eliminada definitivamente ya no puede restaurarse.

**RF-012. Clasificacion de tareas**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe clasificar tareas activas en vencidas, pendientes de la semana,
proximas y completadas.

Criterios de aceptacion:

- Las tareas completadas se muestran en la categoria completadas.
- Las tareas no completadas se clasifican segun su fecha.
- La clasificacion se actualiza al crear, editar, eliminar, restaurar o
  completar una tarea.

**RF-013. Progreso diario**  
Prioridad: Media. Estado: Implementado.  
El sistema debe calcular el progreso del dia con base en las tareas de hoy
completadas frente al total de tareas de hoy.

Criterios de aceptacion:

- Si no hay tareas para hoy, el progreso es 0%.
- El progreso se actualiza al completar o devolver a pendiente una tarea de hoy.

**RF-014. Estadisticas semanales**  
Prioridad: Media. Estado: Implementado.  
El sistema debe calcular la cantidad de tareas pendientes por dia para los
proximos siete dias.

Criterios de aceptacion:

- Las tareas completadas no se cuentan como pendientes.
- La estadistica cubre siete dias contados desde la fecha actual.

**RF-015. Detalle de tarea**  
Prioridad: Media. Estado: Implementado.  
El usuario debe poder abrir el detalle de una tarea y consultar titulo,
asignatura, descripcion, fecha, hora y estado.

**RF-016. Filtrado de tareas**
Prioridad: Baja. Estado: Implementado.  
El sistema debe permitir filtrar tareas por estado desde la interfaz.

Criterios de aceptacion:

- El filtro de estado se presenta mediante un control segmentado Material 3.
- La interfaz de tareas no muestra barra de busqueda ni selector de fecha para
  conservar una jerarquia visual simple.
- La logica interna de busqueda y fecha puede conservarse en el controller para
  compatibilidad y pruebas de dominio, pero no se expone como control visible.

## Horario

**RF-017. Consulta de clases**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe cargar y mostrar las clases guardadas localmente.

**RF-018. Creacion de clases semanales**  
Prioridad: Alta. Estado: Implementado.  
El usuario debe poder crear una clase con materia, aula, fecha, hora de inicio,
hora de fin y color.

Criterios de aceptacion:

- Al guardar una clase valida, esta aparece en el horario semanal.
- La clase se conserva al cerrar y abrir la aplicacion.
- El formulario agrupa fecha y hora con botones Material 3 y selector de color
  accesible.

**RF-019. Validacion de datos de clase**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe validar los datos antes de guardar una clase.

Validaciones requeridas:

- La materia es obligatoria.
- La materia no debe quedar compuesta solo por espacios.
- La fecha o dia de clase es obligatorio.
- La hora de inicio es obligatoria.
- La hora de fin es obligatoria.
- La hora de fin debe ser posterior a la hora de inicio.
- El aula debe tener una longitud maxima definida por el sistema.
- Si existe otra clase en el mismo dia y rango horario, el sistema impide el
  guardado y muestra el conflicto al usuario.

**RF-020. Recurrencia semanal de clases**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe registrar las clases como eventos recurrentes semanales para el
dia seleccionado.

**RF-021. Visualizacion semanal de horario**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe mostrar las clases en una vista semanal de horario.

Criterios de aceptacion:

- En mobile, la vista semanal se alterna con la vista diaria mediante un
  `SegmentedButton` Material 3.
- En desktop, la vista semanal se muestra junto a un panel secundario del dia
  seleccionado.
- La accion `Hoy` permite volver rapidamente al dia actual sin perder el flujo
  de consulta.

**RF-022. Lista de clases por dia seleccionado**  
Prioridad: Media. Estado: Implementado.  
El sistema debe listar las clases correspondientes al dia seleccionado por el
usuario.

Criterios de aceptacion:

- La lista diaria muestra encabezado con contador de clases.
- El usuario puede cambiar de dia con chips de dias laborables.
- Si no hay clases, se muestra un estado vacio Material 3.
- Cada clase muestra materia, horario y aula con metadatos visuales claros.

**RF-023. Edicion de clases**  
Prioridad: Media. Estado: Implementado.  
El usuario debe poder modificar los datos de una clase existente aplicando las
mismas validaciones de creacion.

**RF-024. Eliminacion de clases**  
Prioridad: Media. Estado: Implementado.  
El usuario debe poder eliminar una clase existente.

Criterios de aceptacion:

- El sistema solicita confirmacion antes de eliminar.
- La clase eliminada deja de aparecer en el horario.

## Calendario

**RF-025. Consulta de eventos**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe cargar eventos guardados localmente.

**RF-026. Visualizacion mensual de eventos**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe mostrar eventos en una vista mensual de calendario.

Criterios de aceptacion:

- En mobile, la vista mensual se alterna con la agenda diaria mediante un
  `SegmentedButton` Material 3.
- En desktop, el calendario mensual se muestra junto a un panel secundario del
  dia seleccionado.
- La accion `Hoy` permite volver rapidamente a la fecha actual.

**RF-027. Seleccion de fecha en calendario**  
Prioridad: Media. Estado: Implementado.  
El sistema debe permitir seleccionar una fecha del calendario y conservar esa
seleccion mientras el usuario permanece en el modulo.

**RF-028. Lista de eventos por dia seleccionado**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe listar eventos que ocurran en el dia seleccionado, incluyendo
eventos que empiezan antes y terminan despues de esa fecha.

Criterios de aceptacion:

- La lista diaria muestra encabezado con contador de eventos.
- El usuario puede cambiar de fecha con chips Material 3.
- Si no hay eventos, se muestra un estado vacio Material 3.

**RF-029. Representacion visual de eventos**  
Prioridad: Media. Estado: Implementado.  
El sistema debe mostrar titulo, descripcion y color asociado de cada evento.

Criterios de aceptacion:

- El selector de color de eventos debe ofrecer objetivos tactiles de al menos
  `48x48`.
- Cada evento en la lista diaria muestra barra de color, icono, rango horario y
  descripcion como metadatos legibles.

**RF-030. Creacion de eventos desde la interfaz**  
Prioridad: Alta. Estado: Implementado.  
El usuario debe poder crear eventos desde el modulo Calendario.

Validaciones requeridas:

- El titulo es obligatorio.
- El titulo no debe quedar compuesto solo por espacios.
- La fecha y hora de inicio son obligatorias.
- La fecha y hora de fin son obligatorias.
- La fecha y hora de fin no deben ser anteriores al inicio.
- La descripcion debe tener una longitud maxima definida por el sistema.
- El color debe ser uno de los colores permitidos por la interfaz o un valor
  valido reconocido por el sistema.

**RF-031. Edicion de eventos desde la interfaz**  
Prioridad: Alta. Estado: Implementado.  
El usuario debe poder editar eventos existentes desde el modulo Calendario.

**RF-032. Eliminacion de eventos desde la interfaz**  
Prioridad: Media. Estado: Implementado.  
El usuario debe poder eliminar eventos existentes desde el modulo Calendario,
previa confirmacion.

**RF-033. Advertencia de eventos superpuestos**  
Prioridad: Baja. Estado: Implementado.  
El sistema debe advertir al usuario cuando un evento nuevo o editado se
superpone con otro evento existente y permitir cancelar o guardar de todos
modos.

## Configuracion

**RF-034. Consulta de preferencias de notificacion**  
Prioridad: Media. Estado: Implementado.  
El sistema debe cargar preferencias globales de notificacion para clases y
tareas desde almacenamiento local.

**RF-035. Configuracion de aviso de clases**  
Prioridad: Media. Estado: Implementado.  
El usuario debe poder seleccionar cuanto tiempo antes recibir avisos de clases.

Criterios de aceptacion:

- La seleccion se presenta con componentes Material 3 y texto descriptivo.

**RF-036. Configuracion del primer aviso de tareas**  
Prioridad: Media. Estado: Implementado.  
El usuario debe poder seleccionar cuanto tiempo antes recibir el primer aviso de
tareas.

Criterios de aceptacion:

- La seleccion se presenta con componentes Material 3 y conserva la
  reprogramacion de tareas pendientes.

**RF-037. Validacion de preferencias de notificacion**  
Prioridad: Media. Estado: Implementado.  
El sistema debe aceptar solo valores de anticipacion definidos por la aplicacion
y rechazar valores nulos, negativos o no soportados.

**RF-038. Persistencia de preferencias**  
Prioridad: Media. Estado: Implementado.  
El sistema debe guardar preferencias de notificacion en almacenamiento local.

**RF-039. Reprogramacion de tareas pendientes**  
Prioridad: Media. Estado: Implementado.  
Cuando cambian las preferencias de avisos de tareas, el sistema debe
reprogramar notificaciones de tareas no completadas.

## Persistencia

**RF-040. Persistencia local de datos**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe persistir tareas, clases, eventos y preferencias en
almacenamiento local para permitir uso offline.

**RF-041. Migracion de base de datos**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe manejar migraciones de esquema cuando aumente la version de la
base de datos.

**RF-042. Soporte de persistencia en escritorio**  
Prioridad: Alta. Estado: Implementado.  
El sistema debe inicializar los componentes necesarios para usar SQLite en
Windows y Linux.
