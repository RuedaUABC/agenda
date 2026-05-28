# Plan de Verificacion y Validacion de Software - Agenda

## 0. Historial de Revisiones

| Version | Fecha | Descripcion de cambios | Autor |
| --- | --- | --- | --- |
| 1.0 | 2026-05-24 | Version inicial del Plan de Verificacion y Validacion de Agenda. | Equipo de V&V |
| 1.1 | 2026-05-28 | Actualizacion con pruebas de interfaz de usuario, usabilidad, metricas UI, Pareto y resultados actuales de `flutter analyze`/`flutter test`. | Equipo de V&V |
| 1.2 | 2026-05-28 | Actualizacion con resultados del reporte integrado de pruebas UI/UX ejecutado el 2026-05-27. | Equipo de V&V |

## 1. Proposito

El presente documento define el Plan de Verificacion y Validacion (V&V) para
Agenda, una aplicacion Flutter multiplataforma orientada a organizar tareas,
horarios de clases, eventos de calendario y preferencias de notificacion.

Los objetivos principales del plan son:

- Establecer actividades, metodos, recursos, responsabilidades y criterios para
  verificar y validar el sistema.
- Asegurar que Agenda cumpla con los requisitos funcionales y no funcionales
  documentados.
- Confirmar que los modulos de tareas, horario, calendario, configuracion y
  navegacion respondan a los flujos esperados por el usuario.
- Reducir la introduccion de defectos mediante revisiones tempranas, analisis
  estatico, pruebas automatizadas, trazabilidad y ciclos TDD.
- Documentar brechas conocidas sin declararlas como funcionalidad completa.
- Alinear las actividades de V&V con buenas practicas de ingenieria de software
  y referencias como IEEE 1012 e ISO/IEC 12207.

## 2. Alcance

### 2.1. Alcance del Sistema

Agenda incluye los siguientes modulos y capacidades:

- Tareas: consulta de tareas activas, papelera, creacion, edicion, eliminacion
  logica, restauracion, eliminacion definitiva, cambio de estado, clasificacion,
  progreso diario, estadisticas semanales, detalle y filtrado por estado.
- Horario: consulta de clases, creacion de clases semanales, validaciones de
  materia, aula, rango horario y solapamientos, recurrencia semanal, visualizacion
  semanal, lista por dia, edicion y eliminacion.
- Calendario: consulta de eventos, visualizacion mensual, seleccion de fecha,
  lista por dia, eventos de varios dias, representacion visual, creacion,
  edicion, eliminacion y advertencia por superposiciones.
- Configuracion: preferencias de notificacion para clases y tareas, validacion
  de preferencias, persistencia local, reprogramacion de tareas pendientes,
  aviso de eventos con scheduler nativo, tema visual, vista inicial, densidad
  visual, inicio de semana, confirmaciones configurables, gestion nativa de
  datos locales e informacion de la aplicacion.
- Navegacion: cambio entre modulos, conservacion de estado y navegacion
  responsiva con componentes Material 3.
- Persistencia: almacenamiento local con SQLite y preferencias locales para uso
  offline.

El sistema esta desarrollado en Flutter y conserva configuracion para Android,
iOS, Web, Windows, Linux y macOS. En Windows y Linux se inicializa
`sqflite_common_ffi` para soporte SQLite de escritorio.

### 2.2. Alcance de las Actividades de V&V

El Plan de V&V cubre:

- Revision de requisitos funcionales y no funcionales.
- Revision de casos de uso, reglas de negocio y trazabilidad.
- Revision de arquitectura feature-first, separacion por capas y flujo de
  datos.
- Verificacion de diseno Material 3, navegacion responsiva y estados de UI.
- Verificacion de codigo mediante analisis estatico y pruebas automatizadas.
- Pruebas unitarias, de widgets, de controllers, de serializacion y por feature.
- Pruebas de integracion entre navegacion, tareas, horario, calendario,
  configuracion y persistencia.
- Gestion de defectos, brechas conocidas, causas y acciones de mejora.
- Definicion de metricas, reportes, riesgos y criterios de aceptacion.

Quedan fuera de este plan:

- Certificacion formal externa del producto.
- Auditorias externas de procesos organizacionales.
- Certificacion externa de entrega de notificaciones por cada sistema
  operativo, mas alla de la integracion y pruebas automatizadas locales.
- Seguimiento posterior de remediaciones UI/UX despues de aplicar las acciones
  correctivas derivadas del reporte del 2026-05-27.
- Integracion con Firebase u otros servicios externos retirados del alcance
  actual.

## 3. Referencias Normativas y Documentos Relacionados

### 3.1. Normas y Estandares

- IEEE 1012 - Standard for System and Software Verification and Validation.
- ISO/IEC 12207 - Systems and software engineering - Software life cycle
  processes.
- ISO/IEC 25010 - Systems and software quality models, aplicado a usabilidad,
  accesibilidad, compatibilidad, adecuacion funcional, eficiencia,
  confiabilidad y consistencia de interfaz.
- ISO 9241-11 - Ergonomics of Human-System Interaction, usado como referencia
  para efectividad, eficiencia y satisfaccion en pruebas de usabilidad.
- Buenas practicas de pruebas unitarias, pruebas de widgets y Test-Driven
  Development aplicadas al ecosistema Flutter.
- Lineamientos Material 3 aplicables al diseno visual y componentes de interfaz.
- Referencias de usabilidad e interfaz: Nielsen, Norman, Rubin y Chisnell,
  ISTQB Foundation Level y practicas de pruebas UI documentadas para el
  proyecto.

### 3.2. Documentos del Proyecto

Los siguientes documentos se usaron como insumo. Su contenido clave queda
integrado en los anexos de este SVVP para que el plan pueda sostenerse por si
mismo sin depender de abrir archivos externos.

- `README.md`: descripcion general, estado actual, requisitos y comandos.
- `docs/README.md`: indice de documentacion tecnica.
- `docs/arquitectura.md`: estructura del codigo, capas por feature y flujo de
  datos.
- `docs/desarrollo.md`: instalacion, ejecucion, analisis, pruebas y notas de
  configuracion.
- `docs/pruebas.md`: resumen de cobertura y comandos de pruebas.
- `docs/casos_prueba.md`: casos de prueba formales por funcionalidad.
- `docs/diseno_material3.md`: guia de interfaz Material 3.
- `docs/requerimientos/requerimientos_funcionales.md`: RF del sistema.
- `docs/requerimientos/requerimientos_no_funcionales.md`: RNF del sistema.
- `docs/requerimientos/casos_de_uso.md`: flujos principales y alternativos.
- `docs/requerimientos/reglas_de_negocio.md`: reglas independientes de
  tecnologia.
- `docs/requerimientos/trazabilidad.md`: matriz de trazabilidad.
- `docs/red_green_refactor_*.md`: evidencia de ciclos TDD y mejoras.
- `Pruebas de interfaz de usuario-usabilidad-1.pdf`: insumo actualizado para
  tipos de prueba UI, atributos de calidad, metricas, herramientas y
  referencias formales de usabilidad.
- `Reporte de Pruebas de Interfaz y Usabilidad.pdf`: resultados integrados de
  pruebas fisicas UI/UX ejecutadas el 2026-05-27 con usuarios reales y equipo
  de desarrollo.

## 4. Definiciones y Acronimos

- V&V: Verificacion y Validacion.
- SVVP: Software Verification and Validation Plan.
- SVVR: Software Verification and Validation Report.
- RF: Requisito funcional.
- RNF: Requisito no funcional.
- RN: Regla de negocio.
- CU: Caso de uso.
- QA: Aseguramiento de calidad.
- TDD: Test-Driven Development.
- Defecto: no conformidad del sistema con un requisito especificado o con una
  expectativa razonable del usuario.
