# Reglas de Negocio

## Tareas

**RN-001. Titulo obligatorio de tarea**  
Una tarea no puede guardarse desde el formulario si el titulo esta vacio.

**RN-002. Fecha y hora obligatorias de tarea**  
Una tarea solo se guarda si existe fecha y hora seleccionada.

**RN-003. Identificador de tarea generado por tiempo**  
Cuando se crea una tarea nueva, el id se genera con
`DateTime.now().millisecondsSinceEpoch.toString()`.

**RN-004. Eliminacion logica**  
Eliminar una tarea cambia `eliminada` a `true`; no borra la fila de SQLite.

**RN-005. Papelera**  
La papelera contiene tareas con `eliminada = true`.

**RN-006. Tareas activas**  
Las listas principales muestran tareas con `eliminada = false`.

**RN-007. Tareas vencidas**  
Una tarea no completada es vencida si su fecha es anterior al dia actual.

**RN-008. Tareas pendientes de la semana**  
Una tarea no completada pertenece a pendientes de la semana si su fecha es
menor a siete dias desde hoy y no esta vencida.

**RN-009. Tareas proximas**  
Una tarea no completada es proxima si su fecha esta a siete dias o mas desde
hoy.

**RN-010. Tareas completadas**  
Una tarea completada se clasifica como completada sin importar su fecha.

**RN-011. Progreso diario**  
El progreso diario es `tareas completadas de hoy / total de tareas de hoy`. Si
no hay tareas hoy, el progreso es `0.0`.

**RN-012. Estadisticas semanales**  
Las estadisticas semanales consideran siete dias desde hoy y excluyen tareas
completadas.

## Horario

**RN-013. Materia obligatoria**  
Una clase no puede guardarse si la materia esta vacia.

**RN-014. Fin posterior al inicio**  
La hora de fin de una clase debe ser posterior a la hora de inicio.

**RN-015. Ajuste automatico de hora de fin**  
Si al cambiar la hora de inicio la hora de fin deja de ser posterior, el
sistema ajusta el fin a una hora despues del inicio.

**RN-016. Clase semanal por defecto**  
Las clases creadas desde el formulario son semanales y usan regla RRULE con
`FREQ=WEEKLY;INTERVAL=1;BYDAY=...`.

**RN-017. Mapeo de dias RRULE**  
Los dias de Dart se mapean a `MO`, `TU`, `WE`, `TH`, `FR`, `SA`, `SU`.

**RN-018. Rechazo de dia invalido**  
Un valor de dia fuera del rango de `DateTime.monday` a `DateTime.sunday` debe
lanzar `ArgumentError`.

**RN-019. Normalizacion de recurrencia semanal antigua**  
Si una regla semanal no contiene `BYDAY`, el sistema agrega el dia segun la
fecha de inicio.

**RN-020. Conservacion de reglas no semanales**  
Las reglas nulas, vacias o no semanales no se modifican.

## Calendario

**RN-021. Evento incluido por rango de fechas**  
Un evento pertenece a un dia si el dia seleccionado coincide con su inicio,
coincide con su fin o cae entre ambos.

**RN-022. Color por defecto de evento**  
Si un evento no trae color, se usa `0xFFF44336`.

**RN-023. Color por defecto de clase**  
Si una clase no trae color, se usa `0xFF2196F3`.

## Configuracion

**RN-024. Aviso por defecto de clase**  
Si no hay preferencia guardada, el aviso global de clases es de 15 minutos.

**RN-025. Avisos por defecto de tarea**  
Si no hay preferencias guardadas, los avisos globales de tareas son 60 minutos
y 1 dia antes.

**RN-026. Opciones permitidas de notificacion**  
La UI ofrece 5, 10, 15, 30, 60, 120 y 1440 minutos.

**RN-027. Actualizacion del primer aviso de tarea**  
La pantalla de configuracion modifica el primer aviso de tareas y conserva el
resto de la lista si existe.

**RN-028. Reprogramacion solo de tareas pendientes**  
Cuando se actualizan avisos de tarea, solo se reprograman tareas no
completadas.

## Persistencia

**RN-029. Fechas serializadas como ISO**  
Tareas, clases y eventos guardan fechas como texto ISO.

**RN-030. Booleanos de tareas como enteros**  
`completada` y `eliminada` se guardan como `1` o `0`.

**RN-031. Insercion con reemplazo**  
La insercion de tareas, clases y eventos usa `ConflictAlgorithm.replace`.

**RN-032. Version de base actual**  
La version de base de datos actual es `3`.
