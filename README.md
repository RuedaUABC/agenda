# Agenda

Agenda es una aplicacion Flutter multiplataforma para organizar tareas,
horarios de clases, eventos de calendario y preferencias de notificacion.
El proyecto esta estructurado por funcionalidades para mantener separadas la
interfaz, la logica de estado, los repositorios y el acceso a datos.

## Estado Actual

- UI responsiva para escritorio y movil.
- Modulos principales: tareas, horario, calendario, configuracion y navegacion.
- Persistencia local con SQLite mediante `sqflite`.
- Soporte para Windows y Linux con `sqflite_common_ffi`.
- Configuracion de Firebase generada en el proyecto, aunque la inicializacion
  esta desactivada en `lib/main.dart`.
- Pruebas unitarias y de widgets organizadas por feature.

## Documentacion

La documentacion del proyecto esta en [`docs/`](docs/README.md):

- [`docs/arquitectura.md`](docs/arquitectura.md): organizacion del codigo,
  capas y flujo general.
- [`docs/desarrollo.md`](docs/desarrollo.md): instalacion, ejecucion,
  comandos utiles y notas de configuracion.
- [`docs/pruebas.md`](docs/pruebas.md): cobertura y comandos de pruebas.

## Requisitos

- Flutter con Dart compatible con `sdk: ^3.11.3`.
- Un dispositivo, emulador o plataforma de escritorio habilitada.
- Dependencias del proyecto instaladas con `flutter pub get`.

Para validar el entorno:

```powershell
flutter doctor
flutter devices
```

## Inicio Rapido

1. Clona el repositorio:

   ```powershell
   git clone https://github.com/RuedaUABC/agenda.git
   cd agenda
   ```

2. Instala dependencias:

   ```powershell
   flutter pub get
   ```

3. Ejecuta la aplicacion:

   ```powershell
   flutter run
   ```

4. Ejecuta pruebas:

   ```powershell
   flutter test
   ```

## Notas de Firebase

El repositorio contiene `firebase.json`, `lib/firebase_options.dart` y
`android/app/google-services.json`. Sin embargo, en el punto de entrada actual
la llamada a `Firebase.initializeApp()` esta comentada. Si se reactiva la
autenticacion o cualquier servicio de Firebase, revisa
[`docs/desarrollo.md`](docs/desarrollo.md) antes de ejecutar la app.

## Estructura Principal

```text
lib/
|-- main.dart
|-- firebase_options.dart
|-- core/
|   |-- db/
|   |-- theme/
|   |-- utils/
|   `-- widgets/
`-- features/
    |-- auth/
    |-- calendario/
    |-- configuracion/
    |-- horario/
    |-- navegacion/
    `-- tareas/
```

## Comandos Frecuentes

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

Para mas detalle, consulta la guia de desarrollo en
[`docs/desarrollo.md`](docs/desarrollo.md).