- Incidencia: registro formal de un defecto, brecha o comportamiento observado.
- Prueba unitaria: prueba focalizada en una unidad de logica o dominio.
- Prueba de widget: prueba de comportamiento y renderizado de componentes
  Flutter.
- Prueba de integracion/sistema: prueba que valida la interaccion entre modulos,
  persistencia y flujos completos.
- Matriz de trazabilidad: relacion entre requisitos, casos de uso, reglas,
  pruebas y evidencia tecnica.
- Prueba de interfaz de usuario: verificacion visual y tecnica de pantallas,
  botones, formularios, menus, iconos, navegacion, responsividad,
  retroalimentacion y consistencia grafica.
- Prueba de usabilidad: evaluacion con usuarios, escenarios, tareas,
  observacion, cuestionarios y analisis de comportamiento para medir facilidad,
  eficiencia, aprendizaje, errores y satisfaccion.
- Accesibilidad: capacidad de la interfaz para ser operable por personas con
  distintas capacidades, incluyendo objetivos tactiles, contraste, etiquetas,
  navegacion por teclado y compatibilidad con tecnologias asistivas.
- SUS: System Usability Scale, cuestionario estandar para medir satisfaccion y
  percepcion de usabilidad.
- PSSUQ: Post-Study System Usability Questionnaire, cuestionario post-prueba
  para valorar utilidad, calidad de informacion y calidad de interfaz.
- WCAG: Web Content Accessibility Guidelines, referencia para evaluar
  accesibilidad de interfaces.

## 5. Descripcion General del Sistema

Agenda es una aplicacion de organizacion academica y personal. Permite al
usuario administrar tareas, consultar un horario de clases recurrentes,
gestionar eventos de calendario y ajustar preferencias de notificacion e
interfaz.

La arquitectura del sistema es feature-first:

- `lib/features/tareas/`: dominio, datos, repositorio, controlador y UI de
  tareas.
- `lib/features/horario/`: gestion de clases y calendario semanal.
- `lib/features/calendario/`: gestion y validacion de eventos.
- `lib/features/configuracion/`: preferencias, ajustes avanzados y estado de
  configuracion.
- `lib/features/navegacion/`: navegacion adaptativa.
- `lib/core/`: base de datos, tema, utilidades y widgets compartidos.

La criticidad del sistema se considera media. Aunque no gestiona informacion de
alto riesgo como datos medicos o financieros, errores en persistencia,
clasificacion, fechas, eventos o recordatorios pueden afectar la organizacion
del usuario. Por ello, el plan prioriza integridad local, trazabilidad,
validaciones, pruebas automatizadas, UI consistente y manejo visible de errores.

## 6. Organizacion de Verificacion y Validacion

### 6.1. Roles y Responsabilidades

| Rol | Responsabilidades |
| --- | --- |
| Responsable de V&V | Definir estrategia de V&V, mantener trazabilidad, consolidar metricas, coordinar revisiones y emitir conclusiones. |
| Responsable de QA | Verificar cumplimiento del proceso, revisar criterios de aceptacion, validar reportes y asegurar que las brechas queden documentadas. |
| Desarrolladores | Implementar funcionalidad, escribir pruebas unitarias/widgets, corregir defectos y actualizar documentacion tecnica. |
| Ingenieros de prueba | Diseñar casos de prueba, ejecutar pruebas, registrar incidencias, verificar correcciones y reportar resultados. |
| Usuario representante | Validar flujos funcionales, participar en pruebas de aceptacion y retroalimentar usabilidad. |
| Patrocinador o jefe de proyecto | Aprobar entregables, priorizar pendientes y aceptar/rechazar liberacion. |

Responsables nominales:

- Responsable de V&V: Moreno Lopez Yamir Exel
- Responsable de QA: Alan Alexis Galvez Necoechea
- Desarrolladores: Alan Alexis Galvez Necoechea; Moreno Lopez Yamir Exel; Garcia Vargas Kevin Misael; Rueda Gallegos Jorge Alberto
- Usuarios representantes en pruebas UI/UX: Juan, Ariel y Marcos.
- Patrocinador o jefe de proyecto: Luis Ernesto Mellín Pineda

### 6.2. Independencia de V&V

Cuando sea posible, las actividades de V&V deben realizarse por una persona
distinta a quien implemento el componente revisado. Para el contexto academico
del proyecto, la independencia se propone mediante revision cruzada entre
integrantes:

- Requisitos y casos de uso revisados por una persona distinta a quien los
  redacto.
- Diseno y arquitectura revisados contra la estructura real del codigo.
- Codigo revisado mediante pruebas, analisis estatico y peer review.
- Pruebas de aceptacion ejecutadas con usuarios o representantes que no hayan
  implementado la funcionalidad.

Si no se logra independencia total, debe documentarse como limitacion del
proceso.

## 7. Estrategia de Verificacion y Validacion

### 7.1. Actividades de V&V por Fase del Ciclo de Vida

#### 7.1.1. Fase de Requisitos

Actividades:

- Revisar RF y RNF para detectar ambiguedades, inconsistencias, omisiones y
  requisitos no verificables.
- Confirmar que cada RF tenga identificador, prioridad, estado y descripcion.
- Revisar casos de uso y reglas de negocio asociadas.
- Mantener la matriz de trazabilidad requisito-caso de uso-regla-prueba.
- Identificar requisitos parciales o pendientes sin declararlos como completos.

Artefactos revisados:

- `docs/requerimientos/requerimientos_funcionales.md`
- `docs/requerimientos/requerimientos_no_funcionales.md`
- `docs/requerimientos/casos_de_uso.md`
- `docs/requerimientos/reglas_de_negocio.md`
- `docs/requerimientos/trazabilidad.md`

Entregables:

- Informe de revision de requisitos.
- Matriz de trazabilidad actualizada.
- Lista de requisitos parciales y pendientes.

#### 7.1.2. Fase de Diseno

Actividades:

- Revisar la arquitectura feature-first.
- Verificar separacion entre dominio, datos, repositorios y presentacion.
- Revisar el flujo UI -> controller -> repository -> DAO -> SQLite.
- Verificar consistencia Material 3, estados vacios, navegacion adaptativa y
  componentes compartidos.
- Revisar que la UI no acceda directamente a persistencia cuando exista
  controller o repositorio.

Artefactos revisados:

- `docs/arquitectura.md`
- `docs/diseno_material3.md`
- `lib/core/`
- `lib/features/`

Entregables:

- Informe de revision de diseno.
- Observaciones de arquitectura y mantenibilidad.
- Plan de pruebas de sistema.

#### 7.1.3. Fase de Implementacion

Actividades:

- Aplicar TDD en funcionalidades seleccionadas.
- Ejecutar pruebas unitarias y de widgets durante el desarrollo.
- Mantener validaciones en formularios, controllers y reglas de dominio cuando
  aplique.
- Ejecutar analisis estatico.
- Revisar errores visibles y manejo de persistencia.

Evidencia:

- `docs/red_green_refactor_eventos.md`
- `docs/red_green_refactor_validaciones.md`
- `docs/red_green_refactor_tareas_configuracion_robustez.md`
- `docs/red_green_refactor_diseno_material3.md`
- `docs/red_green_refactor_horario_material3.md`
- `docs/red_green_refactor_calendario_material3.md`
- `docs/red_green_refactor_ajustes_avanzados.md`

Entregables:

- Resultados de pruebas automatizadas.
- Resultados de analisis estatico.
- Evidencia Red-Green-Refactor.
- Registro de defectos corregidos.

#### 7.1.4. Fase de Pruebas de Integracion y Sistema

Actividades:

- Ejecutar pruebas por feature y suite completa.
- Validar navegacion entre tareas, horario, calendario y ajustes.
- Validar persistencia local y serializacion.
- Validar interaccion de preferencias con pantallas activas.
- Revisar que los RF parciales se mantengan documentados como parciales.

