# Reglas de Negocio

Este documento define reglas que gobiernan el comportamiento de Agenda. Las
reglas deben mantenerse independientes de la tecnologia usada para
implementarlas.

Version tabular con actor responsable, accion regulada, objeto, condicion,
resultado esperado y verificacion:
[`reglas_de_negocio_formato.md`](reglas_de_negocio_formato.md).

## Tareas

**RN-001. Titulo obligatorio de tarea**  
Una tarea no puede guardarse si el titulo esta vacio o contiene solo espacios.

**RN-002. Fecha y hora obligatorias de tarea**  
Una tarea no puede guardarse si no tiene fecha y hora definidas.

**RN-003. Normalizacion de texto de tarea**  
Antes de validar o guardar una tarea, el sistema debe eliminar espacios
innecesarios al inicio y al final de titulo, asignatura y descripcion.

**RN-004. Longitud maxima de campos de tarea**  
El sistema debe definir y aplicar una longitud maxima para titulo, asignatura y
descripcion para evitar datos excesivos o problemas de interfaz.

**RN-005. Advertencia para tareas en el pasado**  
Si el usuario intenta crear o editar una tarea con fecha y hora anterior al
momento actual, el sistema debe advertirlo o solicitar confirmacion antes de
guardar.

**RN-006. Identificador unico de tarea**  
Cada tarea debe tener un identificador unico que permita actualizarla,
eliminarla o restaurarla sin afectar otras tareas.

**RN-060. Tarea duplicada no permitida**
Una tarea no puede registrarse dos veces con datos identicos. Para determinar
duplicidad se comparan titulo, asignatura, descripcion, fecha y hora despues de
normalizar textos, sin considerar el identificador tecnico. Al editar una
tarea, solo se permite coincidir con el registro que conserva el mismo
identificador.

**RN-007. Eliminacion logica de tarea**  
Eliminar una tarea desde las listas activas cambia su estado a eliminada y la
envia a papelera; no debe borrar el registro de forma definitiva.

**RN-008. Papelera de tareas**  
La papelera contiene exclusivamente tareas marcadas como eliminadas.

**RN-009. Tareas activas**  
Las listas principales contienen exclusivamente tareas no eliminadas.

**RN-010. Restauracion de tarea**  
Restaurar una tarea cambia su estado de eliminada a activa y conserva sus
datos originales.

**RN-011. Eliminacion definitiva**  
Una tarea solo puede eliminarse definitivamente desde papelera y despues de una
confirmacion explicita del usuario.

**RN-012. Tareas vencidas**  
Una tarea activa y no completada es vencida si su fecha es anterior al dia
actual.

**RN-013. Tareas pendientes de la semana**  
Una tarea activa y no completada pertenece a pendientes de la semana si su
fecha esta dentro de los proximos siete dias y no esta vencida.

**RN-014. Tareas proximas**  
Una tarea activa y no completada es proxima si su fecha esta a siete dias o mas
desde el dia actual.

**RN-015. Tareas completadas**  
Una tarea completada se clasifica como completada sin importar su fecha.

**RN-016. Prioridad de clasificacion**  
La categoria completadas tiene prioridad sobre vencidas, pendientes de la
semana y proximas.

**RN-017. Progreso diario**  
El progreso diario se calcula como tareas de hoy completadas dividido entre el
total de tareas de hoy.

**RN-018. Progreso diario sin tareas**  
Si no hay tareas para hoy, el progreso diario debe ser 0%.

**RN-019. Estadisticas semanales**  
Las estadisticas semanales consideran siete dias desde el dia actual y excluyen
tareas completadas y eliminadas.

## Horario

**RN-020. Materia obligatoria**  
Una clase no puede guardarse si la materia esta vacia o contiene solo espacios.

**RN-021. Fecha o dia obligatorio de clase**  
Una clase debe tener un dia o fecha base que determine su aparicion semanal.

**RN-022. Hora de inicio obligatoria**  
Una clase no puede guardarse sin hora de inicio.

**RN-023. Hora de fin obligatoria**  
Una clase no puede guardarse sin hora de fin.

**RN-024. Fin posterior al inicio**  
La hora de fin de una clase debe ser posterior a la hora de inicio.

**RN-025. Ajuste automatico de hora de fin**  
Si al cambiar la hora de inicio la hora de fin deja de ser posterior, el
sistema puede ajustar automaticamente la hora de fin a una hora despues del
inicio.

**RN-026. Normalizacion de texto de clase**  
Antes de validar o guardar una clase, el sistema debe eliminar espacios
innecesarios al inicio y al final de materia y aula.

**RN-027. Longitud maxima de campos de clase**  
El sistema debe definir y aplicar una longitud maxima para materia y aula.

**RN-028. Clases sin solapamiento**
Una clase nueva o editada no puede solaparse con otra clase del mismo dia. Dos
clases se consideran solapadas cuando sus rangos horarios se intersectan de
forma parcial o total; se permite que una clase termine exactamente a la misma
hora en que otra inicia.

**RN-029. Clase semanal por defecto**  
Las clases creadas desde el formulario son semanales.

**RN-030. Regla de recurrencia semanal**  
Una clase semanal debe usar una regla de recurrencia con frecuencia semanal,
intervalo de una semana y dia asociado.

**RN-031. Mapeo de dias de semana**  
Los dias de semana deben mapearse consistentemente entre el modelo de fecha y
la regla de recurrencia.

