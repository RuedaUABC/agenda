# Primer borrador del reporte final de V&V - Agenda

> Borrador sin portada. Este documento integra la informacion disponible en la
> documentacion tecnica del proyecto Agenda y marca como `[PENDIENTE]` los
> elementos que requieren datos reales, mediciones finales, encuestas o
> conclusiones individuales.

## Project specifications

Agenda es una aplicacion Flutter multiplataforma para organizar tareas,
horarios de clases, eventos de calendario y preferencias de notificacion. El
sistema esta orientado a usuarios academicos o personales que necesitan
centralizar compromisos, actividades, clases y avisos en una herramienta local,
responsiva y usable en escritorio y dispositivos moviles.

El proyecto se implementa con una arquitectura feature-first. El codigo se
organiza por funcionalidades dentro de `lib/features/` y separa, cuando aplica,
dominio, acceso a datos, repositorios y presentacion. Las piezas compartidas se
mantienen en `lib/core/`, incluyendo base de datos, tema visual, utilidades y
widgets reutilizables.

El sistema cuenta con los siguientes modulos principales:

- Tareas: creacion, edicion, eliminacion logica, papelera, restauracion,
  eliminacion definitiva, clasificacion, progreso diario y estadisticas
  semanales.
- Horario: gestion de clases, recurrencia semanal, vista semanal, lista por dia,
  validacion de rangos y deteccion de conflictos.
- Calendario: gestion de eventos, vista mensual, lista diaria, eventos de varios
  dias, creacion, edicion, eliminacion y advertencia por superposiciones.
- Configuracion: preferencias de recordatorios, tema visual, vista inicial,
  densidad visual, inicio de semana, confirmaciones y gestion nativa de datos
  locales.
- Navegacion: navegacion adaptativa con barra inferior en movil y
  `NavigationRail` en pantallas medianas o grandes.

La persistencia principal usa SQLite local mediante `sqflite`; en Windows y
Linux se inicializa `sqflite_common_ffi`. Tambien se usa `shared_preferences`
para preferencias. Firebase fue retirado del proyecto y no debe considerarse
dependencia activa de compilacion o ejecucion.

El desarrollo y las pruebas respetan principios de verificacion y validacion
desde etapas tempranas. Existen requisitos documentados, casos de uso, reglas de
negocio, matriz de trazabilidad, casos de prueba, pruebas automatizadas por
feature y evidencia TDD mediante ciclos Red-Green-Refactor.

## Mission, vision and scope of the system

### Mission

[PENDIENTE] Redactar mision formal validada por el equipo.

Propuesta inicial: Agenda tiene como mision ayudar a los usuarios a organizar
sus actividades academicas y personales mediante una aplicacion local,
multiplataforma y facil de usar, que permita consultar tareas, clases, eventos y
preferencias de notificacion desde una experiencia consistente.

### Vision

[PENDIENTE] Redactar vision formal validada por el equipo.

Propuesta inicial: Agenda busca convertirse en una herramienta confiable para la
gestion diaria de compromisos academicos, integrando tareas, horario, calendario
y configuracion personalizada en una sola aplicacion mantenible, testeable y
adaptable a distintos dispositivos.

### Scope

El alcance actual del sistema incluye:

- Gestion local de tareas con clasificacion por vencidas, pendientes de la
  semana, proximas y completadas.
- Papelera de tareas con restauracion y eliminacion definitiva.
- Gestion de clases recurrentes semanales.
- Consulta de horario semanal y lista de clases por dia.
- Gestion de eventos de calendario, incluyendo eventos de varios dias.
- Validaciones de formularios para tareas, clases y eventos.
- Preferencias locales de avisos, tema, vista inicial, densidad visual e inicio
  de semana.
- Persistencia local offline con SQLite y preferencias locales.
- Interfaz responsive con lineamientos Material 3.

Quedan fuera o parcialmente fuera del alcance actual:

- Servicios externos de autenticacion o sincronizacion, incluido Firebase.
- Validacion estadistica con usuarios reales mediante PSSUQ.
- Certificacion externa o auditoria formal del producto.

## Software Requirements Specification (SRS)

### Inquiry method

Los requisitos fueron extraidos por ingenieria inversa a partir del codigo, las
pantallas, controllers, repositorios, modelos y pruebas automatizadas. Las
fuentes revisadas incluyen `lib/main.dart`, `lib/core/`, `lib/features/`,
`test/features/` y `test/widget_test.dart`.

Complementado con pruebas fisicas UI/UX ejecutadas el 2026-05-27 con Juan,
Ariel y Marcos, registradas en `Reporte de Pruebas de Interfaz y Usabilidad.pdf`.

### Functional requirements

El proyecto cuenta con 55 requisitos funcionales documentados en formato
estructurado en `docs/requerimientos/requerimientos_funcionales_formato.md`.
Cada RF se expresa con actor, accion, objeto de accion, datos de entrada,
resultado esperado, prioridad, estado y forma de verificacion. La cobertura
principal por modulo es:

- RF-001 a RF-002: navegacion principal y conservacion de estado entre modulos.
- RF-003 a RF-016: tareas, papelera, clasificacion, progreso, estadisticas,
  detalle y filtrado.