Comandos:

```powershell
flutter analyze
flutter test
flutter test test/features/tareas
flutter test test/features/horario
flutter test test/features/calendario
flutter test test/features/configuracion
flutter test test/features/diseno_material3
```

Entregables:

- Informe de pruebas de integracion.
- Informe de pruebas de sistema.
- Matriz de casos Pass, Partial y Not Executed.

#### 7.1.5. Fase de Aceptacion y Operacion Piloto

Actividades:

- Ejecutar pruebas funcionales con usuarios representativos.
- Ejecutar pruebas de interfaz de usuario sobre apariencia, navegacion,
  compatibilidad, responsividad, accesibilidad basica e interacciones.
- Aplicar cuestionario SUS o PSSUQ a funciones clave cuando existan
  participantes.
- Validar tareas, horario, calendario y ajustes en escenarios reales.
- Registrar tiempo de ejecucion, numero de clics/pasos, errores de usuario,
  ayudas solicitadas, abandonos, satisfaccion y comentarios.
- Registrar defectos de aceptacion, hallazgos de interfaz, mejoras y acciones
  pendientes.
- Ejecutar regresion despues de correcciones relevantes.

Funciones candidatas para SUS/PSSUQ y escenarios de usabilidad:

- RF-005: creacion de tareas.
- RF-007/RF-010: edicion, eliminacion logica y recuperacion de tareas.
- RF-018: creacion de clases semanales.
- RF-026/RF-028: consulta de calendario y lista diaria.
- RF-030: creacion de eventos.
- RF-034/RF-044: configuracion de preferencias y tema visual.

Cobertura UI documentada:

- TC-UI-001: consistencia visual de interfaz.
- TC-UI-002: navegacion y flujo entre pantallas.
- TC-UI-003: responsividad de navegacion.
- TC-UI-004: retroalimentacion ante acciones.
- TC-UI-005: accesibilidad basica de controles.
- TC-US-001: prueba de tareas con usuarios reales.
- TC-US-002: satisfaccion de usuario mediante SUS o PSSUQ.

Entregables:

- Informe de pruebas de aceptacion.
- Resultados de pruebas UI.
- Resultados SUS/PSSUQ, cuando se ejecuten sesiones con usuarios.
- Acta de aceptacion o lista de acciones pendientes.

Estado actual: las pruebas UI/UX fisicas fueron ejecutadas el 2026-05-27 con
tres usuarios reales, Juan, Ariel y Marcos, y evaluacion tecnica del equipo de
desarrollo sobre el port de escritorio. El reporte integrado registra 15 casos
ejecutados, todos con estado final exitoso o exitoso con alerta, y 10 hallazgos
colectivos de interfaz/usabilidad que quedan como acciones de remediacion.

Resultados cuantitativos del reporte UI/UX:

| Caso | Modulo | Tarea | Meta | Promedio | Estado |
| --- | --- | --- | --- | ---: | --- |
| TC-TAR-004 | Tareas | Validacion completa de tarea | < 45 s | 25.84 s | Exitoso |
| TC-TAR-016 | Tareas | Rechazo de tarea duplicada | < 30 s | 21.74 s | Exitoso con alerta |
| TC-TAR-008 | Tareas | Eliminacion logica de tarea | < 25 s | 8.17 s | Exitoso |
| TC-TAR-011 | Tareas | Clasificacion de tareas | < 30 s | 10.77 s | Exitoso |
| TC-HOR-002 | Horario | Creacion de clase semanal | < 60 s | 35.07 s | Exitoso |
| TC-HOR-004 | Horario | Rango horario y solapamiento | < 35 s | 12.51 s | Exitoso |
| TC-CAL-010 | Calendario | Validar rango de evento | < 30 s | 22.17 s | Exitoso con alerta |
| TC-CAL-014 | Calendario | Advertencia de superposiciones | < 40 s | 19.04 s | Exitoso |
| TC-CONF-012 | Ajustes | Confirmaciones configurables | < 40 s | 15.14 s | Exitoso |
| TC-CONF-013 | Ajustes | Exportar respaldo JSON | < 30 s | 15.40 s | Exitoso |
| TC-CONF-014 | Ajustes | Borrado de datos con `BORRAR` | < 20 s | 17.10 s | Exitoso |
| TC-CONF-015 | Ajustes | Aplicacion en tiempo real | < 25 s | 15.40 s | Exitoso |
| TC-CONF-016 | Ajustes | Importar respaldo JSON | < 25 s | 22.70 s | Exitoso |
| TC-M3-002 | Interfaz | Navegacion adaptativa Material 3 | < 20 s | 10.11 s | Exitoso |
| TC-UI-004 | Interfaz | Retroalimentacion con snackbar | < 30 s | 18.00 s | Exitoso |

Hallazgos colectivos del reporte UI/UX:

- Area reactiva inconsistente en botones con texto e icono.
- Falta de cursor tipo pointer/hand en elementos interactivos de escritorio.
- Desajustes geometricos en pantallas grandes por traduccion directa del
  layout movil.
- Falta de flujo guiado para creacion de eventos.
- Selector de hora circular poco intuitivo.
- Entrada de hora por teclado demasiado oculta o con contraste insuficiente.
- Boton para agregar otra clase desencuadrado tras agregar una materia.
- Baja densidad informativa del calendario al indicar eventos solo con puntos.
- Redundancia de informacion en la vista de calendario.
- Retraso visual despues del borrado local de datos, aunque la accion tecnica
  se ejecuta internamente.

Acciones correctivas definidas:

- Expandir el area seleccionable completa de botones y forzar `cursor: pointer`
  en hover.
- Establecer ancho maximo y padding automatico en pantallas mayores a 1024 px.
- Sustituir el selector circular de hora por entrada directa tipo `00:00`.
- Eliminar etiquetas redundantes del calendario y usar badges o etiquetas con
  titulo parcial del evento.
- Fijar la posicion del boton "Agregar clase" con contenedor flexible estable.
- Vincular la confirmacion `BORRAR` con actualizacion global de estado para
  repintar la UI inmediatamente.

### 7.2. Metodos y Tecnicas de V&V

#### 7.2.1. Tecnicas estaticas

- Inspecciones de requisitos.
- Walkthroughs de casos de uso.
- Revision de reglas de negocio.
- Revision de matriz de trazabilidad.
- Revision de arquitectura.
- Revision de codigo o peer review.
- Analisis estatico con `flutter analyze`.
- Revision de documentacion TDD.

#### 7.2.2. Tecnicas dinamicas

- Pruebas unitarias.
- Pruebas de widgets.
- Pruebas de controllers.
- Pruebas de serializacion.
- Pruebas funcionales por modulo.
- Pruebas de integracion entre modulos.
- Pruebas de regresion tras correcciones.
- Pruebas visuales de UI: apariencia, alineacion, colores, tipografia,
  iconografia y consistencia grafica.
- Pruebas funcionales de UI: botones, formularios, controles, mensajes y
  acciones visibles.
- Pruebas de navegacion y responsividad en anchos movil, tablet y escritorio.
- Pruebas de interaccion: retroalimentacion visual, estados de guardado,
  errores, confirmaciones y acciones de recuperacion.
- Pruebas de accesibilidad basica: objetivos tactiles, controles reconocibles
  y criterios iniciales de operabilidad.
- Pruebas manuales de aceptacion.
- Pruebas de usabilidad con usuarios reales mediante escenarios, observacion y
  cuestionarios SUS o PSSUQ.

### 7.3. Criterios de Aceptacion

Para considerar aceptable una version de Agenda:

- `flutter analyze` debe ejecutarse sin errores bloqueantes.
- `flutter test` debe ejecutarse sin fallos en la suite completa.
- Los casos de prueba de prioridad Alta deben estar en estado Pass o tener
  justificacion documentada.
