# Requerimientos No Funcionales

Este documento define restricciones y atributos de calidad esperados para la
aplicacion Agenda. Los RNF deben ser verificables mediante revision, pruebas o
ejecucion de la aplicacion.

## Plataforma

**RNF-001. Aplicacion Flutter multiplataforma**  
Prioridad: Alta.  
El sistema debe mantenerse como una aplicacion Flutter compatible con las
plataformas declaradas en el proyecto: Android, iOS, Web, Windows, Linux y
macOS.

Criterio de verificacion:

- El proyecto conserva carpetas y configuracion de compilacion para las
  plataformas soportadas.

**RNF-002. Compatibilidad de SDK**  
Prioridad: Alta.  
El proyecto debe usar una version de Dart compatible con la restriccion
declarada en `pubspec.yaml`.

Criterio de verificacion:

- `flutter pub get` debe resolver dependencias sin conflictos de SDK.

**RNF-003. Soporte de SQLite en escritorio**  
Prioridad: Alta.  
En Windows y Linux, la aplicacion debe inicializar el soporte FFI de SQLite
antes de abrir la base de datos.

## Arquitectura y Mantenibilidad

**RNF-004. Organizacion por funcionalidades**  
Prioridad: Media.  
El codigo de negocio debe organizarse principalmente por funcionalidad dentro
de `lib/features/`.

**RNF-005. Separacion por capas**  
Prioridad: Media.  
Cada funcionalidad debe separar, cuando aplique, modelos de dominio, acceso a
datos, repositorios y presentacion.

**RNF-006. Componentes compartidos en core**  
Prioridad: Media.  
Las utilidades, temas, widgets comunes, base de datos y configuracion
transversal deben ubicarse en `lib/core/`.

**RNF-007. Logica de estado testeable**  
Prioridad: Alta.  
La logica de estado debe poder probarse sin depender directamente de widgets,
base de datos real ni servicios externos.

Criterio de verificacion:

- Los controllers permiten usar repositorios falsos o dobles de prueba.

**RNF-008. Bajo acoplamiento entre UI y persistencia**  
Prioridad: Media. Estado: Sugerido.  
La interfaz no debe acceder directamente a DAOs o almacenamiento persistente;
debe hacerlo por medio de controllers, repositorios o servicios definidos.

## Usabilidad

**RNF-009. Diseno responsivo**  
Prioridad: Alta. Estado: Implementado.
El sistema debe adaptar su interfaz a pantallas moviles y de escritorio.

Criterio de verificacion:

- En anchos menores al umbral definido por la aplicacion se muestra layout
  movil.
- En anchos iguales o mayores al umbral definido por la aplicacion se muestra
  layout de escritorio.
- La navegacion debe adaptarse al ancho disponible: barra inferior en movil y
  `NavigationRail` o sidebar en pantallas medianas y grandes.

**RNF-010. Tema visual Material 3 consistente**

Prioridad: Alta. Estado: Implementado.

La aplicacion debe usar Material 3 como sistema visual base en todos los
modulos, siguiendo la guia [`docs/diseno_material3.md`](../diseno_material3.md).

Criterio de verificacion:

- Colores, tipografias, botones, tarjetas y estados de seleccion deben seguir
  el tema definido por la aplicacion.
- El tema debe usar `useMaterial3: true`, `ColorScheme` semantico y componentes
  Material 3 nativos cuando exista equivalente en Flutter.
- La aplicacion debe soportar tema claro, oscuro y preferencia del sistema.

**RNF-011. Indicadores de carga**  
Prioridad: Media. Estado: Parcial.  
Las pantallas principales deben mostrar un indicador mientras cargan datos o
dependencias iniciales.

Criterio de verificacion:

- El indicador debe incluir contexto textual o mantener estructura visual
  suficiente para que el usuario entienda que modulo se esta cargando.

**RNF-012. Estados vacios visibles**  
Prioridad: Media. Estado: Parcial.  
Las listas y calendarios deben mostrar un mensaje claro cuando no existan datos
para presentar.

Criterio de verificacion:

- Los estados vacios deben ser especificos al modulo o categoria y, cuando
  aplique, ofrecer una accion directa para crear el primer elemento.

**RNF-013. Mensajes de validacion comprensibles**  
Prioridad: Alta. Estado: Parcial.  
Cuando el usuario capture datos invalidos, el sistema debe mostrar mensajes
claros, cercanos al campo afectado y orientados a la accion.

Ejemplos:

- "Ingresa un titulo para la tarea."
- "La hora de fin debe ser posterior a la hora de inicio."
- "Selecciona una fecha antes de guardar."

Criterio de verificacion:

- Las validaciones simples se muestran junto al campo.
- Las validaciones de rango o conflicto se muestran junto a la seccion
  relacionada y pueden complementarse con `SnackBar`.

## Datos

**RNF-014. Persistencia offline**  
Prioridad: Alta.  
Las operaciones principales de tareas, clases, eventos y preferencias deben
funcionar sin conexion de red.

**RNF-015. Formato de fechas persistidas**  
Prioridad: Alta.  
Los modelos persistidos deben guardar fechas en formato ISO 8601 y restaurarlas
mediante parseo seguro.

**RNF-016. Representacion de booleanos en SQLite**  
Prioridad: Media.  
Los campos booleanos almacenados en SQLite deben representarse como `0` o `1`.

