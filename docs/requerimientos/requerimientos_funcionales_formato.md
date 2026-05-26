# Requerimientos Funcionales en Formato Estructurado

Este documento reestructura los requerimientos funcionales de Agenda con el
patron:

`Actor / Accion / Objeto de accion / Datos de entrada / Resultado esperado`

El formato se basa en los atributos de calidad revisados en la presentacion de
referencia: correcto, completo, consistente, no ambiguo, verificable,
necesario, prioritario, factible, trazable, modificable, conciso y entendible.

## Criterio de Redaccion

- Actor: usuario o sistema que ejecuta o dispara la funcionalidad.
- Accion: verbo principal observable.
- Objeto de accion: entidad o componente afectado.
- Datos de entrada: informacion necesaria para iniciar la funcionalidad.
- Resultado esperado: salida visible, cambio de estado o persistencia
  verificable.
- Prioridad: Alta, Media o Baja.
- Estado: Implementado, Parcial, Pendiente o Sugerido.
- Verificacion: forma objetiva de comprobar el cumplimiento.

## Tabla de Requerimientos Funcionales

| ID | Actor | Accion | Objeto de accion | Datos de entrada | Resultado esperado | Prioridad | Estado | Verificacion |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| RF-001 | Usuario | Navegar | Modulos principales | Seleccion de Tareas, Horario, Calendario o Ajustes | El sistema muestra el modulo seleccionado y conserva disponible la navegacion principal. | Alta | Implementado | Cambiar entre modulos y verificar opcion activa. |
| RF-002 | Sistema | Conservar | Estado de modulos | Cambio de modulo y retorno posterior | El sistema mantiene fechas seleccionadas y listas ya cargadas. | Media | Implementado | Navegar fuera y volver al modulo. |
| RF-003 | Usuario | Consultar | Tareas activas | Apertura del modulo Tareas | El sistema muestra solo tareas no enviadas a papelera o un estado vacio. | Alta | Implementado | Cargar tareas activas. |
| RF-004 | Usuario | Consultar | Papelera de tareas | Apertura de la vista Papelera | El sistema muestra solo tareas eliminadas logicamente o un estado vacio. | Media | Implementado | Abrir papelera con y sin tareas eliminadas. |
| RF-005 | Usuario | Crear | Tarea | Titulo, asignatura, descripcion, fecha y hora | El sistema guarda la tarea localmente y la muestra en la categoria correspondiente. | Alta | Implementado | Guardar una tarea valida. |
| RF-006 | Sistema | Validar | Datos de tarea | Titulo, fecha, hora, asignatura, descripcion y tareas existentes | El sistema impide datos invalidos o duplicados y solicita confirmacion para fechas pasadas. | Alta | Implementado | Intentar guardar datos invalidos, fecha pasada y duplicado exacto. |
| RF-007 | Usuario | Editar | Tarea existente | Identificador de tarea y datos actualizados | El sistema actualiza la tarea si los datos son validos y no duplican otra tarea. | Alta | Implementado | Editar una tarea y verificar lista actualizada. |
| RF-008 | Usuario | Cambiar estado | Tarea | Tarea pendiente o completada seleccionada | El sistema alterna entre completada y pendiente y conserva el cambio. | Alta | Implementado | Marcar y devolver tarea. |
| RF-009 | Usuario | Eliminar logicamente | Tarea activa | Tarea seleccionada y confirmacion cuando aplique | El sistema envia la tarea a papelera sin borrarla definitivamente. | Alta | Implementado | Eliminar tarea y revisar papelera. |
| RF-010 | Usuario | Restaurar | Tarea en papelera | Tarea eliminada seleccionada | El sistema devuelve la tarea a listas activas con sus datos originales. | Media | Implementado | Restaurar desde papelera. |
| RF-011 | Usuario | Eliminar definitivamente | Tarea en papelera | Tarea seleccionada y confirmacion explicita | El sistema borra la tarea de forma permanente. | Baja | Implementado | Confirmar eliminacion definitiva. |
| RF-012 | Sistema | Clasificar | Tareas activas | Fecha, estado completado y estado eliminado de cada tarea | El sistema agrupa tareas en vencidas, semana, proximas y completadas. | Alta | Implementado | Cargar tareas con fechas distintas. |
| RF-013 | Sistema | Calcular | Progreso diario | Tareas del dia y estado completado | El sistema muestra porcentaje de tareas de hoy completadas. | Media | Implementado | Comparar completadas contra total del dia. |
| RF-014 | Sistema | Calcular | Estadisticas semanales | Tareas pendientes de los proximos siete dias | El sistema muestra conteo de tareas pendientes por dia. | Media | Implementado | Consultar estadisticas con tareas futuras. |
| RF-015 | Usuario | Consultar | Detalle de tarea | Tarea seleccionada | El sistema muestra titulo, asignatura, descripcion, fecha, hora y estado. | Media | Implementado | Abrir detalle de tarea. |
| RF-016 | Usuario | Filtrar | Lista de tareas | Estado seleccionado en filtro | El sistema muestra tareas segun el estado elegido. | Baja | Implementado | Aplicar filtro visible. |
| RF-017 | Usuario | Consultar | Clases guardadas | Apertura del modulo Horario | El sistema carga y muestra las clases locales. | Alta | Implementado | Abrir Horario con clases guardadas. |
| RF-018 | Usuario | Crear | Clase semanal | Materia, aula, fecha, hora de inicio, hora de fin y color | El sistema guarda la clase y la muestra en el horario semanal. | Alta | Implementado | Guardar clase valida. |
| RF-019 | Sistema | Validar | Datos de clase | Materia, fecha o dia, inicio, fin, aula y clases existentes | El sistema impide datos invalidos y clases solapadas del mismo dia. | Alta | Implementado | Intentar guardar clase invalida o solapada. |
| RF-020 | Sistema | Registrar | Recurrencia semanal | Dia seleccionado y datos de clase | El sistema genera regla semanal asociada al dia correspondiente. | Alta | Implementado | Crear clase y revisar recurrencia. |
| RF-021 | Usuario | Visualizar | Horario semanal | Apertura de Horario y fecha seleccionada | El sistema muestra vista semanal adaptada a mobile o desktop. | Alta | Implementado | Renderizar horario por ancho de pantalla. |
| RF-022 | Usuario | Listar | Clases del dia | Dia seleccionado | El sistema muestra contador, metadatos y estado vacio cuando no hay clases. | Media | Implementado | Seleccionar dia con y sin clases. |
| RF-023 | Usuario | Editar | Clase existente | Clase seleccionada y datos actualizados | El sistema modifica la clase si cumple las validaciones de creacion. | Media | Implementado | Actualizar clase y revisar horario. |
| RF-024 | Usuario | Eliminar | Clase existente | Clase seleccionada y confirmacion cuando aplique | El sistema elimina la clase y actualiza el horario. | Media | Implementado | Eliminar clase visible. |
| RF-025 | Usuario | Consultar | Eventos guardados | Apertura del modulo Calendario | El sistema carga eventos locales. | Alta | Implementado | Abrir Calendario con eventos guardados. |
| RF-026 | Usuario | Visualizar | Calendario mensual | Fecha seleccionada y eventos cargados | El sistema muestra eventos en vista mensual adaptada a mobile o desktop. | Alta | Implementado | Renderizar vista mensual. |
| RF-027 | Usuario | Seleccionar | Fecha de calendario | Fecha elegida por el usuario | El sistema conserva la fecha seleccionada mientras el modulo permanece activo. | Media | Implementado | Cambiar fecha y revisar lista diaria. |
| RF-028 | Usuario | Listar | Eventos del dia | Dia seleccionado | El sistema muestra eventos que ocurren en ese dia, incluidos eventos de varios dias. | Alta | Implementado | Seleccionar fecha intermedia de evento largo. |
| RF-029 | Sistema | Representar | Evento | Titulo, descripcion, rango horario y color | El sistema muestra el evento con informacion y color asociados. | Media | Implementado | Revisar tarjeta o appointment de evento. |
| RF-030 | Usuario | Crear | Evento | Titulo, descripcion, inicio, fin y color | El sistema valida y guarda el evento desde Calendario. | Alta | Implementado | Crear evento desde la interfaz. |
| RF-031 | Usuario | Editar | Evento existente | Evento seleccionado y datos actualizados | El sistema conserva el identificador y refleja los cambios. | Alta | Implementado | Editar evento visible. |
| RF-032 | Usuario | Eliminar | Evento existente | Evento seleccionado y confirmacion | El sistema elimina el evento y actualiza Calendario. | Media | Implementado | Confirmar eliminacion de evento. |
| RF-033 | Sistema | Advertir | Superposicion de evento | Evento candidato y eventos existentes | El sistema muestra advertencia y permite cancelar o continuar segun politica. | Baja | Implementado | Crear evento superpuesto. |
| RF-034 | Usuario | Consultar | Preferencias de notificacion | Apertura de Ajustes | El sistema carga preferencias globales de clases y tareas. | Media | Implementado | Abrir Ajustes con preferencias guardadas. |
| RF-035 | Usuario | Configurar | Aviso de clases | Anticipacion seleccionada | El sistema guarda la preferencia de aviso para clases. | Media | Implementado | Cambiar aviso de clases. |
| RF-036 | Usuario | Configurar | Primer aviso de tareas | Anticipacion seleccionada | El sistema guarda la preferencia y conserva la reprogramacion de tareas pendientes. | Media | Implementado | Cambiar primer aviso de tareas. |
| RF-037 | Sistema | Validar | Preferencias de notificacion | Valor de anticipacion recibido | El sistema acepta solo valores permitidos y rechaza nulos, negativos o no soportados. | Media | Implementado | Probar valores invalidos. |
| RF-038 | Sistema | Persistir | Preferencias | Cambios realizados en Ajustes | El sistema guarda preferencias en almacenamiento local. | Media | Implementado | Reabrir Ajustes y verificar valor. |
| RF-039 | Sistema | Reprogramar | Notificaciones de tareas pendientes | Cambio en preferencias de avisos de tareas | El sistema reprograma solo tareas no completadas. | Media | Implementado | Actualizar aviso y revisar scheduler. |
| RF-040 | Sistema | Persistir | Datos principales | Tareas, clases, eventos y preferencias | El sistema conserva datos localmente para uso offline. | Alta | Implementado | Cerrar y reabrir aplicacion o validar DAO. |
| RF-041 | Sistema | Migrar | Base de datos | Esquema local con version anterior | El sistema actualiza el esquema sin perder datos existentes. | Alta | Implementado | Ejecutar prueba de migracion. |
| RF-042 | Sistema | Inicializar | SQLite en escritorio | Ejecucion en Windows o Linux | El sistema habilita SQLite FFI antes de abrir la base. | Alta | Implementado | Ejecutar smoke test de escritorio. |
| RF-043 | Usuario | Configurar | Aviso de eventos | Anticipacion seleccionada, incluidos valores sin recordatorio | El sistema persiste la preferencia y reprograma eventos futuros. | Media | Implementado | Cambiar aviso de eventos. |
| RF-044 | Usuario | Elegir | Tema visual | Opcion sistema, claro u oscuro | El sistema aplica y persiste el tema sin reiniciar. | Media | Implementado | Cambiar tema en Ajustes. |
| RF-045 | Usuario | Elegir | Vista inicial | Modulo inicial seleccionado | El sistema abre el modulo elegido al iniciar la aplicacion. | Baja | Implementado | Reiniciar y verificar modulo activo. |
| RF-046 | Usuario | Elegir | Densidad visual | Opcion comoda o compacta | El sistema aplica densidad a listas de tareas, clases y eventos sin romper objetivos tactiles. | Baja | Implementado | Cambiar densidad y revisar listas. |
| RF-047 | Usuario | Elegir | Inicio de semana | Lunes o domingo | El sistema aplica la preferencia a Calendario y Horario. | Baja | Implementado | Cambiar inicio y revisar vistas. |
| RF-048 | Usuario | Configurar | Confirmaciones destructivas | Preferencia activada o desactivada | El sistema respeta la preferencia en acciones comunes y conserva defensa obligatoria en borrado masivo. | Media | Parcial | Desactivar confirmaciones y probar acciones cubiertas. |
| RF-049 | Usuario | Gestionar | Datos locales | Accion exportar, importar o borrar datos | El sistema exporta, valida importaciones y borra datos solo con confirmacion reforzada verificable. | Baja | Parcial | Ejecutar gestion de datos locales. |
| RF-050 | Usuario | Consultar | Informacion de la aplicacion | Apertura de seccion Acerca de | El sistema muestra version, almacenamiento local y estado de notificaciones. | Baja | Implementado | Abrir seccion informativa. |
| RF-051 | Usuario | Recuperar | Acciones reversibles | Accion reversible recien ejecutada | El sistema muestra `Deshacer` y restaura el estado anterior si el usuario lo solicita. | Alta | Sugerido | Ejecutar accion reversible y usar Deshacer. |
| RF-052 | Sistema | Informar | Carga y guardado | Operacion asincrona en pantalla o formulario | El sistema muestra progreso, deshabilita acciones repetidas y evita doble ejecucion. | Media | Sugerido | Ejecutar operacion lenta o simulada. |
| RF-053 | Sistema | Mostrar | Estados vacios accionables | Modulo o categoria sin datos | El sistema muestra mensaje especifico y accion directa cuando aplique. | Media | Sugerido | Abrir modulo sin elementos. |
| RF-054 | Sistema | Diagnosticar | Validaciones complejas | Datos que causan conflicto o error de rango | El sistema explica la causa y sugiere una correccion cerca del campo afectado. | Alta | Sugerido | Provocar conflicto de clase o evento. |
| RF-055 | Sistema | Orientar | Operaciones sensibles | Importacion, borrado total o estado de notificaciones | El sistema muestra ayuda contextual breve antes de modificar datos o permisos. | Baja | Sugerido | Revisar dialogs y secciones sensibles. |