- Todo RF declarado como Implementado debe tener evidencia en codigo,
  documentacion o prueba.
- RF-043 debe conservar evidencia automatizada de scheduler nativo de eventos.
- RF-048 y RF-049 deben conservar evidencia de confirmaciones configurables,
  recuperacion/deshacer cuando aplique, palabra `BORRAR` para borrado total y
  tratamiento visual destructivo verificable.
- No deben existir defectos criticos abiertos en tareas, horario, calendario,
  configuracion, navegacion o persistencia.
- Las pruebas de regresion deben ejecutarse despues de cambios en validaciones,
  persistencia, navegacion o configuracion.
- Las limitaciones conocidas deben aparecer en reportes y conclusiones.
- Los casos UI de prioridad Alta deben quedar en Pass o tener hallazgo
  documentado con accion de mejora.
- Las pruebas de usabilidad con usuarios reales deben conservar evidencia de
  tiempos, participantes, hallazgos y acciones correctivas; las remediaciones
  UI/UX deben re-probarse antes de cierre final.

## 8. Planificacion y Cronograma

Cronograma simulado tomando como fecha de inicio del proyecto el 27/03/2026 y
como fecha final el 29/05/2026. Las fechas se distribuyen por fases para cubrir
planeacion, construccion, verificacion, validacion y cierre.

| Hito | Periodo | Actividad | Entregable | Responsable |
| --- | --- | --- | --- | --- |
| H1 | 27/03/2026 - 03/04/2026 | Inicio del proyecto, definicion de alcance, identificacion de modulos y levantamiento inicial de requisitos. | Alcance inicial, lista preliminar de RF/RNF y casos de uso base. | Moreno Lopez Yamir Exel; Alan Alexis Galvez Necoechea; Rueda Gallegos Jorge Alberto |
| H2 | 04/04/2026 - 12/04/2026 | Revision y refinamiento de requisitos, reglas de negocio y trazabilidad inicial. | Requisitos funcionales/no funcionales, reglas de negocio y matriz de trazabilidad preliminar. | Moreno Lopez Yamir Exel; Alan Alexis Galvez Necoechea; Rueda Gallegos Jorge Alberto |
| H3 | 13/04/2026 - 21/04/2026 | Revision de arquitectura, diseno de capas, persistencia local y lineamientos Material 3. | Informe de diseno, arquitectura feature-first y criterios de interfaz. | Alan Alexis Galvez Necoechea; Moreno Lopez Yamir Exel; Garcia Vargas Kevin Misael; Rueda Gallegos Jorge Alberto |
| H4 | 22/04/2026 - 08/05/2026 | Implementacion y verificacion por modulo: tareas, horario, calendario, configuracion y navegacion. | Funcionalidades implementadas, pruebas unitarias/widgets y evidencia Red-Green-Refactor. | Alan Alexis Galvez Necoechea; Moreno Lopez Yamir Exel; Garcia Vargas Kevin Misael; Rueda Gallegos Jorge Alberto |
| H5 | 09/05/2026 - 17/05/2026 | Pruebas de integracion, pruebas de sistema, revision de persistencia y regresion. | Resultados de `flutter analyze`, `flutter test`, pruebas por feature y lista de defectos/brechas. | Moreno Lopez Yamir Exel; Alan Alexis Galvez Necoechea; Rueda Gallegos Jorge Alberto |
| H6 | 18/05/2026 - 24/05/2026 | Validacion funcional, revision de interfaz/usabilidad, preparacion de SUS/PSSUQ y documentacion de pendientes. | Informe de validacion, casos TC-UI/TC-US, candidatos SUS/PSSUQ y acciones pendientes. | Moreno Lopez Yamir Exel; Alan Alexis Galvez Necoechea; Rueda Gallegos Jorge Alberto; usuarios Juan, Ariel y Marcos |
| H7 | 25/05/2026 - 29/05/2026 | Cierre de V&V, consolidacion de metricas, analisis de defectos, conclusiones y aprobacion. | SVVR, aprobacion final o lista de acciones pendientes para liberacion. | Moreno Lopez Yamir Exel; Alan Alexis Galvez Necoechea; Rueda Gallegos Jorge Alberto; Luis Ernesto Mellín Pineda |

## 9. Recursos, Herramientas y Ambientes

### 9.1. Recursos Humanos

- Responsable de V&V: Moreno Lopez Yamir Exel
- Responsable de QA: Alan Alexis Galvez Necoechea
- Desarrolladores: Alan Alexis Galvez Necoechea; Moreno Lopez Yamir Exel; Garcia Vargas Kevin Misael; Rueda Gallegos Jorge Alberto
- Ingenieros de prueba: Moreno Lopez Yamir Exel; Alan Alexis Galvez Necoechea
- Usuarios participantes: Juan, Ariel y Marcos.
- Patrocinador o jefe de proyecto: Luis Ernesto Mellín Pineda

### 9.2. Herramientas

- Flutter.
- Dart.
- `flutter analyze`.
- `flutter test`.
- Git y GitHub.
- SQLite mediante `sqflite`.
- `sqflite_common_ffi` para escritorio.
- `shared_preferences`.
- Syncfusion Flutter Calendar.
- Herramientas ofimaticas para reportes, Ishikawa y Pareto.
- Registro de incidencias mediante documentacion Markdown y, si se requiere
  seguimiento operativo, GitHub Issues.
- Pruebas UI automatizadas con `flutter test` y pruebas de widgets.
- Herramientas de referencia para UI testing externo, si el alcance se amplia:
  Selenium, Cypress, Playwright o TestComplete.
- Herramientas de referencia para estudios de usabilidad, si se realizan con
  usuarios remotos: Maze, UserTesting, Lookback u otra equivalente.

### 9.3. Ambientes de Prueba

- Ambiente local de desarrollo en la raiz del proyecto Agenda.
- Ambiente de pruebas automatizadas de Flutter.
- Ambiente de escritorio Windows/Linux para validar SQLite FFI.
- Ambiente Web o movil para validar responsividad y navegacion.
- Anchos de referencia para UI responsiva documentados en pruebas: 390 px
  (movil), 800 px (tablet) y 1200 px (escritorio).
- Dispositivo fisico, emulador o navegador final de aceptacion: pendiente de
  registrar cuando se ejecuten sesiones con usuarios reales.

## 10. Gestion de Configuracion y Control de Cambios

Los artefactos del proyecto se mantienen bajo control de versiones. La
documentacion se ubica principalmente en `docs/` y el codigo fuente en `lib/`.

Artefactos bajo control:

- Requisitos funcionales y no funcionales.
- Casos de uso.
- Reglas de negocio.
- Matriz de trazabilidad.
- Casos de prueba.
- Evidencia TDD.
- Codigo fuente y pruebas automatizadas.
- Configuracion de plataformas Flutter.

Politica de cambios:

- Todo cambio funcional debe actualizar requisitos, casos de prueba y matriz de
  trazabilidad cuando corresponda.
- Todo cambio de arquitectura debe actualizar `docs/arquitectura.md`.
- Todo cambio de comandos, SDK o dependencias debe actualizar
  `docs/desarrollo.md`.
- Todo cambio relevante en pruebas debe actualizar `docs/pruebas.md`.
- Los requisitos parciales no deben cambiarse a Implementado hasta contar con
  evidencia suficiente.
- Los builds o versiones candidatas deben etiquetarse o registrarse antes de
  pruebas de aceptacion.

## 11. Gestion de Defectos y Analisis de Causas

### 11.1. Flujo de Gestion de Incidencias

1. Deteccion: el defecto se identifica mediante prueba automatizada, revision,
   ejecucion manual o retroalimentacion de usuario.
2. Registro: se documenta ID, titulo, descripcion, modulo afectado, severidad,
   prioridad, pasos para reproducir, resultado esperado y resultado obtenido.
