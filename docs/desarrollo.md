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
```

El resumen funcional de la cobertura esta en [`pruebas.md`](pruebas.md).

## Firebase

El proyecto incluye archivos generados de Firebase:

- `firebase.json`
- `lib/firebase_options.dart`
- `android/app/google-services.json`

Actualmente `lib/main.dart` tiene comentada la llamada a:

```dart
// await Firebase.initializeApp();
```

Si se necesita Firebase Auth u otro servicio:

1. Importar y usar `DefaultFirebaseOptions.currentPlatform` desde
   `firebase_options.dart`.
2. Descomentar o restaurar la inicializacion antes de `runApp`.
3. Validar que cada plataforma tenga su configuracion correspondiente.
4. Ejecutar pruebas y una corrida manual de autenticacion.

Ejemplo esperado:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

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
- Agregar o actualizar tests de serializacion y DAO cuando corresponda.

## Plataformas de Escritorio

En Windows y Linux, `main.dart` inicializa `sqflite_common_ffi`:

```dart
sqfliteFfiInit();
databaseFactory = databaseFactoryFfi;
```

Esto permite usar SQLite fuera de Android/iOS.

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