- RF-017 a RF-024: horario, clases semanales, validaciones, recurrencia, vista
  semanal y lista por dia.
- RF-025 a RF-033: calendario, eventos, seleccion de fecha, listas diarias,
  creacion, edicion, eliminacion y superposiciones.
- RF-034 a RF-039: preferencias de notificacion para clases y tareas.
- RF-040 a RF-042: persistencia local, migraciones y soporte SQLite en
  escritorio.
- RF-043 a RF-050: ajustes avanzados, aviso de eventos, tema, vista inicial,
  densidad, inicio de semana, confirmaciones, gestion de datos e informacion de
  la aplicacion.
- RF-051 a RF-055: recuperacion de acciones, estados de carga, estados vacios,
  diagnostico de validaciones complejas y ayuda contextual.

Los 55 RF del formato estructurado se encuentran en estado Implementado. RF-043
se documenta como implementado con cobertura automatizada para scheduler nativo
de eventos. RF-048 y RF-049 estan implementados con confirmaciones, archivo
nativo, importacion/exportacion y borrado reforzado mediante `BORRAR`.

### Non-functional requirements

Los requisitos no funcionales cubren plataforma, arquitectura, mantenibilidad,
usabilidad, datos, calidad, seguridad local, robustez y notificaciones. Entre
los mas relevantes:

- Compatibilidad Flutter multiplataforma: Android, iOS, Web, Windows, Linux y
  macOS.
- Compatibilidad con SDK Dart segun `pubspec.yaml`.
- Soporte SQLite en escritorio mediante FFI.
- Organizacion feature-first y separacion por capas.
- Componentes compartidos en `lib/core/`.
- Logica de estado testeable con controllers y repositorios reemplazables.
- Diseno responsivo y Material 3 consistente.
- Estados vacios, indicadores de carga y mensajes de validacion comprensibles.
- Persistencia offline, fechas ISO 8601 y booleanos SQLite como `0`/`1`.
- Pruebas automatizadas por funcionalidad, serializacion y widgets criticos.
- Confirmacion para acciones destructivas.
- Manejo visible de errores de persistencia.
- Scheduler de notificaciones encapsulado y reemplazable.

La verificacion documental y tecnica realizada el 2026-05-28 indica que la
mayoria de los RNF estan cubiertos para el alcance actual. De 31 RNF
documentados en `docs/requerimientos/requerimientos_no_funcionales_formato.md`,
28 se consideran implementados, vigentes con evidencia suficiente o cumplidos
para el producto actual. Tres RNF requieren cierre adicional o evidencia mas
fuerte:

| RNF | Estado actualizado | Justificacion |
| --- | --- | --- |
| RNF-008 | Parcial | La UI opera principalmente mediante controllers y repositorios, pero algunas pantallas aun instancian DAOs o repositorios concretos dentro de `presentation/`. |
| RNF-017 | Parcial | Hay validaciones en formularios y dominio de eventos, pero falta reforzar integridad en todas las rutas de dominio/persistencia. |
| RNF-030 | Parcial | Existe layout responsivo y densidad visual, pero falta evidencia especifica con anchos estrechos y texto escalado. |

RNF-021 se actualiza como implementado, ya que existen pruebas automatizadas
para clasificacion de tareas, estadisticas semanales, recurrencia semanal,
solapamientos de horario/eventos y seleccion de fecha.

### Requirement quality evaluation

Los requisitos funcionales y no funcionales se encuentran identificados con ID
unico, prioridad, estado, resultado esperado y verificacion en los documentos
con formato estructurado. La matriz de trazabilidad relaciona requisitos con
casos de uso, reglas de negocio, pruebas y evidencia tecnica.

Evaluacion general:

- Atomicidad: la mayoria de los RF describen una capacidad especifica.
- Claridad: los RF usan lenguaje orientado a comportamiento esperado.
- Factibilidad: los RF implementados tienen evidencia en codigo o pruebas.
- Testabilidad: los RF estan vinculados a casos de prueba o evidencia tecnica.
- Trazabilidad: existe matriz principal para RF y RNF.

[PENDIENTE] Incluir una tabla formal de evaluacion individual para al menos 20
RF con atributos: atomico, conciso, completo, factible, testeable, no ambiguo y
trazable.

### Requirement validation

La validacion actual se apoya en casos de uso, reglas de negocio, pruebas de
widgets, pruebas unitarias, pruebas de controllers, pruebas de serializacion y
evidencia TDD. Los casos de prueba documentan precondiciones, pasos, datos,
resultado esperado, resultado actual, estado, requisito asociado y prioridad.

La validacion con usuarios reales ya cuenta con pruebas UI/UX fisicas del
2026-05-27. Para cumplir la plantilla de satisfaccion, queda pendiente aplicar
PSSUQ sobre al menos 5 requisitos funcionales, seleccionar una muestra
estadisticamente valida, registrar respuestas y hacer tratamiento estadistico.

## Planning phase

### Verification and Validation Plan

#### Purpose