3. Clasificacion inicial: se asigna categoria preliminar.
4. Asignacion: el responsable de V&V o QA asigna la incidencia a un responsable.
5. Correccion: se implementa la solucion y se agregan o actualizan pruebas.
6. Verificacion: se ejecutan pruebas focalizadas y regresion.
7. Cierre: se cierra la incidencia con evidencia y causa raiz.
8. Revision periodica: se analizan tendencias mediante Ishikawa y Pareto.

Campos minimos para registrar defectos:

| Campo | Descripcion |
| --- | --- |
| ID | Identificador unico del defecto. |
| Modulo | Tareas, horario, calendario, configuracion, navegacion, persistencia, UI o documentacion. |
| Severidad | Critica, Alta, Media o Baja. |
| Prioridad | Alta, Media o Baja. |
| Categoria | Requisitos, diseno, codificacion, interfaz, datos, herramientas, pruebas o gestion. |
| Pasos | Secuencia para reproducir. |
| Esperado | Resultado correcto. |
| Obtenido | Resultado observado. |
| Estado | Abierto, en correccion, verificado o cerrado. |
| Evidencia | Prueba, captura, archivo, commit o documento relacionado. |

### 11.2. Diagrama de Ishikawa (Causa Raiz)

Para defectos recurrentes se utilizara analisis de Ishikawa con estas
categorias:

- Personas: falta de revision cruzada, desconocimiento de reglas de negocio o
  poca disponibilidad de usuarios.
- Metodos/procesos: ausencia de prueba de regresion, requisitos incompletos o
  cambios no reflejados en trazabilidad.
- Herramientas: limitaciones del entorno de prueba, falta de herramienta formal
  de incidencias o dependencias de plataforma.
- Datos: datos de prueba insuficientes, fechas limite no representativas,
  preferencias invalidas o base local antigua.
- Requisitos: ambiguedad, omisiones, expectativas no capturadas o criterios de
  aceptacion incompletos.
- Gestion/organizacion: tiempos reducidos, cambios tardios o falta de usuarios
  para aceptacion.

Ejemplo aplicable a Agenda:

- Problema: "Eventos o clases aparecen en horarios incorrectos".
- Posibles causas: reglas de fecha incompletas, RRULE mal normalizada, zona
  horaria no considerada, pruebas insuficientes de limites, datos antiguos o UI
  que no actualiza la seleccion.

### 11.3. Analisis de Pareto de Defectos

El analisis de Pareto se aplicara para identificar que categorias concentran la
mayor parte de los defectos.

Procedimiento:

1. Agrupar defectos por categoria: requisitos, diseno, codificacion, interfaz,
   datos, herramientas, pruebas o gestion.
2. Contar los defectos de cada categoria.
3. Calcular frecuencia relativa.
4. Ordenar categorias de mayor a menor.
5. Calcular porcentaje acumulado.
6. Identificar las pocas causas vitales que expliquen al menos 70% de los
   defectos.

Resultado del reporte UI/UX del 2026-05-27:

| Categoria | Cantidad | % Total | % Acumulado |
| --- | ---: | ---: | ---: |
| Formularios/aprendizabilidad | 3 | 30.0% | 30.0% |
| Interaccion/operabilidad | 2 | 20.0% | 50.0% |
| Calendario/estetica | 2 | 20.0% | 70.0% |
| Layout/compatibilidad | 1 | 10.0% | 80.0% |
| Horario/consistencia visual | 1 | 10.0% | 90.0% |
| Persistencia/confiabilidad UI | 1 | 10.0% | 100.0% |

Interpretacion: las tres categorias principales concentran 70% de los
hallazgos UI/UX, por lo que las acciones de mejora deben priorizar
formularios/aprendizabilidad, interaccion/operabilidad y calendario/estetica.

Defectos o brechas conocidas actualmente:

| ID | Area | Descripcion | Estado |
| --- | --- | --- | --- |
| DEF-001 | Configuracion / eventos | RF-043 integra scheduler nativo de eventos y pruebas de programacion/cancelacion. | Cerrado |
| DEF-002 | Configuracion / clases | RF-048 aplica confirmaciones configurables a la accion visible de eliminacion de clases. | Cerrado |
| DEF-003 | Gestion de datos | RF-049 exporta/importa respaldos mediante selector/escritura de archivo nativo. | Cerrado |
| DEF-004 | Persistencia | Migracion SQLite cubierta por test automatizado con `sqflite_common_ffi`. | Cerrado |
| DEF-005 | Plataforma | SQLite FFI de escritorio cubierto por smoke test automatizado Windows/Linux. | Cerrado |
| DEF-006 | Tareas | RF-006/RF-007 bloquean duplicados exactos normalizados en creacion y edicion. | Cerrado |
| DEF-007 | Usabilidad | Sesiones UI/UX ejecutadas con Juan, Ariel y Marcos; 15 casos con estado final exitoso o exitoso con alerta. | Cerrado |
| DEF-008 | Accesibilidad | La accesibilidad esta cubierta solo de forma basica; falta auditoria WCAG completa. | Parcial |
| DEF-009 | Compatibilidad | El reporte detecta desajustes geometricos en pantallas grandes por adaptacion de layout movil a escritorio. | Abierto |
| DEF-010 | Interaccion | Botones con texto e icono no iluminan ni activan todo el contenedor. | Abierto |
| DEF-011 | Interaccion | Elementos interactivos no muestran cursor pointer/hand en hover. | Abierto |
| DEF-012 | Formularios | Creacion de eventos carece de flujo guiado o secuencia visual intuitiva. | Abierto |
| DEF-013 | Formularios | Selector de hora circular resulta poco intuitivo para usuarios finales. | Abierto |
| DEF-014 | Formularios | Entrada de hora por teclado esta oculta o tiene contraste insuficiente. | Abierto |
| DEF-015 | Horario | Boton para agregar otra clase se desencuadra tras registrar una materia. | Abierto |
| DEF-016 | Calendario | Vista mensual usa puntos pequenos que reducen lectura anticipada de actividades. | Abierto |
| DEF-017 | Calendario | Existen elementos informativos duplicados o superpuestos. | Abierto |
| DEF-018 | Gestion de datos | Borrado local ejecuta la accion, pero las vistas activas no se actualizan inmediatamente. | Abierto |

## 12. Metricas de V&V y Reportes

### 12.1. Metricas

Metricas a recolectar:

- Total de requisitos funcionales.
- Total de requisitos no funcionales.
- Porcentaje de RF implementados, parciales y pendientes.
- Numero de casos de prueba por modulo.
- Porcentaje de casos Pass, Partial y Not Executed.
- Numero de pruebas automatizadas ejecutadas.
- Numero de pruebas aprobadas y fallidas.
- Defectos por severidad.
- Defectos por categoria.
- Defectos por modulo.
- Cobertura de requisitos por casos de prueba.
- Tiempo medio de resolucion de defectos (MTTR), si se registran fechas de
  apertura y cierre.
- Tiempo de respuesta de interfaz.
- Tasa de errores de UI y densidad de defectos visuales.
- Cobertura de componentes de interfaz probados.
- Numero de clics o pasos por tarea.
- Tiempo de navegacion y tiempo de ejecucion de tareas.
- Compatibilidad multiplataforma por dispositivo, navegador o resolucion.
- Cumplimiento de accesibilidad basica y, cuando se ejecute, cumplimiento WCAG.
- Tasa de exito de tareas, ayudas solicitadas, tasa de abandono, carga
  cognitiva y satisfaccion SUS/PSSUQ.

Estado documental actual:

- 55 requisitos funcionales documentados.
- 31 requisitos no funcionales documentados.
- RF-043 documentado como implementado con evidencia automatizada.
- RF-048 y RF-049 documentados como implementados con evidencia de
  confirmaciones, recuperacion/deshacer y confirmacion reforzada para borrado
  total.
