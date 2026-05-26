# Requerimientos No Funcionales en Formato Estructurado

Este documento reestructura los requerimientos no funcionales de Agenda con una
adaptacion del formato:

`Actor responsable / Accion esperada / Objeto de calidad / Condicion o entrada / Resultado esperado`

En los RNF, el "actor" suele ser el sistema, la interfaz, el proyecto o el
codigo fuente, porque describen restricciones y atributos de calidad mas que
acciones directas de un usuario.

## Tabla de Requerimientos No Funcionales

| ID | Actor responsable | Accion esperada | Objeto de calidad | Condicion o entrada | Resultado esperado | Prioridad | Estado | Verificacion |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| RNF-001 | Proyecto | Mantener compatibilidad | Plataformas Flutter | Android, iOS, Web, Windows, Linux y macOS declarados | El proyecto conserva configuracion para compilar en las plataformas soportadas. | Alta | Vigente | Revisar carpetas y configuracion de plataforma. |
| RNF-002 | Proyecto | Usar | SDK Dart compatible | Restriccion declarada en `pubspec.yaml` | Las dependencias se resuelven sin conflicto de SDK. | Alta | Vigente | Ejecutar `flutter pub get`. |
| RNF-003 | Sistema | Inicializar | SQLite FFI en escritorio | Ejecucion en Windows o Linux | La base de datos puede abrirse despues de inicializar FFI. | Alta | Vigente | Ejecutar smoke test de SQLite en escritorio. |
| RNF-004 | Codigo fuente | Organizar | Modulos funcionales | Estructura de `lib/features/` | El codigo de negocio queda agrupado por funcionalidad. | Media | Vigente | Revisar estructura de carpetas. |
| RNF-005 | Codigo fuente | Separar | Capas internas | Dominio, datos, repositorios y presentacion | Cada funcionalidad mantiene responsabilidades separadas cuando aplica. | Media | Vigente | Revisar estructura por feature. |
| RNF-006 | Codigo fuente | Ubicar | Componentes transversales | Utilidades, temas, widgets comunes, base de datos y configuracion | Los elementos compartidos residen en `lib/core/`. | Media | Vigente | Revisar ubicacion de componentes compartidos. |
| RNF-007 | Codigo fuente | Permitir prueba | Logica de estado | Controllers y repositorios falsos | La logica se prueba sin widgets, base real ni servicios externos. | Alta | Vigente | Ejecutar pruebas de controllers con dobles. |
| RNF-008 | Interfaz | Evitar acoplamiento | Persistencia local | Acceso a DAOs o almacenamiento | La UI usa controllers, repositorios o servicios en lugar de DAOs directos. | Media | Sugerido | Revisar dependencias de widgets. |
| RNF-009 | Interfaz | Adaptar | Layout responsivo | Ancho de pantalla movil o escritorio | La UI usa layout movil o desktop segun el ancho disponible. | Alta | Implementado | Probar anchos representativos. |
| RNF-010 | Interfaz | Usar consistentemente | Material 3 | Todos los modulos visibles | Colores, tipografia y componentes siguen el tema Material 3 de la app. | Alta | Implementado | Revisar tema y pruebas Material 3. |
| RNF-011 | Interfaz | Mostrar | Indicadores de carga | Carga de datos o dependencias iniciales | El usuario entiende que modulo o accion esta cargando. | Media | Implementado | Revisar pantallas principales durante carga. |
| RNF-012 | Interfaz | Mostrar | Estados vacios | Listas o calendarios sin datos | La pantalla informa que no hay datos y ofrece accion cuando aplique. | Media | Implementado | Abrir modulos sin registros. |
| RNF-013 | Interfaz | Comunicar | Mensajes de validacion | Datos invalidos capturados por el usuario | El mensaje es claro, cercano al campo y orientado a corregir. | Alta | Implementado | Provocar validaciones de formularios. |
| RNF-014 | Sistema | Operar | Persistencia offline | Sin conexion de red | Tareas, clases, eventos y preferencias funcionan localmente. | Alta | Vigente | Ejecutar flujos principales sin red. |
| RNF-015 | Persistencia | Guardar | Fechas | Modelos serializados | Las fechas se almacenan como ISO 8601 y se restauran con parseo seguro. | Alta | Vigente | Ejecutar pruebas de serializacion. |
| RNF-016 | Persistencia | Representar | Booleanos SQLite | Campos booleanos persistidos | Los booleanos se guardan como `0` o `1`. | Media | Vigente | Revisar mapas de modelos y DAOs. |
| RNF-017 | Sistema | Evitar | Entidades invalidas | Datos incompletos o invalidos | Las validaciones impiden persistir entidades que no cumplen reglas obligatorias. | Alta | Sugerido | Probar validaciones en UI y dominio. |
| RNF-018 | Proyecto | Mantener | Pruebas por funcionalidad | Modulos principales | Existen pruebas en `test/features/` para las funcionalidades principales. | Alta | Vigente | Revisar y ejecutar suites por feature. |
| RNF-019 | Proyecto | Probar | Serializacion de modelos | Conversion objeto-mapa | Los modelos conservan sus campos al serializar y restaurar. | Media | Vigente | Ejecutar pruebas de serializacion. |
| RNF-020 | Proyecto | Probar | Widgets criticos | Formularios y widgets principales | Los widgets cubren renderizado, validacion y acciones clave. | Media | Vigente | Ejecutar pruebas de widgets. |
| RNF-021 | Proyecto | Cubrir | Reglas de negocio | Clasificacion, horarios, recurrencia y seleccion por fecha | Las reglas principales tienen pruebas automatizadas. | Alta | Sugerido | Revisar cobertura de reglas. |
| RNF-022 | Sistema | Confirmar | Acciones destructivas | Eliminacion comun o masiva | Las acciones destructivas piden confirmacion y las masivas conservan confirmacion reforzada. | Alta | Implementado | Ejecutar eliminaciones y borrado masivo. |
| RNF-023 | Sistema | Informar | Errores de persistencia | Falla al leer o guardar datos locales | El usuario ve un error y la UI queda en estado consistente. | Alta | Implementado | Simular fallo de repositorio. |
| RNF-024 | Sistema | Proteger | Datos sensibles | Aparicion futura de datos sensibles | La app evita texto plano innecesario o usa almacenamiento seguro si aplica. | Media | Sugerido | Revisar datos persistidos. |
| RNF-025 | Sistema | Encapsular | Scheduler de notificaciones | Cambio de implementacion de notificaciones | Los modulos no dependen directamente del plugin de plataforma. | Media | Vigente | Revisar dependencias del scheduler. |
| RNF-026 | Proyecto | Documentar y probar | Notificaciones nativas | Programacion o cancelacion de avisos integrados | El estado real de notificaciones queda claro y probado. | Media | Vigente | Revisar docs y pruebas de scheduler. |
| RNF-027 | Interfaz | Mostrar correctamente | Textos visibles | Dialogos, botones, snackbars, etiquetas y estados vacios | No aparecen caracteres corruptos ni inconsistencias graves de idioma. | Alta | Sugerido | Revisar UI y pruebas de widgets. |
| RNF-028 | Interfaz | Permitir recuperacion | Acciones reversibles | Accion que puede deshacerse sin romper integridad | La UI ofrece `Deshacer` o advierte si no se puede revertir. | Alta | Implementado | Ejecutar acciones reversibles. |
| RNF-029 | Interfaz | Retroalimentar | Operaciones en progreso | Acciones asincronas de carga o guardado | La UI evita incertidumbre y ejecuciones duplicadas. | Media | Implementado | Simular operaciones lentas. |
| RNF-030 | Interfaz | Mantener legibilidad | Acciones y texto responsivo | Pantallas estrechas o texto escalado | Controles y textos no se superponen y mantienen objetivos tactiles. | Media | Sugerido | Probar mobile y escalado de texto. |
| RNF-031 | Interfaz | Diferenciar | Acciones destructivas | Accion irreversible o de alto impacto | Iconos, texto y dialogs usan tratamiento visual de error y ruta clara de cancelar. | Media | Implementado | Revisar dialogs destructivos. |

## Validacion de Calidad del Formato

| Atributo | Aplicacion en RNF |
| --- | --- |
| Correcto / necesario | Cada RNF describe una restriccion o cualidad necesaria para la app. |
| Completo | Cada fila incluye condicion y resultado esperado verificable. |
| Consistente | Los terminos plataforma, interfaz, persistencia, pruebas y scheduler se usan de forma uniforme. |
| No ambiguo | Se reemplazan frases generales por resultados observables. |
| Verificable | Cada RNF incluye una forma de comprobacion. |
| Prioritario | Cada RNF conserva prioridad Alta, Media o Baja. |
| Factible | El estado separa lo vigente, implementado, parcial y sugerido. |
| Trazable | Cada RNF mantiene identificador unico. |
| Modificable | La tabla permite cambiar una fila sin afectar las demas. |
| Conciso y entendible | Las filas usan una estructura repetible y breve. |