El Plan de Verificacion y Validacion define las actividades, tecnicas,
responsabilidades, recursos, criterios de aceptacion y reportes necesarios para
asegurar que Agenda cumpla sus requisitos especificados y satisfaga necesidades
basicas de organizacion de tareas, clases, eventos y preferencias del usuario.

Sus objetivos son:

- Verificar que los artefactos de requisitos, diseno, codigo y pruebas sean
  consistentes, completos y mantenibles.
- Validar que las funcionalidades principales funcionen de acuerdo con los
  flujos esperados.
- Detectar defectos de forma temprana mediante revisiones, analisis estatico,
  pruebas automatizadas y pruebas funcionales.
- Mantener trazabilidad entre requisitos, casos de uso, reglas de negocio,
  pruebas y evidencia tecnica.

#### Scope

El alcance del Plan de V&V cubre:

- Revision de requisitos funcionales y no funcionales.
- Revision de arquitectura, separacion por capas y flujo de datos.
- Verificacion de reglas de negocio y validaciones.
- Pruebas unitarias, de widgets, de controllers y de serializacion.
- Pruebas por modulo: tareas, horario, calendario, configuracion, navegacion,
  Material 3 y persistencia.
- Analisis de defectos y brechas documentadas.
- Elaboracion de reportes, metricas y recomendaciones.

Quedan fuera del plan:

- Certificacion externa del producto.
- Auditoria formal de procesos organizacionales.
- Certificacion externa de entrega de notificaciones por cada sistema operativo.
- Pruebas estadisticas PSSUQ hasta contar con usuarios y datos reales.

#### References and related documents

- IEEE 1012 - Standard for System and Software Verification and Validation.
- ISO/IEC 12207 - Systems and software engineering - Software life cycle
  processes.
- `docs/requerimientos/requerimientos_funcionales_formato.md`.
- `docs/requerimientos/requerimientos_no_funcionales_formato.md`.
- `docs/requerimientos/casos_de_uso.md`.
- `docs/requerimientos/reglas_de_negocio.md`.
- `docs/requerimientos/trazabilidad.md`.
- `docs/arquitectura.md`.
- `docs/casos_prueba.md`.
- `docs/pruebas.md`.
- `docs/desarrollo.md`.
- `docs/diseno_material3.md`.
- Archivos `docs/red_green_refactor_*.md`.

#### Definitions and acronyms

- V&V: Verificacion y Validacion.
- SVVP: Software Verification and Validation Plan.
- SVVR: Software Verification and Validation Report.
- RF: Requisito funcional.
- RNF: Requisito no funcional.
- RN: Regla de negocio.
- CU: Caso de uso.
- QA: Aseguramiento de calidad.
- Defecto: no conformidad del sistema respecto a un requisito o expectativa
  razonable.
- Incidencia: registro formal de un defecto, brecha o problema.
- TDD: Test-Driven Development.

#### General system description

Agenda es una aplicacion de criticidad media: no gestiona operaciones
financieras ni datos clinicos, pero sus fallas pueden afectar la organizacion
diaria del usuario. Por ello se priorizan integridad de datos locales,
validaciones claras, consistencia de UI, persistencia offline y recuperacion
ante errores de almacenamiento.

#### V&V organization

Roles propuestos:

- Responsable de V&V: define estrategia, mantiene trazabilidad, consolida
  resultados y emite conclusiones.
- Responsable de QA: revisa cumplimiento del proceso y criterios de aceptacion.
- Desarrolladores: implementan funcionalidad, pruebas unitarias, pruebas de
  widgets y correcciones.
- Ingenieros de prueba: disenan casos de prueba, ejecutan suites, registran
  resultados y reportan defectos.
- Usuario representante: valida flujos funcionales y usabilidad.

[PENDIENTE] Registrar nombres reales de responsables, revisores y aprobadores.

#### Independence of V&V

Cuando sea posible, las revisiones de requisitos, diseno y pruebas de aceptacion
deben ser realizadas por una persona distinta a quien implemento el cambio. En
el contexto del proyecto academico, la independencia puede lograrse mediante
revision cruzada entre integrantes.

#### V&V strategy by lifecycle phase

Fase de requisitos:

- Revisar RF, RNF, CU y RN para detectar ambiguedades, omisiones o conflictos.
- Verificar que cada requisito tenga ID, prioridad, estado y evidencia.
- Mantener matriz de trazabilidad requisito-caso-prueba-evidencia.
- Entregables: informe de revision de requisitos y matriz de trazabilidad.

Fase de diseno:

- Revisar arquitectura feature-first y separacion por capas.
- Verificar que UI, controllers, repositorios y DAOs mantengan bajo
  acoplamiento.
- Validar diseno responsive y consistencia Material 3.
- Entregables: informe de revision de diseno y plan de pruebas del sistema.

Fase de implementacion:

- Aplicar TDD en funcionalidades seleccionadas.
- Ejecutar revisiones de codigo y analisis estatico.
- Mantener pruebas unitarias, de widgets y serializacion.
- Entregables: reportes de pruebas unitarias, evidencia Red-Green-Refactor y
  resultados de analisis.

Fase de integracion y sistema:

- Ejecutar pruebas por feature y suite completa.
- Verificar flujos entre navegacion, tareas, horario, calendario y ajustes.
- Revisar persistencia local y comportamiento offline.
- Entregables: informe de pruebas de integracion y sistema.