- 77 casos de prueba formales documentados por modulo en
  `docs/casos_prueba.md`.
- 5 casos especificos de UI documentados: TC-UI-001 a TC-UI-005.
- Pruebas UI/UX fisicas ejecutadas el 2026-05-27 con tres usuarios reales:
  Juan, Ariel y Marcos.
- 15 casos ejecutados en vivo con tiempo cronometrado; todos finalizaron como
  exitosos o exitosos con alerta.
- Tiempo promedio global de los casos ejecutados: 17.94 segundos.
- Hallazgos colectivos UI/UX documentados: 10.
- Matriz de trazabilidad documentada en `docs/requerimientos/trazabilidad.md`.
- Pruebas automatizadas organizadas por feature en `test/features/`.

Comandos ejecutados y salida registrada el 2026-05-28:

```powershell
flutter analyze
flutter test
```

Tabla de resultados:

| Comando | Fecha | Resultado | Observaciones |
| --- | --- | --- | --- |
| `flutter analyze` | 2026-05-28 | Pass | Output: `No issues found! (ran in 44.1s)`. |
| `flutter test` | 2026-05-28 | Pass | Output final: `+138: All tests passed!`. |

Resumen de salida:

- Analisis estatico: sin issues detectados.
- Suite completa: 138 pruebas aprobadas, 0 fallidas.
- La suite cubre pruebas unitarias, controllers, widgets, formularios,
  persistencia local, configuracion, navegacion adaptativa, componentes
  Material 3 y evidencia tecnica de UI.
- El reporte UI/UX del 2026-05-27 complementa la suite automatizada con pruebas
  fisicas presenciales, tiempos de ejecucion, usuarios reales y hallazgos de
  interfaz/usabilidad.

### 12.2. Reportes

Reportes esperados:

- Informe de revision de requisitos.
- Informe de revision de arquitectura y diseno.
- Informe de pruebas automatizadas.
- Informe de pruebas de integracion y sistema.
- Informe de pruebas de interfaz de usuario.
- Informe de pruebas de aceptacion.
- Informe de usabilidad con resultados UI/UX, tiempos por usuario, hallazgos y
  acciones correctivas.
- Informe de defectos.
- Analisis de causa raiz.
- Analisis de Pareto.
- SVVR: Software Verification and Validation Report final.

Cada reporte debe indicar:

- Fecha de ejecucion.
- Responsable.
- Alcance.
- Evidencia consultada.
- Resultado.
- Defectos encontrados.
- Metricas UI/usabilidad aplicables: tiempos, errores, ayudas, clics,
  abandono, satisfaccion y hallazgos de accesibilidad/compatibilidad.
- Acciones de mejora.
- Estado de aceptacion.

## 13. Riesgos de V&V y Estrategias de Mitigacion

| Riesgo | Impacto | Probabilidad | Mitigacion |
| --- | --- | --- | --- |
| Hallazgos UI/UX abiertos despues de pruebas fisicas. | Alto | Alta | Ejecutar el plan de remediacion del reporte: botones, hover, layout desktop, formularios de hora, calendario y borrado de datos. |
| Brechas de accesibilidad no detectadas por pruebas de widgets. | Medio | Media | Complementar TC-UI-005 con revision WCAG, contraste, teclado, etiquetas semanticas y tecnologias asistivas. |
| Adaptacion desktop inconsistente. | Medio | Alta | Establecer ancho maximo y padding automatico en pantallas mayores a 1024 px; repetir pruebas responsivas despues del cambio. |
| Requisitos cambiantes durante el cierre. | Medio | Media | Actualizar matriz de trazabilidad y ejecutar regresion. |
| Regresion en notificaciones nativas. | Bajo | Alta | Mantener `calendario_repository_notifications_test.dart` y fallback seguro del scheduler. |
| Regresion de migracion SQLite. | Bajo | Media | Mantener `sqlite_migration_test.dart` con base temporal FFI. |
| Regresion de SQLite escritorio. | Bajo | Media | Mantener `sqlite_ffi_smoke_test.dart` en CI Windows/Linux. |
| Regresion de exportacion/importacion nativa. | Bajo | Alta | Mantener `BackupFileService` inyectable y tests con fake. |
| Regresion de confirmaciones en clases. | Bajo | Media | Mantener cobertura de `horario_widgets_test.dart`. |
| Datos de prueba insuficientes. | Medio | Media | Crear datos representativos para tareas, clases, eventos y preferencias. |
| Documentacion desactualizada respecto al codigo. | Alto | Media | Actualizar docs junto con cada cambio funcional o de pruebas. |

## 14. Aprobacion

Al finalizar las actividades de V&V, el plan y sus resultados deben aprobarse por
los responsables definidos.

| Rol | Nombre | Firma | Fecha |
| --- | --- | --- | --- |
| Responsable de V&V | Moreno Lopez Yamir Exel | [PENDIENTE] | [PENDIENTE] |
| Responsable de QA | Alan Alexis Galvez Necoechea | [PENDIENTE] | [PENDIENTE] |
| Jefe de proyecto / patrocinador | Luis Ernesto Mellín Pineda | [PENDIENTE] | [PENDIENTE] |

## Anexo A. Requisitos Funcionales Integrados

La siguiente tabla resume el contenido importante de los requisitos funcionales
usados por este plan. No sustituye la matriz de trazabilidad, pero permite leer
el SVVP sin abrir el documento externo de requisitos.

