# Requerimientos Funcionales

## Navegacion

**RF-001. Navegacion principal por modulos**  
El sistema debe permitir navegar entre Inicio/Tareas, Horario, Calendario y
Ajustes mediante una barra de navegacion inferior.

**RF-002. Conservacion de estado entre pestañas**  
El sistema debe mantener montadas las pantallas principales al cambiar de
pestana mediante un `IndexedStack`.

## Tareas

**RF-003. Consulta de tareas activas**  
El sistema debe cargar y mostrar las tareas no eliminadas desde la base local.

**RF-004. Consulta de papelera**  
El sistema debe cargar y mostrar las tareas marcadas como eliminadas.

**RF-005. Creacion de tareas**  
El usuario debe poder crear una tarea con titulo, asignatura, descripcion,
fecha y hora.

**RF-006. Validacion de titulo de tarea**  
El sistema debe impedir guardar una tarea si el titulo esta vacio.

**RF-007. Edicion de tareas**  
El usuario debe poder editar los datos de una tarea existente.

**RF-008. Cambio de estado de tarea**  
El usuario debe poder marcar una tarea como completada y devolver una tarea
completada a pendiente.

**RF-009. Eliminacion logica de tareas**  
El sistema debe enviar las tareas eliminadas a papelera en lugar de borrarlas
fisicamente.

**RF-010. Restauracion de tareas**  
El usuario debe poder recuperar una tarea desde la papelera.

**RF-011. Clasificacion de tareas**  
El sistema debe clasificar tareas activas en vencidas, pendientes esta semana,
proximas y completadas.

**RF-012. Progreso diario**  
El sistema debe calcular el progreso del dia con base en tareas de hoy
completadas frente al total de tareas de hoy.

**RF-013. Estadisticas semanales**  
El sistema debe calcular la cantidad de tareas pendientes por dia para los
proximos siete dias.

**RF-014. Detalle de tarea**  
El usuario debe poder abrir el detalle de una tarea y consultar titulo,
asignatura, descripcion, fecha y estado.

## Horario

**RF-015. Consulta de clases**  
El sistema debe cargar y mostrar clases guardadas localmente.

**RF-016. Creacion de clases semanales**  
El usuario debe poder crear una clase con materia, aula, fecha, hora de inicio,
hora de fin y color.

**RF-017. Validacion de materia**  
El sistema debe impedir guardar una clase si la materia esta vacia.

**RF-018. Validacion de rango horario de clase**  
El sistema debe impedir guardar una clase si la hora de fin no es posterior a
la hora de inicio.

**RF-019. Recurrencia semanal de clases**  
El sistema debe crear clases con regla semanal `FREQ=WEEKLY;INTERVAL=1;BYDAY`.

**RF-020. Visualizacion semanal de horario**  
El sistema debe mostrar las clases en una vista semanal de calendario.

**RF-021. Lista de clases por dia seleccionado**  
El sistema debe listar las clases cuyo dia de semana coincide con el dia
seleccionado.

**RF-022. Actualizacion y eliminacion de clases desde controller**  
El dominio debe soportar actualizar y eliminar clases por medio del controller y
repositorio.

## Calendario

**RF-023. Consulta de eventos**  
El sistema debe cargar eventos guardados localmente.

**RF-024. Visualizacion mensual de eventos**  
El sistema debe mostrar eventos en una vista mensual de calendario.

**RF-025. Seleccion de fecha en calendario**  
El sistema debe mantener la fecha seleccionada al tocar una fecha del
calendario.

**RF-026. Lista de eventos por dia seleccionado**  
El sistema debe listar eventos que ocurran en el dia seleccionado, incluyendo
eventos que empiezan antes y terminan despues de esa fecha.

**RF-027. Representacion visual de eventos**  
El sistema debe mostrar titulo, descripcion y color asociado de cada evento.

**RF-028. Operaciones de eventos desde controller**  
El dominio debe soportar agregar, actualizar y eliminar eventos por medio del
controller y repositorio.

**RF-029. Formulario de eventos pendiente**  
El sistema debe incorporar una UI para crear y editar eventos. El codigo actual
solo expone el boton y deja la accion como `TODO`.

## Configuracion

**RF-030. Consulta de preferencias de notificacion**  
El sistema debe cargar preferencias globales de notificacion para clases y
tareas desde almacenamiento local.

**RF-031. Configuracion de aviso de clases**  
El usuario debe poder seleccionar cuanto tiempo antes recibir avisos de clases.

**RF-032. Configuracion del primer aviso de tareas**  
El usuario debe poder seleccionar cuanto tiempo antes recibir el primer aviso de
tareas.

**RF-033. Persistencia de preferencias**  
El sistema debe guardar preferencias de notificacion usando
`SharedPreferences`.

**RF-034. Reprogramacion de tareas pendientes**  
Cuando cambian las preferencias de avisos de tareas, el sistema debe
reprogramar notificaciones de tareas no completadas si existe un repositorio de
tareas inyectado.

## Autenticacion

**RF-035. Inicio de sesion con Google**  
El sistema contiene soporte para iniciar sesion con Google y Firebase Auth.

**RF-036. Cierre de sesion**  
El servicio de autenticacion debe permitir cerrar sesion en Google y Firebase.

**RF-037. Pantalla de autenticacion no conectada**  
La pantalla de login no debe considerarse parte del flujo inicial actual hasta
que `main.dart` la use como entrada y Firebase se inicialice.

## Persistencia

**RF-038. Persistencia local SQLite**  
El sistema debe persistir tareas, clases y eventos en una base local SQLite.

**RF-039. Migracion de base de datos**  
El sistema debe manejar migraciones de esquema cuando aumente la version de la
base.

**RF-040. Soporte SQLite en escritorio**  
El sistema debe inicializar `sqflite_common_ffi` en Windows y Linux.
