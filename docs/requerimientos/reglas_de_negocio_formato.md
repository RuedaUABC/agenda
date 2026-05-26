# Reglas de Negocio en Formato Estructurado

Este documento reestructura las reglas de negocio de Agenda con una adaptacion
del formato:

`Actor responsable / Accion regulada / Objeto de accion / Condicion o datos / Resultado esperado`

Las reglas de negocio no describen siempre una accion iniciada por el usuario;
por eso el actor responsable suele ser el sistema. El objetivo es que cada regla
sea correcta, completa, consistente, no ambigua, verificable, trazable,
modificable, concisa y entendible.

## Tabla de Reglas de Negocio

| ID | Area | Actor responsable | Accion regulada | Objeto de accion | Condicion o datos | Resultado esperado | Verificacion |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RN-001 | Tareas | Sistema | Validar | Titulo de tarea | Titulo vacio o solo espacios | La tarea no se guarda. | Intentar guardar tarea sin titulo valido. |
| RN-002 | Tareas | Sistema | Validar | Fecha y hora de tarea | Fecha u hora ausente | La tarea no se guarda. | Intentar guardar tarea sin fecha u hora. |
| RN-003 | Tareas | Sistema | Normalizar | Texto de tarea | Titulo, asignatura o descripcion con espacios externos | El sistema elimina espacios innecesarios antes de validar o guardar. | Guardar tarea con espacios externos. |
| RN-004 | Tareas | Sistema | Limitar | Campos de tarea | Titulo, asignatura o descripcion excesivos | El sistema aplica longitud maxima definida. | Intentar guardar textos mayores al limite. |
| RN-005 | Tareas | Sistema | Advertir | Tarea en el pasado | Fecha y hora anteriores al momento actual | El sistema advierte o solicita confirmacion antes de guardar. | Crear o editar tarea pasada. |
| RN-006 | Tareas | Sistema | Asignar | Identificador de tarea | Nueva tarea o tarea persistida | Cada tarea conserva identificador unico. | Crear varias tareas y comparar IDs. |
| RN-007 | Tareas | Sistema | Eliminar logicamente | Tarea activa | Usuario elimina desde listas activas | La tarea pasa a papelera sin borrarse definitivamente. | Eliminar tarea activa y consultar papelera. |
| RN-008 | Tareas | Sistema | Filtrar | Papelera de tareas | Tareas eliminadas y activas | La papelera contiene solo tareas eliminadas. | Abrir papelera con datos mixtos. |
| RN-009 | Tareas | Sistema | Filtrar | Listas principales | Tareas activas y eliminadas | Las listas principales contienen solo tareas no eliminadas. | Consultar tareas activas. |
| RN-010 | Tareas | Sistema | Restaurar | Tarea eliminada | Usuario restaura desde papelera | La tarea vuelve a activa con datos originales. | Restaurar tarea. |
| RN-011 | Tareas | Sistema | Eliminar definitivamente | Tarea en papelera | Confirmacion explicita del usuario | La tarea se borra permanentemente solo desde papelera. | Confirmar borrado definitivo. |
| RN-012 | Tareas | Sistema | Clasificar | Tarea vencida | Tarea activa, no completada y con fecha anterior al dia actual | La tarea se clasifica como vencida. | Cargar tarea antigua pendiente. |
| RN-013 | Tareas | Sistema | Clasificar | Tarea de la semana | Tarea activa, no completada, dentro de proximos siete dias y no vencida | La tarea se clasifica como pendiente de la semana. | Cargar tarea dentro del rango semanal. |
| RN-014 | Tareas | Sistema | Clasificar | Tarea proxima | Tarea activa, no completada y a siete dias o mas | La tarea se clasifica como proxima. | Cargar tarea futura lejana. |
| RN-015 | Tareas | Sistema | Clasificar | Tarea completada | Tarea marcada como completada | La tarea se clasifica como completada sin importar fecha. | Completar tarea con cualquier fecha. |
| RN-016 | Tareas | Sistema | Priorizar | Clasificacion de tarea | Tarea completada que tambien coincide con otra categoria | La categoria completadas tiene prioridad. | Completar tarea vencida. |
| RN-017 | Tareas | Sistema | Calcular | Progreso diario | Tareas de hoy completadas y total de tareas de hoy | El progreso es completadas dividido entre total. | Comparar resultado con conteo de tareas. |
| RN-018 | Tareas | Sistema | Calcular | Progreso diario sin tareas | No hay tareas para hoy | El progreso diario es 0%. | Consultar progreso sin tareas del dia. |
| RN-019 | Tareas | Sistema | Calcular | Estadisticas semanales | Siete dias desde hoy, excluyendo completadas y eliminadas | El conteo semanal solo incluye pendientes activas. | Cargar tareas con estados distintos. |
| RN-020 | Horario | Sistema | Validar | Materia de clase | Materia vacia o solo espacios | La clase no se guarda. | Intentar guardar clase sin materia. |
| RN-021 | Horario | Sistema | Validar | Dia o fecha de clase | Dia o fecha base ausente | La clase no se guarda. | Intentar guardar clase sin fecha o dia. |
| RN-022 | Horario | Sistema | Validar | Hora de inicio | Inicio ausente | La clase no se guarda. | Intentar guardar sin inicio. |
| RN-023 | Horario | Sistema | Validar | Hora de fin | Fin ausente | La clase no se guarda. | Intentar guardar sin fin. |
| RN-024 | Horario | Sistema | Validar | Rango horario de clase | Hora de fin no posterior al inicio | La clase no se guarda. | Probar rango invalido. |
| RN-025 | Horario | Sistema | Ajustar | Hora de fin | Inicio cambia y deja fin no posterior | El sistema puede mover fin a una hora despues del inicio. | Cambiar inicio en formulario. |
| RN-026 | Horario | Sistema | Normalizar | Texto de clase | Materia o aula con espacios externos | El sistema elimina espacios innecesarios antes de validar o guardar. | Guardar clase con espacios externos. |
| RN-027 | Horario | Sistema | Limitar | Campos de clase | Materia o aula excesivos | El sistema aplica longitud maxima definida. | Intentar guardar textos mayores al limite. |
| RN-028 | Horario | Sistema | Impedir | Solapamiento de clases | Clase nueva o editada intersecta otra del mismo dia | La clase no se guarda; se permite fin igual al inicio de otra. | Crear clase solapada y clase contigua. |
| RN-029 | Horario | Sistema | Definir | Tipo de clase | Clase creada desde formulario | La clase se crea como semanal por defecto. | Crear clase y revisar recurrencia. |
| RN-030 | Horario | Sistema | Generar | Regla semanal | Clase semanal con dia asociado | La regla usa frecuencia semanal, intervalo uno y dia asociado. | Revisar RRULE generada. |
| RN-031 | Horario | Sistema | Mapear | Dias de semana | Conversion entre fecha y RRULE | El mapeo es consistente entre modelos. | Probar dias lunes a domingo. |
| RN-032 | Horario | Sistema | Rechazar | Dia invalido | Valor fuera de lunes a domingo | El sistema rechaza el valor invalido. | Probar dia fuera de rango. |
| RN-033 | Horario | Sistema | Normalizar | Recurrencia antigua | Regla semanal sin dia de semana | El sistema infiere dia desde fecha de inicio cuando sea posible. | Cargar regla semanal incompleta. |
| RN-034 | Horario | Sistema | Conservar | Reglas no semanales | Regla nula, vacia o no semanal | El sistema no modifica la regla automaticamente. | Cargar reglas no semanales. |
| RN-035 | Horario | Sistema | Asignar | Color de clase | Clase sin color definido | El sistema asigna color por defecto. | Guardar clase sin color. |
| RN-036 | Calendario | Sistema | Validar | Titulo de evento | Titulo vacio o solo espacios | El evento no se guarda. | Intentar guardar evento sin titulo. |
| RN-037 | Calendario | Sistema | Validar | Inicio de evento | Fecha u hora de inicio ausente | El evento no se guarda. | Intentar guardar sin inicio. |
| RN-038 | Calendario | Sistema | Validar | Fin de evento | Fecha u hora de fin ausente | El evento no se guarda. | Intentar guardar sin fin. |
| RN-039 | Calendario | Sistema | Validar | Rango de evento | Fin anterior al inicio | El evento no se guarda. | Probar rango invertido. |
| RN-040 | Calendario | Sistema | Resolver | Evento de duracion cero | Inicio y fin iguales | El sistema lo trata como puntual o lo rechaza segun politica definida. | Probar inicio igual a fin. |
| RN-041 | Calendario | Sistema | Normalizar | Texto de evento | Titulo o descripcion con espacios externos | El sistema elimina espacios innecesarios antes de validar o guardar. | Guardar evento con espacios externos. |
| RN-042 | Calendario | Sistema | Limitar | Campos de evento | Titulo o descripcion excesivos | El sistema aplica longitud maxima definida. | Intentar guardar textos mayores al limite. |
| RN-043 | Calendario | Sistema | Incluir | Evento por dia | Dia seleccionado coincide con inicio, fin o rango intermedio | El evento pertenece a ese dia. | Consultar eventos por fecha. |
| RN-044 | Calendario | Sistema | Mostrar | Evento de varios dias | Evento inicia en un dia y termina en otro | El evento aparece en cada dia incluido en el rango. | Consultar dia intermedio. |
| RN-045 | Calendario | Sistema | Asignar | Color de evento | Evento sin color definido | El sistema asigna color por defecto. | Guardar evento sin color. |
| RN-046 | Calendario | Sistema | Detectar | Superposicion de eventos | Evento nuevo o editado se superpone con otro | El sistema advierte o impide guardado segun politica. | Crear evento superpuesto. |
| RN-047 | Configuracion | Sistema | Definir | Aviso por defecto de clase | No hay preferencia guardada | El aviso global de clases es 15 minutos. | Cargar preferencias vacias. |
| RN-048 | Configuracion | Sistema | Definir | Avisos por defecto de tarea | No hay preferencias guardadas | Los avisos globales de tareas son 60 minutos y 1 dia antes. | Cargar preferencias vacias. |
| RN-049 | Configuracion | Sistema | Restringir | Anticipaciones de notificacion | Usuario o persistencia entrega una opcion | Solo se aceptan opciones permitidas por la aplicacion. | Probar opciones no soportadas. |
| RN-050 | Configuracion | Sistema | Rechazar | Anticipaciones invalidas | Valor nulo, negativo o no soportado | El sistema rechaza el valor. | Intentar guardar valor invalido. |
| RN-051 | Configuracion | Sistema | Conservar | Avisos de tarea | Usuario modifica primer aviso | El sistema conserva otros avisos configurados si existen. | Cambiar primer aviso con lista previa. |
| RN-052 | Configuracion | Sistema | Reprogramar | Tareas pendientes | Cambian avisos de tarea | Solo se reprograman tareas no completadas y no eliminadas. | Cambiar avisos con tareas mixtas. |
| RN-053 | Configuracion | Sistema | Programar y cancelar | Avisos nativos integrados | Cambios en preferencias o entidades con aviso | El scheduler programa, cancela y reprograma sin acoplar la UI al plugin. | Revisar pruebas de scheduler. |
| RN-054 | Persistencia | Sistema | Guardar | Entidades principales | Tareas, clases y eventos | Las entidades se guardan localmente. | Crear entidades y consultar persistencia. |
| RN-055 | Persistencia | Sistema | Serializar | Fechas persistidas | Fecha de entidad guardada | La fecha se almacena como texto ISO 8601. | Revisar mapa persistido. |
| RN-056 | Persistencia | Sistema | Serializar | Booleanos persistidos | Valor booleano de modelo | El valor se almacena como `1` o `0`. | Revisar mapa persistido. |
| RN-057 | Persistencia | Sistema | Reemplazar controladamente | Entidad con ID existente | Guardado con identificador existente | El registro anterior se reemplaza conservando integridad de la entidad. | Guardar entidad con mismo ID. |
| RN-058 | Persistencia | Sistema | Migrar | Base de datos | Cambio de esquema | El sistema migra sin perder datos existentes. | Ejecutar prueba de migracion. |
| RN-059 | Persistencia | Proyecto | Registrar | Version de base actual | Cambio de esquema o version | La version queda documentada y actualizada. | Revisar documentacion tecnica. |
| RN-060 | Tareas | Sistema | Impedir | Duplicidad de tarea | Titulo, asignatura, descripcion, fecha y hora normalizados coinciden con otra tarea | La tarea no se registra dos veces; al editar se excluye el mismo ID. | Crear o editar tarea duplicada. |
| RN-061 | Experiencia | Sistema | Ofrecer recuperacion | Accion reversible | La accion puede revertirse sin perder integridad | El usuario ve una forma inmediata de recuperar el estado anterior. | Ejecutar accion reversible. |
| RN-062 | Seguridad operacional | Sistema | Exigir confirmacion reforzada | Borrado masivo local | Usuario solicita borrar todos los datos | El sistema explicita alcance y exige accion deliberada adicional. | Intentar borrar todos los datos. |
| RN-063 | Experiencia | Sistema | Diagnosticar | Conflicto de agenda | Clase o evento no puede guardarse o requiere confirmacion por conflicto | El sistema identifica el conflicto de forma comprensible si hay datos disponibles. | Provocar conflicto horario. |
| RN-064 | Experiencia | Sistema | Asegurar legibilidad | Mensajes criticos | Confirmacion, error, exito o advertencia | El mensaje no contiene caracteres corruptos ni oculta consecuencias. | Revisar mensajes criticos en UI. |

## Validacion de Calidad del Formato

| Atributo | Aplicacion en reglas de negocio |
| --- | --- |
| Correcto / necesario | Cada regla controla una restriccion de dominio, persistencia, agenda o experiencia critica. |
| Completo | Cada fila incluye condicion y resultado esperado. |
| Consistente | Las areas y entidades usan los mismos nombres que los requerimientos. |
| No ambiguo | Las condiciones indican cuando aplica la regla. |
| Verificable | Cada regla propone una comprobacion objetiva. |
| Trazable | Cada regla conserva identificador unico RN. |
| Modificable | Las reglas quedan aisladas por fila y area. |
| Conciso y entendible | La redaccion separa accion, objeto, condicion y resultado. |