| ID | Estado | Prioridad | Contenido importante |
| --- | --- | --- | --- |
| RF-001 | Implementado | Alta | El sistema permite navegar entre Tareas, Horario, Calendario y Ajustes desde una navegacion principal siempre disponible. |
| RF-002 | Implementado | Media | El sistema conserva el estado de cada modulo al cambiar de pantalla y regresar. |
| RF-003 | Implementado | Alta | El sistema muestra tareas activas almacenadas localmente, excluyendo las enviadas a papelera. |
| RF-004 | Implementado | Media | El sistema permite consultar tareas eliminadas logicamente dentro de la papelera. |
| RF-005 | Implementado | Alta | El usuario puede crear una tarea con titulo, asignatura, descripcion, fecha y hora. |
| RF-006 | Implementado | Alta | El sistema valida titulo, fecha, hora, longitudes, fechas pasadas y duplicados exactos normalizados antes de guardar tareas. |
| RF-007 | Implementado | Alta | El usuario puede editar una tarea existente aplicando las mismas validaciones, excluyendo su propio id e impidiendo duplicarse contra otra tarea. |
| RF-008 | Implementado | Alta | El usuario puede marcar una tarea como completada y devolverla a pendiente. |
| RF-009 | Implementado | Alta | El sistema envia tareas eliminadas a papelera en lugar de borrarlas definitivamente. |
| RF-010 | Implementado | Media | El usuario puede restaurar una tarea desde papelera conservando sus datos. |
| RF-011 | Implementado | Baja | El sistema permite eliminar definitivamente una tarea desde papelera con confirmacion. |
| RF-012 | Implementado | Alta | El sistema clasifica tareas activas en vencidas, semana, proximas y completadas. |
| RF-013 | Implementado | Media | El sistema calcula progreso diario segun tareas de hoy completadas contra total de tareas de hoy. |
| RF-014 | Implementado | Media | El sistema calcula estadisticas semanales de tareas pendientes para los proximos siete dias. |
| RF-015 | Implementado | Media | El usuario puede consultar detalle de tarea: titulo, asignatura, descripcion, fecha, hora y estado. |
| RF-016 | Implementado | Baja | El sistema permite filtrar tareas por estado desde la interfaz. |
| RF-017 | Implementado | Alta | El sistema carga y muestra clases guardadas localmente. |
| RF-018 | Implementado | Alta | El usuario puede crear clases semanales con materia, aula, fecha, horas y color. |
| RF-019 | Implementado | Alta | El sistema valida materia, fecha, inicio, fin, longitudes y solapamientos de horario de clase. |
| RF-020 | Implementado | Alta | El sistema registra clases como eventos recurrentes semanales para el dia seleccionado. |
| RF-021 | Implementado | Alta | El sistema muestra clases en una vista semanal de horario, adaptada a mobile y desktop. |
| RF-022 | Implementado | Media | El sistema lista clases del dia seleccionado con contador, metadatos y estado vacio. |
| RF-023 | Implementado | Media | El usuario puede modificar datos de una clase existente. |
| RF-024 | Implementado | Media | El usuario puede eliminar una clase existente y el horario se actualiza. |
| RF-025 | Implementado | Alta | El sistema carga eventos guardados localmente. |
| RF-026 | Implementado | Alta | El sistema muestra eventos en una vista mensual de calendario. |
| RF-027 | Implementado | Media | El sistema permite seleccionar fecha y conservar la seleccion dentro del modulo Calendario. |
| RF-028 | Implementado | Alta | El sistema lista eventos del dia seleccionado, incluyendo eventos de varios dias. |
| RF-029 | Implementado | Media | El sistema muestra titulo, descripcion, color y rango horario de cada evento. |
| RF-030 | Implementado | Alta | El usuario puede crear eventos desde Calendario con validaciones de titulo, fechas, descripcion y color. |
| RF-031 | Implementado | Alta | El usuario puede editar eventos existentes desde Calendario. |
| RF-032 | Implementado | Media | El usuario puede eliminar eventos existentes previa confirmacion. |
| RF-033 | Implementado | Baja | El sistema advierte cuando un evento se superpone con otro y permite cancelar o continuar. |
| RF-034 | Implementado | Media | El sistema carga preferencias globales de notificacion desde almacenamiento local. |
| RF-035 | Implementado | Media | El usuario puede configurar cuanto tiempo antes recibir avisos de clases. |
| RF-036 | Implementado | Media | El usuario puede configurar el primer aviso de tareas. |
| RF-037 | Implementado | Media | El sistema acepta solo valores de anticipacion permitidos. |
| RF-038 | Implementado | Media | El sistema guarda preferencias de notificacion localmente. |
| RF-039 | Implementado | Media | El sistema reprograma tareas pendientes cuando cambian preferencias de avisos. |
| RF-040 | Implementado | Alta | El sistema persiste tareas, clases, eventos y preferencias para uso offline. |
| RF-041 | Implementado | Alta | El sistema maneja migraciones de esquema al aumentar la version de base de datos. |
| RF-042 | Implementado | Alta | El sistema inicializa lo necesario para usar SQLite en Windows y Linux. |
| RF-043 | Implementado | Media | El usuario puede configurar aviso global de eventos y los eventos futuros se reprograman con scheduler nativo. |
| RF-044 | Implementado | Media | El usuario puede elegir tema visual: sistema, claro u oscuro. |
| RF-045 | Implementado | Baja | El usuario puede elegir el modulo inicial de la aplicacion. |
| RF-046 | Implementado | Baja | El usuario puede elegir densidad visual comoda o compacta sin reducir objetivos tactiles por debajo de 48x48. |
| RF-047 | Implementado | Baja | El usuario puede elegir inicio de semana lunes o domingo para calendario y horario. |
| RF-048 | Implementado | Media | El usuario puede configurar confirmaciones destructivas para tareas, clases y eventos; incluye preferencia, deshacer cuando aplica y confirmacion reforzada real para borrado masivo. |
| RF-049 | Implementado | Baja | El usuario puede gestionar datos locales mediante respaldo/importacion/borrado con selector y escritura de archivo nativo; el borrado total exige escribir `BORRAR`. |
| RF-050 | Implementado | Baja | El usuario puede consultar version, almacenamiento local y estado de notificaciones desde Ajustes. |
| RF-051 | Implementado | Alta | El sistema permite recuperar acciones reversibles mediante `Deshacer` cuando tecnicamente sea seguro revertirlas. |
| RF-052 | Implementado | Media | El sistema informa claramente estados de carga o guardado y bloquea acciones duplicadas durante operaciones asincronas. |
| RF-053 | Implementado | Media | El sistema muestra estados vacios especificos con acciones directas cuando existe una siguiente accion natural. |
| RF-054 | Implementado | Alta | El sistema diagnostica conflictos o validaciones complejas indicando la causa y la forma de corregir el dato. |
| RF-055 | Implementado | Baja | El sistema incluye ayuda contextual breve en operaciones sensibles como importacion, exportacion y borrado de datos. |

## Anexo B. Requisitos No Funcionales Integrados

| ID | Estado | Prioridad | Contenido importante |
| --- | --- | --- | --- |
| RNF-001 | Vigente | Alta | La aplicacion debe mantenerse como Flutter multiplataforma para Android, iOS, Web, Windows, Linux y macOS. |
| RNF-002 | Vigente | Alta | El proyecto debe usar una version de Dart compatible con la restriccion declarada en `pubspec.yaml`. |
| RNF-003 | Vigente | Alta | En Windows y Linux, la aplicacion debe inicializar SQLite FFI antes de abrir la base de datos. |
| RNF-004 | Vigente | Media | El codigo debe organizarse por funcionalidades dentro de `lib/features/`. |
| RNF-005 | Vigente | Media | Cada feature debe separar dominio, datos, repositorio y presentacion cuando aplique. |
| RNF-006 | Vigente | Media | Utilidades, temas, widgets comunes y base de datos deben ubicarse en `lib/core/`. |
| RNF-007 | Vigente | Alta | La logica de estado debe ser testeable sin depender de widgets, base real o servicios externos. |
| RNF-008 | Sugerido | Media | La UI no debe acceder directamente a DAOs o almacenamiento persistente. |
| RNF-009 | Implementado | Alta | La interfaz debe adaptarse a pantallas moviles y de escritorio. |
| RNF-010 | Implementado | Alta | La aplicacion debe usar Material 3 de forma consistente y soportar tema claro, oscuro y sistema. |
| RNF-011 | Vigente | Media | Las pantallas principales deben mostrar indicador durante carga de datos. |
| RNF-012 | Vigente | Media | Listas y calendarios deben mostrar estados vacios claros. |
| RNF-013 | Sugerido | Alta | Los mensajes de validacion deben ser claros, cercanos al campo y orientados a la accion. |
| RNF-014 | Vigente | Alta | Operaciones principales deben funcionar sin conexion de red. |
| RNF-015 | Vigente | Alta | Las fechas persistidas deben guardarse en formato ISO 8601. |
| RNF-016 | Vigente | Media | Los booleanos almacenados en SQLite deben representarse como 0 o 1. |
| RNF-017 | Sugerido | Alta | El sistema debe evitar persistir entidades incompletas o invalidas. |
| RNF-018 | Vigente | Alta | Las pruebas deben mantenerse organizadas por funcionalidad. |
| RNF-019 | Vigente | Media | Los modelos persistidos deben contar con pruebas de conversion objeto-mapa. |
| RNF-020 | Vigente | Media | Formularios y widgets principales deben probar renderizado, validacion y acciones clave. |
| RNF-021 | Sugerido | Alta | Reglas de negocio principales deben estar cubiertas por pruebas automatizadas. |
| RNF-022 | Sugerido | Alta | El sistema debe solicitar confirmacion antes de acciones destructivas. |
| RNF-023 | Implementado | Alta | Si falla persistencia local, el sistema debe informar al usuario y evitar estados inconsistentes. |
| RNF-024 | Sugerido | Media | El sistema no debe almacenar informacion sensible innecesaria en texto plano. |
| RNF-025 | Vigente | Media | El scheduler de notificaciones debe estar encapsulado y ser reemplazable. |
| RNF-026 | Vigente | Media | Las notificaciones no deben documentarse como completas mientras no exista implementacion nativa real. |
| RNF-027 | Sugerido | Alta | Los textos visibles deben mostrarse con codificacion correcta, sin mojibake ni caracteres corruptos en dialogs y pantallas criticas. |
| RNF-028 | Implementado | Alta | La interfaz debe permitir recuperacion de acciones frecuentes cuando exista una forma tecnica segura de revertirlas. |
| RNF-029 | Implementado | Media | La interfaz debe mostrar retroalimentacion durante operaciones asincronas y prevenir acciones duplicadas. |
| RNF-030 | Sugerido | Media | Formularios, dialogs y sheets deben mantener legibilidad y objetivos tactiles adecuados en pantallas estrechas y con texto escalado. |
| RNF-031 | Implementado | Media | Las acciones destructivas deben tener tratamiento visual consistente y diferenciable de acciones primarias no destructivas. |

