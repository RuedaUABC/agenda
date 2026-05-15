# Requerimientos No Funcionales

## Plataforma

**RNF-001. Multiplataforma Flutter**  
El sistema debe ejecutarse sobre Flutter en plataformas moviles, web y
escritorio soportadas por el proyecto.

**RNF-002. Compatibilidad de SDK**  
El proyecto debe usar una version de Dart compatible con la restriccion
`sdk: ^3.11.3` declarada en `pubspec.yaml`.

**RNF-003. Soporte de escritorio para SQLite**  
En Windows y Linux, la app debe usar `sqflite_common_ffi` antes de abrir la base
de datos.

## Arquitectura y Mantenibilidad

**RNF-004. Organizacion feature-first**  
El codigo debe mantenerse organizado por funcionalidades dentro de
`lib/features/`.

**RNF-005. Separacion por capas**  
Las features deben separar modelos de dominio, acceso a datos, repositorios y
presentacion cuando aplique.

**RNF-006. Componentes compartidos en core**  
Las utilidades, temas, widgets comunes y configuracion transversal deben vivir
en `lib/core/`.

**RNF-007. Controllers testeables**  
La logica de estado debe poder probarse con repositorios falsos, como ocurre en
los tests de controllers.

## Usabilidad

**RNF-008. Diseno responsivo**  
El sistema debe cambiar entre layout movil y escritorio segun el ancho
disponible. El umbral actual es `800 px`.

**RNF-009. Modo oscuro consistente**  
La app debe usar el tema oscuro definido en `AppTheme.darkTheme` y forzar
`ThemeMode.dark`.

**RNF-010. Indicadores de carga**  
Las pantallas principales deben mostrar un indicador mientras cargan sus
dependencias y datos iniciales.

**RNF-011. Estados vacios visibles**  
Horario y calendario deben mostrar mensajes cuando no existan clases o eventos
para la fecha seleccionada.

## Datos

**RNF-012. Persistencia offline**  
Tareas, clases y eventos deben funcionar con almacenamiento local, sin depender
de red para las operaciones principales observadas.

**RNF-013. Fechas en formato ISO**  
Los modelos persistidos en SQLite deben guardar fechas con
`toIso8601String()` y restaurarlas con `DateTime.parse`.

**RNF-014. Booleanos como enteros en SQLite**  
Los campos booleanos de tareas deben persistirse como `0` o `1`.

## Calidad

**RNF-015. Cobertura por feature**  
El proyecto debe mantener pruebas por modulo en `test/features/`.

**RNF-016. Pruebas de serializacion**  
Los modelos persistidos deben contar con pruebas que validen conversion entre
objeto y mapa.

**RNF-017. Pruebas de widgets criticos**  
Los formularios y widgets principales deben contar con pruebas para validar
renderizado y acciones clave.

## Seguridad y Configuracion

**RNF-018. Inicializacion explicita de Firebase**  
Si se activa autenticacion o servicios Firebase, la inicializacion debe ocurrir
antes de `runApp`.

**RNF-019. Manejo de errores de autenticacion**  
Los errores conocidos de Firebase Auth deben transformarse en mensajes
comprensibles para el usuario.

## Notificaciones

**RNF-020. Scheduler reemplazable**  
El sistema de notificaciones debe mantenerse encapsulado en
`NotificationScheduler` para permitir cambiar el mock actual por la
implementacion real.

**RNF-021. Estado parcial de notificaciones reales**  
La implementacion actual no debe tratarse como notificacion nativa real, porque
las llamadas a `flutter_local_notifications` estan comentadas y se usan
mensajes por consola.