**RNF-017. Integridad de datos obligatorios**  
Prioridad: Alta. Estado: Sugerido.  
El sistema debe evitar persistir entidades incompletas o invalidas mediante
validaciones en la interfaz y, cuando sea posible, en la capa de dominio o
persistencia.

## Calidad

**RNF-018. Pruebas por funcionalidad**  
Prioridad: Alta.  
El proyecto debe mantener pruebas automatizadas organizadas por funcionalidad.

Criterio de verificacion:

- Existen pruebas en `test/features/` para los modulos principales.

**RNF-019. Pruebas de serializacion**  
Prioridad: Media.  
Los modelos persistidos deben contar con pruebas que validen conversion entre
objeto y mapa.

**RNF-020. Pruebas de widgets criticos**  
Prioridad: Media.  
Los formularios y widgets principales deben contar con pruebas de renderizado,
validacion y acciones clave.

**RNF-021. Pruebas de reglas de negocio**  
Prioridad: Alta. Estado: Sugerido.  
Las reglas de clasificacion de tareas, validacion de horarios, recurrencia
semanal y seleccion de eventos por fecha deben estar cubiertas por pruebas
automatizadas.

## Seguridad Local y Robustez

**RNF-022. Confirmacion para acciones destructivas**  
Prioridad: Alta. Estado: Parcial.  
El sistema debe solicitar confirmacion antes de ejecutar acciones destructivas
como eliminar tareas, clases o eventos.

Criterio de verificacion:

- Las acciones destructivas comunes respetan la preferencia del usuario.
- Las acciones irreversibles o masivas conservan confirmacion obligatoria y
  reforzada.
- Los botones destructivos usan tratamiento visual de error cuando la accion no
  puede revertirse facilmente.

**RNF-023. Manejo de errores de persistencia**  
Prioridad: Alta. Estado: Implementado.  
Si ocurre un error al leer o guardar datos locales, el sistema debe informar al
usuario y evitar dejar la interfaz en un estado inconsistente.

**RNF-024. Datos sensibles en almacenamiento local**  
Prioridad: Media. Estado: Sugerido.  
La aplicacion no debe almacenar informacion sensible innecesaria en texto plano.
Si en el futuro se guardan datos sensibles, debera usarse almacenamiento seguro
de la plataforma.

## Notificaciones

**RNF-025. Scheduler reemplazable**  
Prioridad: Media.  
El sistema de notificaciones debe mantenerse encapsulado para permitir cambiar
la implementacion sin modificar los modulos de tareas, horario o configuracion.

**RNF-026. Estado de notificaciones nativas**  
Prioridad: Media.  
El sistema debe documentar el estado real de las notificaciones nativas y
mantener pruebas de programacion/cancelacion para los avisos integrados.

## Calidad de Experiencia

**RNF-027. Calidad textual y codificacion de interfaz**  
Prioridad: Alta. Estado: Sugerido.  
Todos los textos visibles de la aplicacion deben mostrarse con codificacion
correcta, sin mojibake, caracteres corruptos ni inconsistencias graves de
idioma.

Criterio de verificacion:

- Los dialogs, botones, snackbars, etiquetas, estados vacios y mensajes de
  validacion se revisan en ejecucion o pruebas de widgets.
- Los textos en espanol deben usar signos, acentos y terminos consistentes
  cuando la codificacion del archivo lo permita.
- No deben aparecer cadenas como `Â¿` o `SÃ­` en la interfaz.

**RNF-028. Recuperabilidad de acciones de usuario**  
Prioridad: Alta. Estado: Sugerido.  
La interfaz debe permitir recuperarse de acciones frecuentes cuando exista una
forma tecnica segura de revertirlas.

Criterio de verificacion:

- Las acciones reversibles muestran `SnackBar` con `Deshacer`.
- Las acciones irreversibles declaran explicitamente que no se pueden deshacer.
- La recuperacion no debe crear duplicados ni perder datos relacionados.

**RNF-029. Retroalimentacion de operaciones en progreso**  
Prioridad: Media. Estado: Sugerido.  
La interfaz debe prevenir incertidumbre o acciones duplicadas durante
operaciones asincronas.

Criterio de verificacion:

- Botones de guardado o aplicacion se deshabilitan mientras esperan respuesta.
- La UI muestra estado de progreso o texto temporal cuando una accion esta en
  curso.
- Si una operacion falla, el usuario recibe un mensaje visible y la UI vuelve a
  un estado accionable.

**RNF-030. Robustez responsiva de acciones y texto**  
Prioridad: Media. Estado: Sugerido.  
Los controles de formularios, dialogs y sheets deben mantener legibilidad y
objetivos tactiles adecuados en pantallas estrechas y con texto escalado.

Criterio de verificacion:

- Los grupos de acciones se apilan o reorganizan cuando no hay ancho suficiente.
- Ningun boton critico debe truncarse de forma ambigua.
- Los objetivos tactiles interactivos mantienen al menos `48x48` cuando sea
  aplicable.

**RNF-031. Consistencia visual de acciones destructivas**  
Prioridad: Media. Estado: Sugerido.  
Las acciones destructivas deben tener un tratamiento visual consistente y
diferenciable de acciones primarias no destructivas.

Criterio de verificacion:

- Iconos y texto de acciones destructivas usan `colorScheme.error` o variante
  equivalente cuando la accion sea irreversible o de alto impacto.
- Los dialogs destructivos presentan cancelar como ruta clara de escape.
- La accion destructiva no debe aparecer como opcion positiva por defecto sin
  contexto.
