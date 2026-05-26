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
- Firebase fue retirado del proyecto; la app usa servicios locales para el
  alcance actual.
- Pruebas unitarias y de widgets organizadas por feature.

## Documentacion

La documentacion del proyecto esta en [`docs/`](docs/README.md):

- [`docs/arquitectura.md`](docs/arquitectura.md): organizacion del codigo,
  capas y flujo general.
- [`docs/desarrollo.md`](docs/desarrollo.md): instalacion, ejecucion,
  comandos utiles y notas de configuracion.
- [`docs/pruebas.md`](docs/pruebas.md): cobertura y comandos de pruebas.
- [`docs/requerimientos/`](docs/requerimientos/README.md): requerimientos,
  reglas de negocio, trazabilidad y formatos tabulares de calidad.
- [`docs/plan_verificacion_validacion.md`](docs/plan_verificacion_validacion.md):
  plan de verificacion y validacion.

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

## Servicios Externos

Firebase fue retirado del proyecto. Si se reactiva autenticacion,
sincronizacion o cualquier proveedor externo, revisa
[`docs/desarrollo.md`](docs/desarrollo.md) y actualiza dependencias,
configuracion nativa, pruebas y documentacion.

## Estructura Principal

```text
lib/
|-- main.dart
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
