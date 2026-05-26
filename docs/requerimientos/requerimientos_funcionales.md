# Requerimientos Funcionales

Este documento describe las funciones que debe ofrecer la aplicacion Agenda.
Los requisitos estan redactados desde la perspectiva del comportamiento
esperado, no desde la implementacion interna.

Version tabular con el formato Actor / Accion / Objeto de accion / Datos de
entrada / Resultado esperado:
[`requerimientos_funcionales_formato.md`](requerimientos_funcionales_formato.md).

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
- No debe existir otra tarea registrada con los mismos titulo, asignatura,
  descripcion, fecha y hora normalizados; en edicion se excluye la tarea con el
  mismo identificador.

**RF-007. Edicion de tareas**
Prioridad: Alta. Estado: Implementado.
El usuario debe poder editar los datos de una tarea existente.

Criterios de aceptacion:

- El sistema precarga los datos actuales de la tarea.
- Al guardar cambios validos, la tarea se actualiza localmente.
- Las mismas validaciones de creacion aplican para la edicion.
- La edicion no debe permitir que la tarea quede con datos identicos a otra
  tarea registrada.

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
- Si existe otra clase en el mismo dia con un rango horario solapado parcial o
  totalmente, el sistema impide el guardado y muestra el conflicto al usuario.

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

**RF-043. Configuracion de aviso de eventos**
Prioridad: Media. Estado: Implementado.
El usuario debe poder seleccionar cuanto tiempo antes recibir avisos de
eventos.

Criterios de aceptacion:

- La configuracion debe ofrecer las mismas opciones permitidas por la aplicacion
  para otros avisos, incluyendo "Sin recordatorio" si aplica.
- La seleccion debe presentarse con componentes Material 3 y texto descriptivo.
- El valor seleccionado debe persistirse localmente.
- Cuando cambie la preferencia, los eventos futuros se reprograman con el
  scheduler nativo disponible.
- La opcion "Sin recordatorio" cancela el aviso del evento y no agenda uno
  nuevo.
- Implementado: selector Material 3, persistencia local, defaults validados,
  scheduler nativo y pruebas con repositorio inyectable.

**RF-044. Preferencia de tema visual**
Prioridad: Media. Estado: Implementado.
El usuario debe poder elegir el tema visual de la aplicacion.

Opciones requeridas:

- Seguir sistema.
- Claro.
- Oscuro.

Criterios de aceptacion:

- La seleccion debe persistirse localmente.
- La aplicacion debe aplicar la preferencia sin reiniciar.
- El valor por defecto debe ser "Seguir sistema".
- La UI debe usar componentes Material 3, preferentemente `SegmentedButton` o
  `RadioListTile`.

**RF-045. Vista inicial de la aplicacion**
Prioridad: Baja. Estado: Implementado.
El usuario debe poder elegir que modulo se abre al iniciar la aplicacion.

Opciones requeridas:

- Tareas.
- Horario.
- Calendario.
- Ajustes.

Criterios de aceptacion:

- La seleccion debe persistirse localmente.
- Si la preferencia esta ausente o es invalida, la aplicacion debe abrir el
  modulo por defecto definido por el sistema.
- La navegacion debe mantener seleccionado el modulo inicial correcto.

**RF-046. Densidad visual de listas**
Prioridad: Baja. Estado: Implementado.
El usuario debe poder elegir la densidad visual de listas y paneles de
contenido.

Opciones requeridas:

- Comoda.
- Compacta.

Criterios de aceptacion:

- La preferencia debe afectar listas de tareas, clases y eventos.
- La densidad compacta no debe reducir objetivos tactiles por debajo de `48x48`.
- La seleccion debe persistirse localmente.
- Implementado: preferencia, selector Material 3, persistencia local y
  aplicacion en listas de tareas, clases y eventos.

**RF-047. Inicio de semana configurable**
Prioridad: Baja. Estado: Implementado.
El usuario debe poder elegir el dia de inicio de semana para vistas de
calendario y horario.

Opciones requeridas:

- Lunes.
- Domingo.

Criterios de aceptacion:

- La preferencia debe aplicarse a calendario mensual y horario semanal.
- El valor por defecto debe ser lunes.
- La seleccion debe persistirse localmente.
- Implementado: preferencia, selector Material 3, default, persistencia local y
  aplicacion en calendario y horario.

**RF-048. Confirmaciones configurables para acciones destructivas**
Prioridad: Media. Estado: Parcial.
El usuario debe poder activar o desactivar confirmaciones antes de acciones
destructivas.

Acciones cubiertas:

- Eliminar tareas.
- Eliminar clases.
- Eliminar eventos.
- Borrar datos locales.

Criterios de aceptacion:

- Las confirmaciones deben estar activadas por defecto.
- Las acciones irreversibles de alto impacto, como borrar todos los datos, deben
  conservar confirmacion obligatoria aunque la preferencia general este
  desactivada.
- Desactivar confirmaciones comunes no debe eliminar mecanismos de recuperacion
  cuando la accion sea reversible.
- La preferencia debe persistirse localmente.
- Implementado parcialmente: preferencia, switch Material 3, persistencia local,
  eliminacion comun de tareas, clases y eventos sin dialogo cuando se desactiva
  y confirmacion obligatoria para borrado masivo. Pendiente: reforzar realmente
  el borrado masivo con una defensa explicita adicional.

