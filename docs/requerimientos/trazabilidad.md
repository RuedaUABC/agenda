# Trazabilidad de Requerimientos

Este documento relaciona requerimientos con casos de uso, reglas de negocio,
pruebas y evidencia tecnica observada en el proyecto.

## Matriz Principal

| Requisito | Estado | Casos de uso | Reglas | Pruebas / evidencia |
| --- | --- | --- | --- | --- |
| RF-001 | Implementado | CU-001 | - | `lib/features/navegacion/presentation/navegacion.dart` |
| RF-002 | Implementado | CU-001 | - | `lib/features/navegacion/presentation/navegacion.dart` |
| RF-003 | Implementado | CU-005 | RN-009 | `lib/features/tareas/data/tarea_dao.dart`, `lib/features/tareas/presentation/taskcontroller.dart` |
| RF-004 | Implementado | CU-004 | RN-008 | `lib/features/tareas/data/tarea_dao.dart`, `lib/features/tareas/presentation/taskcontroller.dart` |
| RF-005 | Implementado | CU-002 | RN-001, RN-002, RN-006 | `lib/features/tareas/presentation/widgets/tarea_form.dart` |
| RF-006 | Parcial | CU-002 | RN-001, RN-002, RN-003, RN-004, RN-005 | `lib/features/tareas/presentation/widgets/tarea_form.dart`, `test/widget_test.dart` |
| RF-007 | Implementado | CU-003 | RN-001, RN-002, RN-003, RN-004 | `lib/features/tareas/presentation/widgets/tarea_form.dart`, `lib/features/tareas/presentation/widgets/lista_tareas_categoria.dart` |
| RF-008 | Implementado | CU-003 | RN-015, RN-016 | `lib/features/tareas/presentation/widgets/lista_tareas_categoria.dart` |
| RF-009 | Implementado | CU-003 | RN-007 | `lib/features/tareas/data/tarea_dao.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-010 | Implementado | CU-004 | RN-010 | `lib/features/tareas/data/tarea_dao.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-011 | Sugerido | CU-004 | RN-011 | Pendiente de implementacion |
| RF-012 | Implementado | CU-002, CU-005 | RN-012, RN-013, RN-014, RN-015, RN-016 | `lib/features/tareas/presentation/taskcontroller.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-013 | Implementado | CU-005 | RN-017, RN-018 | `lib/features/tareas/presentation/taskcontroller.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-014 | Implementado | CU-005 | RN-019 | `lib/features/tareas/presentation/taskcontroller.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-015 | Implementado | CU-003 | - | `lib/features/tareas/presentation/widgets/lista_tareas_categoria.dart` |
| RF-016 | Sugerido | CU-005 | - | Pendiente de implementacion |
| RF-017 | Implementado | CU-007 | - | `lib/features/horario/presentation/horario_controller.dart`, `lib/features/horario/data/clase_dao.dart` |
| RF-018 | Implementado | CU-006 | RN-020, RN-021, RN-022, RN-023 | `lib/features/horario/presentation/widgets/clase_form.dart` |
| RF-019 | Parcial | CU-006 | RN-020, RN-024, RN-026, RN-027, RN-028 | `lib/features/horario/presentation/widgets/clase_form.dart`, `test/features/horario/clase_form_test.dart` |
| RF-020 | Implementado | CU-006 | RN-029, RN-030, RN-031, RN-032, RN-033, RN-034 | `lib/features/horario/presentation/widgets/clase_form.dart`, `lib/features/horario/presentation/horario_controller.dart` |
| RF-021 | Implementado | CU-006, CU-007 | - | `lib/features/horario/presentation/mobile.dart`, `lib/features/horario/presentation/desktop.dart` |
| RF-022 | Implementado | CU-006, CU-007 | - | `lib/features/horario/presentation/mobile.dart`, `lib/features/horario/presentation/desktop.dart` |
| RF-023 | Implementado | CU-006 | RN-020, RN-024 | `lib/features/horario/presentation/horario_controller.dart`, `test/features/horario/horario_controller_test.dart` |
| RF-024 | Implementado | CU-006 | - | `lib/features/horario/presentation/horario_controller.dart`, `test/features/horario/horario_controller_test.dart` |
| RF-025 | Implementado | CU-008 | - | `lib/features/calendario/presentation/calendario_controller.dart`, `lib/features/calendario/data/evento_dao.dart` |
| RF-026 | Implementado | CU-008 | - | `lib/features/calendario/presentation/mobile.dart`, `lib/features/calendario/presentation/desktop.dart` |
| RF-027 | Implementado | CU-008 | - | `lib/features/calendario/presentation/calendario_controller.dart`, `test/features/calendario/calendario_controller_test.dart` |
| RF-028 | Implementado | CU-008 | RN-043, RN-044 | `lib/features/calendario/presentation/mobile.dart`, `lib/features/calendario/presentation/desktop.dart` |
| RF-029 | Implementado | CU-008 | RN-045 | `lib/features/calendario/presentation/mobile.dart`, `lib/features/calendario/presentation/desktop.dart` |
| RF-030 | Pendiente | CU-009 | RN-036, RN-037, RN-038, RN-039, RN-040, RN-041, RN-042, RN-045, RN-046 | `lib/features/calendario/presentation/calendario.dart` contiene TODO |
| RF-031 | Pendiente | CU-009 | RN-036, RN-037, RN-038, RN-039, RN-041, RN-042, RN-046 | `lib/features/calendario/presentation/desktop.dart` contiene TODO |
| RF-032 | Pendiente | CU-009 | - | Pendiente de implementacion en UI |
| RF-033 | Sugerido | CU-009 | RN-046 | Pendiente de implementacion |
| RF-034 | Implementado | CU-010 | RN-047, RN-048 | `lib/features/configuracion/preferences_helper.dart`, `lib/features/configuracion/presentation/settings_controller.dart` |
| RF-035 | Implementado | CU-010 | RN-047, RN-049 | `lib/features/configuracion/presentation/notificacion_config_widget.dart` |
| RF-036 | Implementado | CU-010 | RN-048, RN-049, RN-051 | `lib/features/configuracion/presentation/notificacion_config_widget.dart` |
| RF-037 | Sugerido | CU-010 | RN-049, RN-050 | Pendiente de reforzar validaciones |
| RF-038 | Implementado | CU-010 | - | `lib/features/configuracion/preferences_helper.dart` |
| RF-039 | Implementado | CU-010 | RN-052 | `lib/features/configuracion/presentation/settings_controller.dart`, `test/features/configuracion/settings_controller_test.dart` |
| RF-040 | Implementado | CU-002, CU-006, CU-008, CU-010 | RN-054, RN-055, RN-056 | `lib/core/db/database_helper.dart`, DAOs de tareas, clases y eventos |
| RF-041 | Implementado | - | RN-058, RN-059 | `lib/core/db/database_helper.dart` |
| RF-042 | Implementado | - | - | `lib/main.dart` |

## Requerimientos No Funcionales

| Requisito | Evidencia / verificacion |
| --- | --- |
| RNF-001 | `pubspec.yaml`, carpetas `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/` |
| RNF-002 | `pubspec.yaml` |
| RNF-003 | `lib/main.dart` |
| RNF-004 | `lib/features/` |
| RNF-005 | Estructura `domain/`, `data/`, `repository/`, `presentation/` por feature |
| RNF-006 | `lib/core/` |
| RNF-007 | `test/features/*/*controller_test.dart` |
| RNF-008 | Revision arquitectonica sugerida |
| RNF-009 | `lib/core/utils/responsive_layout.dart` |
| RNF-010 | `lib/core/theme/app_theme.dart` |
| RNF-011 | Pantallas principales de features |
| RNF-012 | Horario, calendario y listas de tareas |
| RNF-013 | Pendiente de revisar todos los formularios |
| RNF-014 | `lib/core/db/database_helper.dart`, `shared_preferences` |
| RNF-015 | Modelos de dominio y pruebas de serializacion |
| RNF-016 | Modelo y DAO de tareas |
| RNF-017 | Pendiente de reforzar en dominio/persistencia |
| RNF-018 | `test/features/` |
| RNF-019 | `test/features/models_serialization_test.dart` |
| RNF-020 | Pruebas de formularios y widgets |
| RNF-021 | Pendiente de ampliar cobertura |
| RNF-022 | Pendiente de revisar confirmaciones en UI |
| RNF-023 | Pendiente de manejo visible de errores locales |
| RNF-024 | Politica sugerida |
| RNF-025 | `lib/core/utils/notification_scheduler.dart` |
| RNF-026 | `lib/core/utils/notification_scheduler.dart` tiene implementacion parcial/mock |

## Brechas y Sugerencias

| Item | Estado | Descripcion |
| --- | --- | --- |
| Crear eventos desde UI | Pendiente | Existe soporte de dominio/controller, pero falta formulario conectado en la interfaz. |
| Editar eventos desde UI | Pendiente | Existen TODO relacionados con edicion desde calendario. |
| Eliminar eventos desde UI | Pendiente | Falta accion visible y confirmacion de eliminacion. |
| Validaciones completas de tareas | Parcial | Se valida titulo, pero faltan longitud maxima, espacios y advertencia de fecha pasada. |
| Validaciones completas de clases | Parcial | Se valida materia y rango horario, pero faltan longitud maxima, espacios y conflicto horario. |
| Validaciones completas de eventos | Pendiente | Deben implementarse junto con el formulario de eventos. |
| Confirmaciones destructivas | Sugerido | Conviene confirmar eliminaciones de tareas, clases y eventos. |
| Busqueda y filtrado de tareas | Sugerido | Mejoraria usabilidad cuando existan muchas tareas. |
| Notificaciones nativas reales | Parcial | La implementacion actual no debe tratarse como notificacion nativa completa. |