Fase de aceptacion:

- Ejecutar pruebas funcionales con usuarios representativos.
- Aplicar PSSUQ a requisitos seleccionados.
- Registrar defectos, acciones pendientes y aceptacion final.
- Entregables: informe de aceptacion, acta o lista de pendientes.

#### Methods and techniques

Tecnicas estaticas:

- Inspeccion de requisitos.
- Revision de arquitectura.
- Revision de matriz de trazabilidad.
- Peer review de codigo.
- Analisis estatico con `flutter analyze`.

Tecnicas dinamicas:

- Pruebas unitarias.
- Pruebas de widgets.
- Pruebas de controllers.
- Pruebas de serializacion.
- Pruebas funcionales por modulo.
- Pruebas manuales de aceptacion.
- Pruebas de usabilidad con PSSUQ.

#### Acceptance criteria

Criterios iniciales:

- La suite `flutter test` debe ejecutarse sin fallos antes de entregar.
- Los casos de prueba de prioridad alta deben estar en estado Pass o tener una
  justificacion documentada.
- Los RF implementados deben tener evidencia en codigo, prueba o documento.
- Los requisitos parciales no deben documentarse como completos.
- No deben existir defectos criticos abiertos en tareas, horario, calendario,
  configuracion, navegacion o persistencia.
- Las brechas conocidas deben aparecer como acciones pendientes.

#### Planning and schedule

Hitos propuestos:

- H1: aprobacion de requisitos y reglas de negocio.
- H2: aprobacion de arquitectura y diseno Material 3.
- H3: fin de implementacion principal de tareas, horario, calendario y ajustes.
- H4: ejecucion de pruebas automatizadas y revision de trazabilidad.
- H5: pruebas de aceptacion, PSSUQ y decision de entrega.

[PENDIENTE] Agregar fechas reales del proyecto y responsables por hito.

#### Resources, tools and environments

Recursos humanos:

- Desarrolladores del proyecto.
- Responsable de V&V.
- Responsable de QA.
- Usuarios participantes para aceptacion.

Herramientas:

- Flutter y Dart.
- `flutter test`.
- `flutter analyze`.
- SQLite / `sqflite`.
- `sqflite_common_ffi`.
- `shared_preferences`.
- Syncfusion Flutter Calendar.
- Git y GitHub para control de versiones.

Ambientes:

- Ambiente local de desarrollo.
- Ambiente de pruebas automatizadas.
- Ambiente de escritorio Windows/Linux para SQLite FFI.
- Dispositivo fisico usado para validacion real: Samsung Galaxy S23+.

#### Configuration management and change control

Los artefactos de requisitos, arquitectura, pruebas y evidencia se mantienen en
`docs/`. El codigo fuente y pruebas estan bajo control de versiones. Todo cambio
en requisitos debe reflejarse en:

- Documento de requisitos afectado.
- Casos de uso o reglas de negocio si aplica.
- Matriz de trazabilidad.
- Casos de prueba.
- Pruebas automatizadas o evidencia tecnica.

#### Defect management

Flujo propuesto:

1. Detectar defecto mediante prueba, revision o uso manual.
2. Registrar ID, descripcion, severidad, prioridad, modulo afectado, pasos de
   reproduccion, resultado esperado y resultado obtenido.
3. Clasificar por origen: requisitos, diseno, codificacion, interfaz, datos,
   configuracion o pruebas.
4. Asignar responsable.
5. Corregir y verificar.
6. Ejecutar regresion cuando aplique.
7. Cerrar con causa raiz y evidencia.

#### Cause analysis

Para defectos recurrentes se usara diagrama de Ishikawa con categorias:

- Personas.
- Metodos/procesos.
- Herramientas.
- Datos.
- Requisitos.
- Gestion/organizacion.

Tambien se propone usar Pareto agrupando defectos por categoria, calculando
frecuencia relativa, porcentaje acumulado e identificando las causas vitales.

#### V&V metrics and reports

Metricas propuestas:

- Numero de defectos por severidad.
- Numero de defectos por fase de deteccion.
- Defectos por modulo.
- Cobertura de requisitos por casos de prueba.
- Porcentaje de casos Pass, Partial y Not Executed.
- Cobertura de pruebas automatizadas por feature.
- Tiempo medio de resolucion de defectos, cuando existan fechas de apertura y
  cierre.

Reportes:

- Informe de revision de requisitos.
- Informe de revision de diseno.
- Informe de pruebas unitarias/widgets.
- Informe de pruebas de integracion y sistema.
- Informe de pruebas integradas UI/UX con usuarios reales.
- Informe de defectos.
- SVVR: informe global de V&V con conclusiones de aceptabilidad.

#### V&V risks and mitigation

Riesgos:

- Cambios frecuentes en requisitos o comportamiento esperado.
- Hallazgos UI/UX abiertos despues de pruebas con usuarios reales.
- Falta de datos representativos para pruebas.
- Regresiones en integraciones nativas de notificaciones, archivos o SQLite FFI.

Mitigacion:

- Mantener trazabilidad actualizada.
- Usar pruebas automatizadas por feature.
- Registrar pendientes sin presentarlos como completos.
- Aplicar el plan de remediacion UI/UX y repetir escenarios criticos.
- Generar datos de prueba representativos.

#### Approval

[PENDIENTE] Agregar aprobacion formal:

- Responsable de V&V.
- Responsable de QA.
- Jefe de proyecto o patrocinador.

## Execution phase

### Verification activities

#### Requirements verification

Se verificaron requisitos mediante revision documental de RF, RNF, CU, reglas de
negocio y matriz de trazabilidad. La documentacion permite rastrear cada RF
hacia su caso de uso, regla relacionada, prueba o evidencia tecnica. Para la
revision de requisitos se toma como fuente principal el formato estructurado,
porque explicita actor, accion, objeto, entrada, resultado esperado, prioridad,
estado y verificacion.

Evidencia:

- `docs/requerimientos/requerimientos_funcionales_formato.md`.
- `docs/requerimientos/requerimientos_no_funcionales_formato.md`.
- `docs/requerimientos/casos_de_uso.md`.
- `docs/requerimientos/reglas_de_negocio.md`.
- `docs/requerimientos/trazabilidad.md`.

#### Analysis verification

Los casos de uso cubren flujos principales y alternativos para navegacion,
tareas, papelera, progreso, horario, calendario y configuracion. Las reglas de
negocio detallan validaciones y comportamiento esperado sin depender de la
tecnologia.

#### Design verification

La arquitectura se verifico contra la organizacion feature-first:

- `domain/` para modelos.
- `data/` para DAOs.
- `repository/` para contratos e implementaciones.
- `presentation/` para widgets, controllers y adaptadores.
- `core/` para elementos transversales.

Tambien se verifico la separacion de responsabilidades en calendario mediante
`EventoValidator`, `EventoForm`, `EventoListItem` y `CalendarioController`.

#### Coding verification

La verificacion de codigo se apoya en:

- Pruebas automatizadas por feature.
- Pruebas de widgets para formularios y pantallas.
- Pruebas de controllers con repositorios falsos o dobles de prueba.
- Pruebas de serializacion de modelos.
- Evidencia TDD Red-Green-Refactor.
- Analisis estatico ejecutado con `flutter analyze`.

Resultados actuales de verificacion automatizada:

- `flutter analyze`: sin issues.
- `flutter test`: 138 pruebas aprobadas, 0 fallidas.

Evidencia TDD documentada, con citas legibles:

- Eventos de calendario: RF-030, RF-031, RF-032 y reglas RN-036 a RN-046.
- Validaciones de tareas y clases: RF-006, RF-019 y reglas asociadas.
- Tareas, configuracion y robustez: RF-011, RF-016, RF-033 y RF-037.
- Ajustes avanzados Material 3: RF-043 a RF-050.
- Refinamientos Material 3 de calendario, horario y diseno general.

| Ciclo | Evidencia Red | Evidencia Green / Refactor |
| --- | --- | --- |
| Eventos de calendario | La bitacora `red_green_refactor_eventos.md` registra pruebas nuevas para titulo obligatorio, rango de fechas, evento puntual, normalizacion, color por defecto, superposiciones, creacion, edicion y eliminacion con confirmacion. | Green implemento `EventoValidator`, `EventoForm`, `EventoListItem` y callbacks de crear/editar/eliminar. Refactor separo reglas de negocio del widget y dejo el formulario sin dependencia de DAO/repositorio. |
| Validaciones de tareas y clases | `red_green_refactor_validaciones.md` documenta pruebas para titulos solo con espacios, longitudes maximas, fechas pasadas, duplicados exactos y clases solapadas. | Green agrego reloj inyectable, normalizacion con `trim()`, bloqueo de duplicados y validacion de solapamientos. El resultado fueron pruebas focalizadas en verde. |
| Tareas, configuracion y robustez | `red_green_refactor_tareas_configuracion_robustez.md` agrega pruebas para borrado definitivo, filtros, error visible, superposiciones como advertencia y preferencias invalidas. | Green agrego borrado fisico, `lastError`, snackbars, advertencias y validacion centralizada en `PreferencesHelper`; la suite completa quedo en verde. |
| Material 3 | Las bitacoras de Material 3 agregan pruebas para tema, navegacion adaptativa, `SegmentedButton`, paneles diarios, estados vacios, metadatos y ajustes avanzados. | Green incorporo `AgendaNavigation`, paneles reutilizables, tarjetas Material 3, `AdvancedSettingsWidget` y aplicacion real de preferencias. Las verificaciones finales reportan `flutter analyze` sin issues y suites en verde. |
| Recuperacion y feedback | `red_green_refactor_recuperacion_confirmaciones.md` exige `BORRAR`, `Deshacer`, estados `Guardando...`, bloqueo de taps duplicados y conflictos explicativos. | Green agrego confirmacion reforzada, `SnackBarAction`, estados de progreso, estados vacios accionables y omision de recordatorios no futuros. La verificacion focalizada termino con `All tests passed`. |

### Validation activities

#### Requirements validation