**RN-032. Dia de semana invalido**  
Un valor de dia fuera del rango lunes a domingo debe rechazarse.

**RN-033. Normalizacion de recurrencia antigua**  
Si una regla semanal existente no contiene dia de semana, el sistema debe
inferirlo desde la fecha de inicio cuando sea posible.

**RN-034. Conservacion de reglas no semanales**  
Las reglas nulas, vacias o no semanales no deben modificarse automaticamente.

**RN-035. Color por defecto de clase**  
Si una clase no tiene color definido, el sistema debe asignar un color por
defecto.

## Calendario y Eventos

**RN-036. Titulo obligatorio de evento**  
Un evento no puede guardarse si el titulo esta vacio o contiene solo espacios.

**RN-037. Inicio obligatorio de evento**  
Un evento debe tener fecha y hora de inicio.

**RN-038. Fin obligatorio de evento**  
Un evento debe tener fecha y hora de fin.

**RN-039. Fin no anterior al inicio**  
La fecha y hora de fin de un evento no pueden ser anteriores a la fecha y hora
de inicio.

**RN-040. Eventos de duracion cero**  
Si el inicio y el fin de un evento son iguales, el sistema debe tratarlo como
evento puntual o rechazarlo segun la politica definida.

**RN-041. Normalizacion de texto de evento**  
Antes de validar o guardar un evento, el sistema debe eliminar espacios
innecesarios al inicio y al final de titulo y descripcion.

**RN-042. Longitud maxima de campos de evento**  
El sistema debe definir y aplicar una longitud maxima para titulo y descripcion.

**RN-043. Evento incluido por rango de fechas**  
Un evento pertenece a un dia si el dia seleccionado coincide con su inicio,
coincide con su fin o cae entre ambos.

**RN-044. Evento de varios dias**  
Un evento que empieza en un dia y termina en otro debe aparecer en cada dia
incluido dentro de su rango.

**RN-045. Color por defecto de evento**  
Si un evento no tiene color definido, el sistema debe asignar un color por
defecto.

**RN-046. Superposicion de eventos**  
Si un evento nuevo o editado se superpone con otro evento, el sistema debe
advertir al usuario o impedir el guardado segun la politica definida.

## Configuracion y Notificaciones

**RN-047. Aviso por defecto de clase**  
Si no hay preferencia guardada, el aviso global de clases es de 15 minutos.

**RN-048. Avisos por defecto de tarea**  
Si no hay preferencias guardadas, los avisos globales de tareas son 60 minutos
y 1 dia antes.

**RN-049. Opciones permitidas de anticipacion**  
Las preferencias de notificacion solo pueden usar opciones permitidas por la
aplicacion.

**RN-050. Rechazo de anticipaciones invalidas**  
El sistema debe rechazar valores de anticipacion nulos, negativos o no
soportados.

**RN-051. Actualizacion del primer aviso de tarea**  
Cuando el usuario modifica el primer aviso de tareas, el sistema debe conservar
los demas avisos configurados si existen.

**RN-052. Reprogramacion de tareas pendientes**  
Cuando se actualizan avisos de tarea, solo deben reprogramarse tareas no
completadas y no eliminadas.

**RN-053. Notificaciones nativas integradas**
Los avisos integrados con scheduler nativo deben poder programarse, cancelarse
y reprogramarse desde preferencias sin acoplar la UI al plugin de plataforma.

## Experiencia, Recuperacion y Seguridad Operacional

**RN-061. Acciones reversibles con recuperacion**
Cuando una accion de usuario pueda revertirse sin perder integridad de datos,
el sistema debe ofrecer una forma visible de recuperacion inmediata. La
recuperacion debe restaurar el estado anterior sin crear duplicados ni afectar
otras entidades.

**RN-062. Confirmacion reforzada para borrado masivo**
El borrado total de datos locales requiere una confirmacion reforzada e
independiente de la preferencia general de confirmaciones. La confirmacion debe
hacer explicito el alcance de datos afectados y exigir una accion deliberada
adicional antes de ejecutar el borrado.

**RN-063. Diagnostico de conflictos de agenda**
Cuando una clase o evento no pueda guardarse, o requiera confirmacion, por
conflicto de horario, el sistema debe identificar el conflicto de forma
comprensible para el usuario siempre que los datos necesarios esten
disponibles.

**RN-064. Calidad textual de mensajes criticos**
Los mensajes de confirmacion, error, exito y advertencia deben mostrarse con
texto legible y codificacion correcta. Un mensaje critico no debe contener
caracteres corruptos, terminos ambiguos ni redaccion que oculte la consecuencia
de la accion.

## Persistencia

**RN-054. Persistencia local de entidades principales**  
Tareas, clases y eventos deben guardarse localmente.

**RN-055. Fechas serializadas como ISO**  
Las fechas persistidas deben almacenarse como texto ISO 8601.

**RN-056. Booleanos como enteros**  
Los valores booleanos persistidos en SQLite deben almacenarse como `1` o `0`.

**RN-057. Insercion con reemplazo controlado**  
Cuando se guarde una entidad con identificador existente, el sistema puede
reemplazar el registro anterior siempre que conserve la integridad de la
entidad.

**RN-058. Migraciones de base de datos**  
Cuando cambie el esquema de datos, el sistema debe migrar sin perder datos
existentes.

**RN-059. Version de base actual**  
La version actual de la base de datos debe registrarse en la documentacion
tecnica y actualizarse cuando cambie el esquema.
