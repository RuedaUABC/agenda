# Red Green Refactor: Eventos de Calendario

Fecha: 2026-05-23.

## Alcance

Este ciclo cubre:

- RF-030: crear eventos desde la UI.
- RF-031: editar eventos desde la UI.
- RF-032: eliminar eventos desde la UI con confirmacion.
- RN-036 a RN-042, RN-045 y RN-046: validaciones completas de eventos.

## Red

Se agregaron pruebas antes de implementar la funcionalidad:

- `test/features/calendario/evento_validator_test.dart`
  - titulo obligatorio y longitud maxima.
  - descripcion con longitud maxima.
  - inicio y fin obligatorios.
  - fin no anterior al inicio.
  - evento puntual permitido cuando inicio y fin son iguales.
  - normalizacion de textos y color por defecto.
  - deteccion de superposiciones excluyendo el evento editado.
- `test/features/calendario/evento_form_test.dart`
  - validacion visible de titulo obligatorio.
  - creacion de evento normalizado con horario por defecto.
  - edicion conservando `id`.
  - bloqueo de guardado cuando existe superposicion.
- `test/features/calendario/calendario_widgets_test.dart`
  - el boton agregar abre el formulario y crea evento.
  - el tap en desktop selecciona evento para edicion.
  - la accion de eliminar pide confirmacion antes de borrar.

Evidencia Red:

```powershell
flutter test test\features\calendario
```

Resultado esperado en esta fase: falla de compilacion por ausencia de
`EventoValidator`, `EventoForm`, parametros de callbacks y color por defecto.

## Green

Se implemento el comportamiento minimo para pasar las pruebas:

- `lib/features/calendario/domain/evento.dart`
  - expone `Evento.defaultColor`.
- `lib/features/calendario/domain/evento_validator.dart`
  - centraliza normalizacion, limites, rango, color y superposiciones.
- `lib/features/calendario/presentation/widgets/evento_form.dart`
  - formulario reutilizable para crear y editar eventos.
  - valida antes de cerrar o persistir.
  - usa 08:00 a 09:00 como horario por defecto para eventos nuevos.
- `lib/features/calendario/presentation/widgets/evento_list_item.dart`
  - renderiza evento con accion visible de eliminacion.
  - muestra dialogo de confirmacion destructiva.
- `lib/features/calendario/presentation/calendario.dart`
  - conecta el FAB con `EventoForm`.
  - llama `addEvento`, `updateEvento` y `deleteEvento`.
- `lib/features/calendario/presentation/desktop.dart` y `mobile.dart`
  - usan callbacks para editar y eliminar eventos desde la lista.

Evidencia Green:

```powershell
flutter test test\features\calendario
```

Resultado: suite de calendario en verde.

## Refactor

Se separaron responsabilidades para mantener el modulo sencillo:

- Las reglas de negocio quedaron fuera del widget en `EventoValidator`.
- El render y confirmacion de cada evento quedaron en `EventoListItem`.
- El formulario no conoce el DAO ni el repositorio; devuelve un `Evento` valido
  para que `CalendarioPage` decida si crea o actualiza.
- `CalendarioPage` acepta un controller inyectado para pruebas de widget sin
  depender de SQLite real.

Documentacion actualizada:

- `docs/requerimientos/requerimientos_funcionales.md`
- `docs/requerimientos/trazabilidad.md`
- `docs/pruebas.md`
- `docs/arquitectura.md`
