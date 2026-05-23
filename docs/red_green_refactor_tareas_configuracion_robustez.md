# Red Green Refactor: Tareas, Configuracion y Robustez

Fecha: 2026-05-23.

## Alcance

Este ciclo cubre:

- RF-011: eliminacion definitiva de tareas desde papelera.
- RF-016: busqueda y filtrado de tareas.
- RF-033: advertencia por eventos superpuestos.
- RF-037: validacion fuerte de preferencias de notificacion.
- RNF-023: manejo visible de errores de persistencia.

## Red

Se agregaron pruebas antes de implementar:

- `test/features/tareas/taskcontroller_test.dart`
  - elimina definitivamente una tarea desde papelera.
  - busca tareas por titulo, asignatura y descripcion.
  - filtra por estado y rango de fecha.
  - expone un mensaje cuando falla persistencia.
- `test/widget_test.dart`
  - confirma eliminacion definitiva desde papelera.
  - muestra snackbar cuando falla el borrado definitivo.
- `test/features/tareas/tareas_filter_bar_test.dart`
  - actualiza busqueda y filtros desde controles visibles.
- `test/features/calendario/evento_form_test.dart`
  - advierte por superposicion y permite guardar de todos modos.
- `test/features/configuracion/settings_controller_test.dart`
  - rechaza listas vacias, duraciones negativas y valores no soportados.
  - recupera valores por defecto si preferencias guardadas son invalidas.

Evidencia Red:

```powershell
flutter test test\features\tareas\taskcontroller_test.dart test\widget_test.dart test\features\calendario\evento_form_test.dart test\features\configuracion\settings_controller_test.dart
```

Resultado esperado en esta fase: fallas por metodos inexistentes, contratos sin
`deleteTareaDefinitiva`, filtros ausentes, preferencias permisivas y
superposiciones tratadas solo como bloqueo.

## Green

Se implemento el comportamiento minimo para pasar las pruebas:

- `TareaRepository`, `TareaRepositoryImpl` y `TareaDao`
  - agregan borrado fisico `deleteTareaDefinitiva`.
- `TasksController`
  - agrega `lastError`.
  - agrega busqueda por titulo, asignatura y descripcion.
  - agrega filtros por estado y fecha.
  - recarga listas despues de borrar definitivamente.
- `ListaTareasCategoria`
  - muestra accion "Eliminar definitivo" en papelera.
  - solicita confirmacion destructiva.
  - muestra snackbar si falla persistencia.
- `TareasFilterBar`
  - agrega controles visibles de busqueda, estado y rango de fecha.
- `EventoForm`
  - cambia la superposicion a advertencia con "Cancelar" o "Guardar de todos
    modos".
- `PreferencesHelper`
  - centraliza valores permitidos `[5, 10, 15, 30, 60, 120, 1440]`.
  - rechaza valores vacios, negativos o no soportados.
  - usa valores por defecto si encuentra preferencias persistidas invalidas.
- Pantallas/formularios de tareas, clases, eventos y configuracion
  - muestran mensajes visibles ante errores locales relevantes.

Evidencia Green:

```powershell
flutter test
```

Resultado: suite completa en verde.

## Refactor

- El borrado definitivo quedo como una operacion explicita distinta de la
  eliminacion logica.
- La busqueda/filtro vive en `TasksController` para poder probar reglas sin UI,
  y `TareasFilterBar` solo traduce controles visibles a estado.
- La validacion de preferencias quedo en `PreferencesHelper`, que es la frontera
  con almacenamiento local.
- El manejo visible de errores usa `lastError` en controller y snackbars en UI,
  evitando cerrar modales como si la operacion hubiera sido exitosa.

Documentacion actualizada:

- `docs/requerimientos/requerimientos_funcionales.md`
- `docs/requerimientos/requerimientos_no_funcionales.md`
- `docs/requerimientos/trazabilidad.md`
- `docs/pruebas.md`
- `docs/casos_prueba.md`