Los requisitos se validaron contra casos de uso, reglas de negocio y pruebas
automatizadas. Ademas, se ejecutaron pruebas fisicas UI/UX el 2026-05-27 con
tres usuarios reales, Juan, Ariel y Marcos. Queda pendiente aplicar PSSUQ formal
y tratamiento estadistico.

[PENDIENTE] Aplicar PSSUQ a por lo menos 5 RF. Candidatos sugeridos:

- RF-005: creacion de tareas.
- RF-018: creacion de clases semanales.
- RF-026/RF-028: consulta de calendario y lista diaria.
- RF-030: creacion de eventos.
- RF-034/RF-044: configuracion de preferencias y tema visual.

#### Analysis validation

Los flujos principales reflejan operaciones reales del usuario: navegar, crear
tareas, gestionar tareas, consultar progreso, crear clases, consultar horario,
consultar calendario, crear/editar eventos y configurar preferencias.

#### Design validation

La validacion de diseno se apoya en pruebas Material 3 que verifican navegacion
adaptativa, formularios, ajustes, calendario, horario, estados vacios, tarjetas,
chips y controles segmentados.

#### Coding validation

Los modulos principales cuentan con pruebas automatizadas:

- Tareas: carga, creacion, actualizacion, papelera, restauracion, eliminacion,
  clasificacion, progreso, estadisticas, filtros y validaciones.
- Horario: carga, creacion, actualizacion, eliminacion, recurrencia, mapeo de
  dias, conflictos y widgets.
- Calendario: carga, eventos, seleccion de fecha, formularios, validaciones,
  edicion, eliminacion y superposiciones.
- Configuracion: preferencias, valores por defecto, validaciones, reprogramacion,
  tema, vista inicial, densidad, inicio de semana y gestion nativa de datos.
- Diseno Material 3: tema, navegacion, formularios, tarjetas, paneles diarios y
  ajustes.
- Persistencia/modelos: serializacion de Tarea, Evento y Clase.

#### Execution sample by development phase

La ejecucion del plan considero una muestra de artefactos por fase. En codigo
fuente se considero toda la suite automatizada disponible.

| Fase | Muestra evaluada | Hallazgos | Estado |
| --- | --- | --- | --- |
| Requisitos | 55 RF, 31 RNF, casos de uso, reglas de negocio y trazabilidad. | RNF-008, RNF-017 y RNF-030 requieren evidencia adicional o cierre posterior. | Parcial documentado. |
| Analisis | Flujos principales y alternativos de tareas, horario, calendario y configuracion. | Riesgo de expectativas de usuario no capturadas por pruebas automatizadas. | Mitigado con pruebas UI/UX. |
| Diseno | Arquitectura feature-first, Material 3, navegacion y pantallas principales. | 10 hallazgos UI/UX de botones, hover, layout, formularios, calendario y borrado visual. | Abierto con acciones correctivas. |
| Codigo | Todo `lib/` mediante analisis estatico y toda la suite `test/`. | 0 issues de analisis, 0 pruebas fallidas. | Cerrado para el alcance actual. |
| Integracion/sistema | Persistencia SQLite, preferencias, notificaciones, archivos nativos y navegacion. | Riesgos previos en scheduler, FFI, migracion, duplicados y confirmaciones. | Cerrados con pruebas automatizadas. |
| Aceptacion | 15 casos UI/UX con usuarios reales en Samsung Galaxy S23+. | 15 casos exitosos o exitosos con alerta; 10 hallazgos colectivos. | Aceptado funcionalmente con remediaciones UI/UX pendientes. |

### Quantitative evaluation: Metrics

Metricas disponibles desde la documentacion:

- 55 requisitos funcionales documentados.
- 31 requisitos no funcionales organizados en plataforma, arquitectura,
  usabilidad, datos, calidad, robustez y notificaciones.
- 28 RNF implementados, vigentes con evidencia suficiente o cumplidos para el
  alcance actual.
- 3 RNF parciales o pendientes de evidencia final: RNF-008, RNF-017 y RNF-030.
- Casos de prueba por modulo con estado Pass, Partial o Not Executed.
- Pruebas UI/UX fisicas ejecutadas el 2026-05-27 con Juan, Ariel y Marcos:
  15 casos exitosos o exitosos con alerta, promedio global 17.94 s y 10
  hallazgos colectivos.
- Suites automatizadas recomendadas por feature.
- RF-043 cerrado como implementado.
- RF-048 y RF-049 cerrados como implementados con confirmaciones,
  recuperacion/deshacer y borrado reforzado mediante `BORRAR`.
- Pruebas agregadas para confirmacion de eliminacion de clases,
  selector/escritura de archivo nativo, scheduler nativo de eventos, migracion
  SQLite y smoke test FFI de escritorio.
- Pruebas agregadas para rechazo de tareas duplicadas exactas normalizadas en
  creacion y edicion.
- `flutter analyze` ejecutado el 2026-05-28: sin issues.
- `flutter test` ejecutado el 2026-05-28: 138 pruebas aprobadas, 0 fallidas.

| Comando | Resultado | Pruebas aprobadas | Fallidas | Observacion |
| --- | --- | ---: | ---: | --- |
| `flutter analyze` | Pass | N/A | 0 | No issues found. |
| `flutter test` | Pass | 138 | 0 | Suite automatizada completa en verde. |

