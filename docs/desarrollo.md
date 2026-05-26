# Guia de Desarrollo

Esta guia resume como preparar, ejecutar y mantener el proyecto Agenda en un
entorno local.

## Requisitos

- Flutter instalado.
- Dart compatible con `sdk: ^3.11.3`.
- Android Studio, VS Code o el editor preferido.
- Un emulador, dispositivo fisico o plataforma de escritorio habilitada.

Verifica el entorno con:

```powershell
flutter doctor
flutter devices
```

## Instalacion

Desde la raiz del repositorio:

```powershell
flutter pub get
```

Si cambian dependencias en `pubspec.yaml`, vuelve a ejecutar el comando.

## Ejecucion

Ejecutar en el dispositivo o emulador disponible:

```powershell
flutter run
```

Ejecutar en una plataforma concreta:

```powershell
flutter run -d windows
flutter run -d chrome
flutter run -d android
```

La lista exacta de dispositivos depende de `flutter devices`.

## Analisis y Pruebas

Analisis estatico:

```powershell
flutter analyze
```

Todas las pruebas:

```powershell
flutter test
```

Pruebas por feature:

```powershell
flutter test test/features/tareas
flutter test test/features/horario
flutter test test/features/calendario
flutter test test/features/configuracion
flutter test test/features/persistencia
```

El resumen funcional de la cobertura esta en [`pruebas.md`](pruebas.md).

## Servicios Externos

Firebase fue retirado del proyecto. `pubspec.yaml`, Android Gradle y los
registrantes nativos no deben incluir `firebase_core`, `firebase_auth`,
`google_sign_in` ni `google-services`.

Si se necesita agregar un proveedor externo en el futuro, debe documentarse la
dependencia nueva, actualizar los registrantes con `flutter pub get` y validar
Windows, Android y la suite automatizada.

## Base de Datos Local

La persistencia principal usa SQLite. La configuracion vive en:

```text
lib/core/db/database_helper.dart
```

La base se llama `agenda.db` y su version actual es `3`.

Cuando se agreguen columnas o tablas:

- Incrementar `_dbVersion`.
- Agregar la migracion en `_onUpgrade`.
- Mantener `_onCreate` como la estructura completa para instalaciones nuevas.
- Agregar o actualizar tests de serializacion, DAO y migracion cuando
  corresponda. El test dedicado vive en
  `test/features/persistencia/sqlite_migration_test.dart`.

## Plataformas de Escritorio

En Windows y Linux, `main.dart` llama a `configureSqliteForPlatform`, que
inicializa `sqflite_common_ffi`:

```dart
configureSqliteForPlatform();
```

Esto permite usar SQLite fuera de Android/iOS.

El smoke test automatizado esta en
`test/features/persistencia/sqlite_ffi_smoke_test.dart`.

## Notificaciones y Respaldos Nativos

Los avisos usan `NotificationScheduler`, respaldado por
`flutter_local_notifications` y `timezone`. En pruebas se inyectan fakes para
validar programacion/cancelacion sin depender del plugin de plataforma.
En Android, el manifest declara permisos de notificaciones y alarmas exactas
para permitir avisos programados.

La exportacion e importacion de respaldos locales usa `file_selector` mediante
`NativeBackupFileService`. La UI de Ajustes abre dialogos nativos para guardar
o seleccionar archivos JSON.

## Convenciones de Codigo

- Mantener una organizacion feature-first dentro de `lib/features/`.
- Usar `domain/` para modelos.
- Usar `data/` para DAOs y servicios externos.
- Usar `repository/` para contratos e implementaciones de acceso a datos.
- Usar `presentation/` para widgets, controllers y adaptadores de UI.
- Mantener componentes compartidos en `lib/core/`.

## Agregar una Nueva Feature

Estructura recomendada:

```text
lib/features/nueva_feature/
|-- data/
|-- domain/
|-- repository/
`-- presentation/
```

Tambien agrega pruebas en:

```text
test/features/nueva_feature/
```

## Problemas Comunes

Si `flutter pub get` falla, revisa la version local de Flutter y la restriccion
`sdk` en `pubspec.yaml`.

Si la app falla al abrir la base en escritorio, verifica que la plataforma sea
Windows o Linux y que `sqflite_common_ffi` se inicialice antes de acceder a
SQLite.

Si una prueba de widget falla por texto o layout, revisa primero los cambios en
`presentation/` de la feature correspondiente.