## Validacion de Calidad del Formato

| Atributo | Aplicacion en este documento | Evidencia esperada |
| --- | --- | --- |
| Correcto / necesario | Cada requerimiento describe una necesidad observada del modulo o una mejora justificada. | Relacion con casos de uso, reglas de negocio o pruebas. |
| Completo | Cada fila define actor, accion, objeto, entrada y resultado. | No quedan resultados implicitos o dependientes de interpretacion. |
| Consistente | Los nombres de modulos y entidades se mantienen uniformes. | Comparacion con `reglas_de_negocio.md` y `trazabilidad.md`. |
| No ambiguo | Se evitan frases vagas y se especifica salida observable. | Cada resultado esperado puede revisarse en pantalla, estado o persistencia. |
| Verificable | La columna Verificacion indica como probar el requerimiento. | Casos de prueba automatizados o manuales. |
| Prioritario | Cada requerimiento conserva prioridad Alta, Media o Baja. | Priorizacion visible en la tabla. |
| Factible | Los estados distinguen implementado, parcial y sugerido. | No se presenta como completo lo que aun requiere trabajo. |
| Trazable | Cada requerimiento mantiene identificador unico. | Relacionable con matriz de trazabilidad. |
| Modificable | El formato tabular permite editar una fila sin alterar otras. | Cambios acotados por ID. |
| Conciso y entendible | Las filas usan frases breves y estructura repetible. | Lectura clara para usuarios y desarrolladores. |

## Requerimientos que Requieren Atencion

| ID | Motivo | Ajuste recomendado |
| --- | --- | --- |
| RF-048 | La confirmacion reforzada de borrado masivo debe ser verificable y no solo declarativa. | Definir el mecanismo exacto de confirmacion adicional. |
| RF-049 | La gestion de datos locales depende de validar claramente exportacion, importacion y borrado total. | Separar criterios de exportar, importar y borrar si crecen en alcance. |
| RF-051 | El alcance de `Deshacer` debe limitarse a acciones tecnicamente reversibles. | Definir por entidad que acciones son reversibles. |
| RF-054 | Los diagnosticos de conflicto deben indicar el dato causante cuando este disponible. | Mostrar entidad o rango horario involucrado. |
