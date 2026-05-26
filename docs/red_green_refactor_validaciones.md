# Red Green Refactor: Validaciones de Tareas y Clases

Fecha: 2026-05-23.

## Alcance

Este ciclo cubre:

- RF-006: validaciones implementadas de tareas.
- RF-019: validacion completa de clases.
- RN-001 a RN-005: reglas de tarea relacionadas con titulo, fecha,
  normalizacion, longitudes y advertencia de pasado.
- RN-060: rechazo de tareas duplicadas exactas normalizadas.
- RN-020, RN-024, RN-026, RN-027 y RN-028: reglas de clase relacionadas con
  materia, rango horario, normalizacion, longitudes y solapamientos.

## Red

Se agregaron pruebas antes de implementar las reglas faltantes:

- `test/features/tareas/tarea_form_test.dart`
  - rechaza titulo compuesto solo por espacios.
  - normaliza titulo, asignatura y descripcion antes de guardar.
  - aplica limites maximos para titulo, asignatura y descripcion.
  - solicita confirmacion si la fecha y hora estan en el pasado.
  - rechaza duplicados exactos normalizados al crear.
  - rechaza duplicar otra tarea durante edicion, excluyendo el mismo id.
- `test/features/horario/clase_form_test.dart`
  - aplica limites maximos para materia y aula.
  - impide guardar una clase que se solapa con otra clase del mismo dia.

Evidencia Red:

```powershell
flutter test test\features\tareas\tarea_form_test.dart test\features\horario\clase_form_test.dart
```

Resultado esperado en esta fase: falla de compilacion por ausencia de los
parametros `now` en `TareaForm` y `clases` en `ClaseForm`.

## Green

Se implemento el comportamiento minimo para pasar las pruebas:

- `lib/features/tareas/presentation/widgets/tarea_form.dart`
  - agrega reloj inyectable `now` para probar fechas pasadas sin depender del
    reloj real.
  - valida titulo vacio o solo espacios.
  - valida longitudes maximas: titulo 120, asignatura 80 y descripcion 500.
  - guarda textos con `trim()`.
  - muestra confirmacion "Fecha en el pasado" antes de guardar tareas vencidas.
  - compara titulo, asignatura, descripcion, fecha y hora normalizados contra
    tareas activas y papelera para impedir duplicados exactos.
  - excluye la tarea con el mismo identificador durante la edicion.
- `lib/features/horario/presentation/widgets/clase_form.dart`
  - recibe `clases` existentes.
  - valida longitudes maximas: materia 120 y aula 80.
  - bloquea el guardado cuando el horario se solapa con otra clase del mismo
    dia de la semana.
- `lib/features/horario/presentation/horario.dart`
  - pasa `controller.clases` al formulario para evaluar solapamientos.

Politica definida para RF-019: ante solapamiento de clase, el sistema impide el
guardado y muestra un mensaje visible.

Evidencia Green:

```powershell
flutter test test\features\tareas\tarea_form_test.dart test\features\horario\clase_form_test.dart
```

Resultado: pruebas focalizadas en verde.

## Refactor

- Se mantuvieron las reglas cerca de los formularios porque son validaciones de
  captura y no requirieron cambios de esquema ni repositorio.
- `TareaForm` usa un reloj inyectable solo para hacer deterministica la prueba
  de fecha pasada.
- La comparacion de duplicados se mantiene en el formulario porque depende del
  conjunto cargado en el controller y evita persistir una captura invalida.
- `ClaseForm` compara clases recurrentes por dia de semana y minutos del dia,
  evitando depender de que las fechas base sean exactamente la misma semana.

Documentacion actualizada:

- `docs/requerimientos/requerimientos_funcionales.md`
- `docs/requerimientos/trazabilidad.md`
- `docs/requerimientos/README.md`
- `docs/pruebas.md`
- `docs/casos_prueba.md`