### Quality level achieved

El nivel de calidad logrado se clasifica como **Bueno**. La decision se basa en
que la suite automatizada esta completa y en verde, los RF principales tienen
trazabilidad, no existen defectos criticos abiertos y las brechas detectadas
estan documentadas con acciones de mejora.

No se clasifica como Excelente porque permanecen hallazgos UI/UX abiertos,
accesibilidad solo basica y acciones de remediacion pendientes despues de las
pruebas con usuarios.

### Data Analysis and Interpretation

Con la evidencia existente, el sistema presenta una base solida de calidad para
funcionalidades principales. La mayor parte del comportamiento critico cuenta
con pruebas automatizadas y trazabilidad. Los modulos de tareas, horario y
calendario tienen validaciones especificas y pruebas de UI o controller. La
configuracion avanzada muestra cobertura amplia, incluyendo notificaciones
nativas, confirmacion de clases y manejo nativo de archivos.

La revision de RNF muestra que el proyecto ya cumple la mayoria de atributos de
calidad documentados. Las brechas restantes se concentran en tres frentes:
reducir acoplamiento residual entre presentacion y dependencias concretas,
reforzar integridad en capas no visuales y generar evidencia especifica de
robustez responsiva con texto escalado.

Interpretacion preliminar:

- Usabilidad: la interfaz Material 3, los estados vacios, la navegacion
  adaptativa y los controles segmentados mejoran claridad y consistencia.
- Confiabilidad: la persistencia local y pruebas de serializacion reducen riesgo
  de perdida o corrupcion de datos basicos.
- Mantenibilidad: la arquitectura feature-first y separacion por capas facilitan
  pruebas y cambios.
- Robustez: el manejo visible de errores, confirmaciones y fallbacks nativos
  reduce acciones accidentales y riesgos de plataforma.

[PENDIENTE] Integrar resultados de PSSUQ y analisis estadistico para mapear los
datos recolectados a atributos de usabilidad.

## Problems traceability phase

### Failures and defects report

Defectos o brechas conocidas:

| ID | Area | Descripcion | Estado | Sugerencia |
| --- | --- | --- | --- | --- |
| DEF-001 | Notificaciones | Scheduler nativo de eventos integrado con fallback testeable. | Cerrado | Mantener regresion automatizada. |
| DEF-002 | Configuracion | Confirmaciones configurables cubren eliminacion visible de clases. | Cerrado | Mantener prueba widget. |
| DEF-003 | Gestion de datos | Exportacion/importacion usa selector/escritura nativa de archivo. | Cerrado | Mantener servicio inyectable y fake de pruebas. |
| DEF-004 | Persistencia | Migracion SQLite cubierta por prueba automatizada dedicada. | Cerrado | Mantener test con `sqflite_common_ffi`. |
| DEF-005 | Plataforma | Smoke test automatizado de SQLite FFI para escritorio agregado. | Cerrado | Ejecutar en CI Windows/Linux. |
| DEF-006 | Tareas | Duplicados exactos de tareas no se bloqueaban al crear o editar. | Cerrado | Mantener TC-TAR-016 en regresion. |
| DEF-007 | Usabilidad | Falta PSSUQ con usuarios reales. | Pendiente | Planear muestra, ejecutar cuestionario y analizar resultados. |
| DEF-008 | RNF | RNF-008 conserva acoplamiento residual por instanciacion de DAOs/repositorios concretos desde pantallas. | Parcial | Introducir factories o inyeccion de dependencias a nivel de composicion. |
| DEF-009 | RNF | RNF-017 requiere reforzar integridad fuera de formularios para evitar entidades invalidas si se omite la UI. | Parcial | Agregar validadores de dominio o checks en repositorios/DAOs. |
| DEF-010 | RNF | RNF-030 requiere evidencia especifica con mobile estrecho y texto escalado. | Parcial | Agregar pruebas/resenas responsivas con `textScaleFactor` o escenarios manuales documentados. |

### Cause Defects Analysis

Analisis preliminar por causa:

- Requisitos: algunos aspectos de aceptacion con usuarios no tienen datos reales
  porque aun no se ejecuta PSSUQ.
- Diseno/proceso: las funciones dependientes de plataforma, como archivos
  nativos y notificaciones, requieren integraciones adicionales.
- Herramientas: pruebas de migracion y smoke tests de escritorio dependen de
  configuraciones de ambiente especificas.
- Gestion: se requiere calendario formal para usuarios, aprobaciones y
  responsables.

Para el analisis final se recomienda construir un Pareto con defectos reales
agrupados por categoria: requisitos, diseno, codificacion, interfaz, datos,
herramientas y gestion.

### Improvements implementation

Mejoras ya implementadas y documentadas:

- Validaciones completas de tareas y clases.
- Rechazo de tareas duplicadas exactas normalizadas al crear o editar.
- Creacion, edicion y eliminacion de eventos desde UI.
- Advertencia por superposiciones de eventos.
- Eliminacion definitiva de tareas desde papelera.
- Filtrado visible de tareas por estado.
- Validacion fuerte de preferencias de notificacion.
- Material 3 en navegacion, tareas, horario, calendario, formularios y ajustes.
- Ajustes avanzados de tema, vista inicial, densidad e inicio de semana.
- Manejo de errores visibles en operaciones criticas.
- Recuperacion/deshacer para acciones reversibles cuando es tecnicamente
  seguro.
- Confirmacion reforzada de borrado masivo mediante palabra obligatoria
  `BORRAR`.
- Feedback de carga/guardado en formularios y pantallas principales.
- Estados vacios accionables y diagnostico de conflictos junto al campo o
  seccion afectada.

Mejoras pendientes:

- Ejecutar PSSUQ y documentar resultados estadisticos.
- Cerrar RNF-008 reduciendo acoplamiento residual en composicion de pantallas.
- Cerrar RNF-017 reforzando validaciones en dominio, repositorios o
  persistencia.
- Cerrar RNF-030 con evidencia responsive en pantallas estrechas y texto
  escalado.

### TDD vs NO TDD effectiveness

| Criterio | TDD / Red-Green-Refactor | Validacion sin TDD formal |
| --- | --- | --- |
| Evidencia | Pruebas unitarias, widgets, controllers, serializacion, migracion y smoke tests. | Observacion con usuarios, revision UI/UX, Pareto y retroalimentacion cualitativa. |
| Defectos detectados | Duplicados, validaciones, scheduler, confirmaciones, persistencia y regresiones funcionales. | Problemas de aprendibilidad, hover, area reactiva, layout desktop, selector de hora y lectura del calendario. |
| Efectividad | Alta para asegurar reglas de negocio y evitar regresiones repetibles. | Alta para descubrir problemas de experiencia que no se ven solo en codigo. |
| Resultado | Mayor calidad interna y funcional. | Mayor calidad externa y satisfaccion percibida. |

La comparacion muestra que TDD fue especialmente efectivo para cerrar defectos
tecnicos y funcionales, mientras que la validacion sin TDD formal fue necesaria
para revelar problemas de interfaz, claridad y uso real.

## Conclusions and future work

### Conclusions about system quality

Agenda cuenta con una base tecnica consistente para un proyecto de V&V:
requisitos documentados, reglas de negocio, casos de uso, trazabilidad, pruebas
automatizadas, evidencia TDD y arquitectura modular. Las funcionalidades
principales de tareas, horario, calendario, configuracion y navegacion tienen
evidencia de implementacion y pruebas.

El nivel de calidad observado es adecuado para un primer entregable academico,
con riesgos controlados en las funcionalidades principales. Sin embargo, el
reporte final debe distinguir claramente entre funcionalidades completas,
parciales y pendientes para evitar sobredeclarar capacidades.

Aplicar correctamente V&V si mejora significativamente la calidad del software:
en este proyecto permitio conectar requisitos con pruebas, corregir defectos
mediante regresion automatizada, detectar riesgos de plataforma y descubrir
hallazgos de usabilidad con usuarios reales. La calidad se fortalecio porque se
evaluo el sistema desde requisitos, diseno, codigo, pruebas, integracion y
aceptacion, no solo desde la ejecucion final.

### Suggestions for continuous improvement

- Completar pruebas de aceptacion con usuarios reales.
- Aplicar PSSUQ y analizar resultados.
- Formalizar metricas de defectos y tiempos de resolucion.
- Mantener pruebas de regresion para notificaciones nativas, archivos,
  migraciones y plataformas.
- Mantener trazabilidad actualizada ante cada cambio.
- Actualizar los estados de RNF en los documentos de requerimientos con formato
  cuando se cierren RNF-008, RNF-017 y RNF-030.

### Learning experience in the course

[PENDIENTE] Redactar conclusion individual de cada integrante sobre el
aprendizaje del curso.

### Learning experience in the project

[PENDIENTE] Redactar conclusion individual de cada integrante sobre trabajar
con un proyecto real, usuarios reales o cliente real.

## REFERENCES

[PENDIENTE] Convertir referencias a formato APA y citarlas dentro del cuerpo
del reporte.

Referencias base:

- IEEE. (s. f.). IEEE 1012 - Standard for System and Software Verification and
  Validation.
- ISO/IEC. (s. f.). ISO/IEC 12207 - Systems and software engineering -
  Software life cycle processes.
- Flutter documentation. https://docs.flutter.dev/
- Dart documentation. https://dart.dev/
- SQLite documentation. https://www.sqlite.org/docs.html
- Syncfusion Flutter Calendar documentation. https://help.syncfusion.com/flutter/calendar/overview
- Documentacion interna del proyecto Agenda: `README.md`, `docs/README.md`,
  `docs/arquitectura.md`, `docs/desarrollo.md`, `docs/pruebas.md`,
  `docs/casos_prueba.md`,
  `docs/requerimientos/requerimientos_funcionales_formato.md`,
  `docs/requerimientos/requerimientos_no_funcionales_formato.md`,
  `docs/requerimientos/casos_de_uso.md`,
  `docs/requerimientos/reglas_de_negocio.md` y
  `docs/requerimientos/trazabilidad.md`.
