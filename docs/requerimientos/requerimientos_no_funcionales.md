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
Prioridad: Alta.  
El sistema debe adaptar su interfaz a pantallas moviles y de escritorio.

Criterio de verificacion:

- En anchos menores al umbral definido por la aplicacion se muestra layout
  movil.
- En anchos iguales o mayores al umbral definido por la aplicacion se muestra
  layout de escritorio.

**RNF-010. Tema visual consistente**  
Prioridad: Media.  
La aplicacion debe usar un tema visual consistente en todos los modulos.

Criterio de verificacion:

- Colores, tipografias, botones, tarjetas y estados de seleccion deben seguir
  el tema definido por la aplicacion.

**RNF-011. Indicadores de carga**  
Prioridad: Media.  
Las pantallas principales deben mostrar un indicador mientras cargan datos o
dependencias iniciales.

**RNF-012. Estados vacios visibles**  
Prioridad: Media.  
Las listas y calendarios deben mostrar un mensaje claro cuando no existan datos
para presentar.

**RNF-013. Mensajes de validacion comprensibles**  
Prioridad: Alta. Estado: Sugerido.  
Cuando el usuario capture datos invalidos, el sistema debe mostrar mensajes
claros, cercanos al campo afectado y orientados a la accion.

Ejemplos:

- "Ingresa un titulo para la tarea."
- "La hora de fin debe ser posterior a la hora de inicio."
- "Selecciona una fecha antes de guardar."

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
Prioridad: Alta. Estado: Sugerido.  
El sistema debe solicitar confirmacion antes de ejecutar acciones destructivas
como eliminar tareas, clases o eventos.

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
Mientras la implementacion real de notificaciones nativas no este integrada, el
sistema no debe documentarlas como funcionalidad completa de usuario final.