**RF-049. Gestion de datos locales**
Prioridad: Baja. Estado: Parcial.
El usuario debe poder gestionar sus datos locales desde Ajustes.

Acciones propuestas:

- Exportar respaldo.
- Importar respaldo.
- Borrar todos los datos locales.

Criterios de aceptacion:

- Exportar debe generar un archivo con tareas, clases, eventos y preferencias.
- Importar debe validar formato y version antes de modificar datos existentes.
- Borrar todos los datos debe solicitar confirmacion reforzada.
- La confirmacion reforzada debe requerir una accion deliberada adicional, como
  escribir una palabra de confirmacion, confirmar el alcance exacto o completar
  un segundo paso no ambiguo.
- El dialogo de borrado total debe comunicar que datos seran afectados y que
  consecuencias tiene la accion.
- La accion destructiva de borrado total debe usar tratamiento visual de error
  del `ColorScheme`.
- Las acciones deben informar exito o error con mensajes visibles.
- Implementado parcialmente: generacion/validacion de respaldo JSON desde controller,
  exportacion de datos reales, importacion validada al store local, selector y
  escritura de archivo nativo mediante `file_selector`, seccion Material 3 y
  borrado completo de datos locales con confirmacion basica. Pendiente:
  confirmacion reforzada verificable.

**RF-050. Informacion de la aplicacion**
Prioridad: Baja. Estado: Implementado.
El usuario debe poder consultar informacion general de la aplicacion desde
Ajustes.

Informacion requerida:

- Version de la app.
- Estado de almacenamiento local.
- Estado de notificaciones nativas.

Criterios de aceptacion:

- La informacion debe mostrarse en una seccion Material 3 de solo lectura.
- El estado de notificaciones debe indicar que la funcionalidad nativa esta
  configurada.

## Usabilidad y recuperacion

**RF-051. Recuperacion de acciones reversibles**
Prioridad: Alta. Estado: Sugerido.
El sistema debe permitir recuperar acciones destructivas o de cambio de estado
cuando tecnicamente sean reversibles.

Acciones cubiertas:

- Enviar una tarea a papelera.
- Marcar una tarea como completada o devolverla a pendiente.
- Restaurar una tarea desde papelera.
- Eliminar una clase, cuando el modelo permita reconstruirla sin perdida.
- Eliminar un evento, cuando el modelo permita reconstruirlo sin perdida.

Criterios de aceptacion:

- Despues de una accion reversible, el sistema muestra un `SnackBar` con accion
  `Deshacer`.
- Si el usuario toca `Deshacer`, la entidad vuelve al estado anterior.
- Si la accion no puede revertirse, el sistema debe indicarlo antes de ejecutar
  la operacion.
- El mensaje de exito debe nombrar la accion realizada, por ejemplo "Evento
  eliminado" o "Tarea completada".

**RF-052. Estados de carga y guardado informativos**
Prioridad: Media. Estado: Sugerido.
El sistema debe informar claramente cuando una pantalla, formulario o accion
esta cargando o guardando datos.

Criterios de aceptacion:

- Las pantallas principales muestran indicador de carga con texto contextual,
  por ejemplo "Cargando tareas".
- Los botones de guardado se deshabilitan mientras la operacion esta en curso.
- El texto del boton cambia durante la operacion cuando esta dure mas de una
  interaccion instantanea, por ejemplo "Guardando".
- La interfaz evita ejecutar dos veces la misma accion por taps repetidos.

**RF-053. Estados vacios accionables**
Prioridad: Media. Estado: Sugerido.
El sistema debe mostrar estados vacios especificos para cada modulo o categoria
y ofrecer una accion directa cuando exista una siguiente accion natural.

Criterios de aceptacion:

- El estado vacio de tareas distingue entre vencidas, pendientes, proximas,
  completadas y papelera.
- Calendario y horario ofrecen crear evento o clase cuando no hay elementos en
  la fecha seleccionada.
- Los textos de estado vacio deben explicar la situacion sin repetir mensajes
  genericos en todas las secciones.

**RF-054. Diagnostico de conflictos y validaciones complejas**
Prioridad: Alta. Estado: Sugerido.
Cuando una validacion depende de datos existentes, el sistema debe ayudar al
usuario a entender la causa del problema y la forma de corregirlo.

Criterios de aceptacion:

- Un conflicto de clase indica con que clase o rango horario se cruza, cuando la
  informacion este disponible.
- Un evento superpuesto indica el evento o rango con el que se cruza, cuando la
  informacion este disponible.
- Los errores de rango horario se muestran cerca de la seccion de fecha y hora,
  no solo como `SnackBar`.
- Los mensajes deben estar redactados en lenguaje de usuario y sugerir una
  accion correctiva.

**RF-055. Ayuda contextual para operaciones sensibles**
Prioridad: Baja. Estado: Sugerido.
El sistema debe incluir ayuda contextual breve en operaciones que puedan afectar
datos, permisos o configuracion dificil de recuperar.

Criterios de aceptacion:

- La importacion de respaldo explica si reemplaza, fusiona o valida antes de
  modificar datos existentes.
- El borrado total explica el alcance de datos afectados antes de confirmar.
- El estado de notificaciones nativas explica si faltan permisos o si el
  scheduler esta funcionando en modo limitado.
- La ayuda contextual debe ser breve y estar integrada en la pantalla o dialogo
  correspondiente.

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
