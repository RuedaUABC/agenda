# Trazabilidad de Requerimientos

Este documento relaciona requerimientos con los archivos donde se observo el
comportamiento.

## Navegacion

| Requerimiento | Evidencia |
| --- | --- |
| RF-001 | `lib/features/navegacion/presentation/navegacion.dart` |
| RF-002 | `lib/features/navegacion/presentation/navegacion.dart` |

## Tareas

| Requerimiento | Evidencia |
| --- | --- |
| RF-003 | `lib/features/tareas/data/tarea_dao.dart`, `lib/features/tareas/presentation/taskcontroller.dart` |
| RF-004 | `lib/features/tareas/data/tarea_dao.dart`, `lib/features/tareas/presentation/taskcontroller.dart` |
| RF-005 | `lib/features/tareas/presentation/widgets/tarea_form.dart` |
| RF-006 | `lib/features/tareas/presentation/widgets/tarea_form.dart`, `test/widget_test.dart` |
| RF-007 | `lib/features/tareas/presentation/widgets/tarea_form.dart`, `lib/features/tareas/presentation/widgets/lista_tareas_categoria.dart` |
| RF-008 | `lib/features/tareas/presentation/widgets/lista_tareas_categoria.dart` |
| RF-009 | `lib/features/tareas/data/tarea_dao.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-010 | `lib/features/tareas/data/tarea_dao.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-011 | `lib/features/tareas/presentation/taskcontroller.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-012 | `lib/features/tareas/presentation/taskcontroller.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-013 | `lib/features/tareas/presentation/taskcontroller.dart`, `test/features/tareas/taskcontroller_test.dart` |
| RF-014 | `lib/features/tareas/presentation/widgets/lista_tareas_categoria.dart` |

## Horario

| Requerimiento | Evidencia |
| --- | --- |
| RF-015 | `lib/features/horario/presentation/horario_controller.dart`, `lib/features/horario/data/clase_dao.dart` |
| RF-016 | `lib/features/horario/presentation/widgets/clase_form.dart` |
| RF-017 | `lib/features/horario/presentation/widgets/clase_form.dart`, `test/features/horario/clase_form_test.dart` |
| RF-018 | `lib/features/horario/presentation/widgets/clase_form.dart` |
| RF-019 | `lib/features/horario/presentation/widgets/clase_form.dart`, `lib/features/horario/presentation/horario_controller.dart` |
| RF-020 | `lib/features/horario/presentation/mobile.dart`, `lib/features/horario/presentation/desktop.dart` |
| RF-021 | `lib/features/horario/presentation/mobile.dart`, `lib/features/horario/presentation/desktop.dart` |
| RF-022 | `lib/features/horario/presentation/horario_controller.dart`, `test/features/horario/horario_controller_test.dart` |

## Calendario

| Requerimiento | Evidencia |
| --- | --- |
| RF-023 | `lib/features/calendario/presentation/calendario_controller.dart`, `lib/features/calendario/data/evento_dao.dart` |
| RF-024 | `lib/features/calendario/presentation/mobile.dart`, `lib/features/calendario/presentation/desktop.dart` |
| RF-025 | `lib/features/calendario/presentation/calendario_controller.dart`, `test/features/calendario/calendario_controller_test.dart` |
| RF-026 | `lib/features/calendario/presentation/mobile.dart`, `lib/features/calendario/presentation/desktop.dart` |
| RF-027 | `lib/features/calendario/presentation/mobile.dart`, `lib/features/calendario/presentation/desktop.dart` |
| RF-028 | `lib/features/calendario/presentation/calendario_controller.dart`, `test/features/calendario/calendario_controller_test.dart` |
| RF-029 | `lib/features/calendario/presentation/calendario.dart`, `lib/features/calendario/presentation/desktop.dart` |

## Configuracion

| Requerimiento | Evidencia |
| --- | --- |
| RF-030 | `lib/features/configuracion/preferences_helper.dart`, `lib/features/configuracion/presentation/settings_controller.dart` |
| RF-031 | `lib/features/configuracion/presentation/notificacion_config_widget.dart` |
| RF-032 | `lib/features/configuracion/presentation/notificacion_config_widget.dart` |
| RF-033 | `lib/features/configuracion/preferences_helper.dart` |
| RF-034 | `lib/features/configuracion/presentation/settings_controller.dart`, `test/features/configuracion/settings_controller_test.dart` |

## Autenticacion

| Requerimiento | Evidencia |
| --- | --- |
| RF-035 | `lib/features/auth/presentation/login_page.dart`, `lib/features/auth/data/auth_service.dart` |
| RF-036 | `lib/features/auth/data/auth_service.dart` |
| RF-037 | `lib/main.dart`, `lib/features/auth/presentation/login_page.dart` |

## Persistencia y Plataforma

| Requerimiento | Evidencia |
| --- | --- |
| RF-038 | `lib/core/db/database_helper.dart`, DAOs de tareas, clases y eventos |
| RF-039 | `lib/core/db/database_helper.dart` |
| RF-040 | `lib/main.dart` |
| RNF-001 | `pubspec.yaml`, carpetas `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/` |
| RNF-008 | `lib/core/utils/responsive_layout.dart` |
| RNF-009 | `lib/main.dart`, `lib/core/theme/app_theme.dart` |
| RNF-015 | `test/features/` |

## Requerimientos Parciales o Pendientes

| Item | Estado | Evidencia |
| --- | --- | --- |
| Notificaciones reales | Parcial | `lib/core/utils/notification_scheduler.dart` tiene implementacion mock |
| Firebase Auth en flujo inicial | Parcial | `lib/main.dart` no inicializa Firebase y usa `nav` directamente |
| Crear eventos desde UI | Pendiente | `lib/features/calendario/presentation/calendario.dart` contiene `TODO` |
| Editar eventos desde UI | Pendiente | `lib/features/calendario/presentation/desktop.dart` contiene `TODO` |