## Anexo C. Casos de Prueba y Cobertura Integrados

La cobertura formal documentada contiene 77 casos de prueba distribuidos por
modulo. El contenido importante se resume asi:

| Area | Casos | Cobertura principal | Estado relevante |
| --- | ---: | --- | --- |
| Navegacion | 2 | Cambio entre modulos y conservacion de estado con navegacion Material 3. | Pass |
| Tareas | 16 | Carga, papelera, creacion, validacion, edicion, completar, restaurar, eliminar, clasificar, progreso, estadisticas, detalle, filtros y duplicados. | Pass |
| Horario | 10 | Carga, creacion semanal, validacion, solapamientos, vista semanal, lista diaria, edicion, eliminacion y recurrencia. | Pass, incluyendo confirmacion UI para eliminacion de clases. |
| Calendario y eventos | 14 | Carga, vista mensual, seleccion de fecha, eventos por dia, varios dias, creacion, validacion, edicion, eliminacion y superposiciones. | Pass |
| Configuracion y notificaciones | 16 | Preferencias, avisos, validaciones, tema, vista inicial, densidad, inicio de semana, confirmaciones, datos locales e informacion de app. | Pass; RF-043, RF-048 y RF-049 cuentan con evidencia automatizada y documentada. |
| Diseno Material 3 | 6 | Tema, navegacion adaptativa, tareas, formularios, ajustes, horario y calendario Material 3. | Pass |
| Interfaz de usuario | 5 | Consistencia visual, navegacion, responsividad, retroalimentacion y accesibilidad basica. | Executed with findings; reporte UI/UX registra hallazgos de botones, hover, layout desktop, calendario y borrado visual. |
| Usabilidad | 2 | Escenarios con usuarios reales, tiempos de ejecucion y retroalimentacion cualitativa. | Executed; 3 usuarios, 15 casos, promedio global 17.94 s y 10 hallazgos colectivos. |
| Persistencia y modelos | 6 | Serializacion de entidades, migracion, SQLite escritorio y error visible de persistencia. | Pass, incluyendo migracion y smoke test FFI de escritorio. |

Seguimiento de cobertura:

| Area | Brecha | Caso relacionado |
| --- | --- | --- |
| Tareas | Sin brecha abierta para duplicados exactos; TC-TAR-016 automatizado. | TC-TAR-016 |
| Horario | Sin brecha abierta; confirmacion UI al eliminar clases cubierta. | TC-HOR-008 |
| Configuracion | Sin brecha abierta para RF-048; confirmaciones y recuperacion/deshacer cubiertas. | TC-CONF-012 |
| Gestion de datos | Sin brecha abierta para RF-049; importacion/exportacion y borrado con `BORRAR` cubiertos. | TC-CONF-013 |
| Persistencia | Sin brecha abierta; migracion SQLite automatizada. | TC-PER-004 |
| Escritorio | Sin brecha abierta; smoke test SQLite FFI automatizado. | TC-PER-005 |
| Interfaz | Hallazgos abiertos de botones, hover, layout desktop, calendario y simetria en horario. | TC-UI-003, TC-UI-004, TC-M3-002 |
| Accesibilidad | Cobertura basica; falta auditoria WCAG completa. | TC-UI-005 |
| Usabilidad | Sesiones con usuarios reales ejecutadas; quedan acciones de remediacion UI/UX y eventual re-prueba. | TC-US-001, TC-US-002 |

## Anexo D. Evidencia TDD y Mejoras Integradas

La evidencia Red-Green-Refactor usada por este SVVP no se limita a citar
archivos; su contenido clave es:

| Ciclo | Alcance extraido | Resultado importante |
| --- | --- | --- |
| Eventos de Calendario | RF-030, RF-031, RF-032 y reglas RN-036 a RN-046: crear, editar, eliminar, validar rangos, normalizar texto, color por defecto y superposiciones. | Suite de calendario en verde; se separo `EventoValidator`, `EventoForm` y `EventoListItem`. |
| Validaciones de Tareas y Clases | RF-006, RF-007 y RF-019: titulo/materia obligatorios, longitudes, normalizacion, fechas pasadas, duplicados exactos, rango horario y solapamientos. | Pruebas focalizadas en verde para las validaciones implementadas. |
| Tareas, Configuracion y Robustez | RF-011, RF-016, RF-033 y RF-037: eliminacion definitiva, filtrado, superposiciones y validacion de preferencias. | Suite completa en verde; se reforzo robustez y estados visibles. |
| Diseno Material 3 | Tema, navegacion adaptativa, filtros, formularios, ajustes y componentes Material 3. | UI consistente con Material 3 y pruebas especificas de diseño. |
| Horario Material 3 | Vista semanal/dia, panel diario, tarjetas de clase, chips y estado vacio. | Pantalla Horario validada con widgets y componentes responsive. |
| Calendario Material 3 | Vista mensual/dia, panel diario, tarjetas de evento, chips y estado vacio. | Pantalla Calendario validada con comportamiento responsive. |
| Ajustes avanzados Material 3 | RF-043 a RF-055: aviso de eventos, tema, vista inicial, densidad, inicio de semana, confirmaciones, gestion de datos, informacion, recuperacion, estados de carga, estados vacios, diagnostico y ayuda contextual. | RF-043 a RF-055 completos; reporte UI/UX agrega hallazgo de refresco visual tras borrado local. |

## Anexo E. Arquitectura y Flujo de Datos Integrados

Agenda usa organizacion feature-first:

- `lib/features/tareas/`: modelo `Tarea`, DAOs, repositorio, controlador y UI
  para tareas, papelera, progreso y filtros.
- `lib/features/horario/`: modelo `Clase`, DAO, repositorio, controller,
  vistas mobile/desktop y widgets para clases.
- `lib/features/calendario/`: modelo `Evento`, validador, DAO, repositorio,
  controller, vistas mobile/desktop y formularios/listas de eventos.
- `lib/features/configuracion/`: helper de preferencias, controller,
  configuracion de notificaciones y ajustes avanzados.
- `lib/features/navegacion/`: navegacion adaptativa con barra inferior,
  `NavigationRail` e `IndexedStack`.
- `lib/core/`: base SQLite, tema, utilidades, scheduler reemplazable y widgets
  compartidos.

Flujo general de datos:

```text
Widgets de presentacion
  -> Controller de la feature
  -> Repositorio
  -> DAO o helper de preferencias
  -> SQLite local / SharedPreferences
```

Decisiones arquitectonicas relevantes para V&V:

- Los controllers se pueden probar con repositorios falsos o dobles de prueba.
- Los modelos principales se serializan a mapas compatibles con SQLite.
- La base local `agenda.db` tiene version documentada y migraciones.
- Firebase fue retirado del proyecto; no forma parte del alcance de V&V ni del
  build actual.
- El scheduler de notificaciones esta encapsulado para permitir reemplazo y usa
  backend nativo con fallback seguro en entornos sin plugin registrado.
