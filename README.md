# agenda

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Diagrama de clases

```mermaid
classDiagram
    %% ================= CORE =================
    class DatabaseHelper {
      -Database? _db
      +Future~Database~ initDB()
      +Future~void~ closeDB()
    }

    class PreferencesHelper {
      -SharedPreferences _prefs
      +Future~void~ init()
      +Duration getGlobalClaseNotificacion()
      +List~Duration~ getGlobalTareaNotificaciones()
      +Future~void~ setGlobalClaseNotificacion(Duration d)
      +Future~void~ setGlobalTareaNotificaciones(List~Duration~ ds)
    }

    class NotificationScheduler {
      -FlutterLocalNotificationsPlugin _plugin
      +Future~void~ init()
      +Future~void~ scheduleNotification(String id, DateTime when, String title, String body)
      +Future~void~ cancelNotification(String id)
      +Future~void~ cancelNotificationsForRange(DateTime start, DateTime end)
    }

    class AppTheme {
      +ThemeData lightTheme
      +ThemeData darkTheme
    }

    class Utils {
      +String formatDate(DateTime fecha)
      +bool validarTexto(String texto)
      +DateTime nextOccurrenceWeekly(DateTime base, int weekday)
    }

    %% ================= FEATURE: TAREAS =================
    class Tarea {
      +String id
      +String titulo
      +String asignatura
      +String descripcion
      +DateTime fecha
      +bool completada
    }

    class Notificacion {
      +String id
      +String tareaId
      +Duration tiempoAntes
      +String mensaje
      +bool activo
    }

    class TareaDao {
      -DatabaseHelper dbHelper
    }

    class NotificacionDao {
      -DatabaseHelper dbHelper
    }

    class TareaService {
      -String baseUrl
    }

    class TareaRepository {
      <<interface>>
      +Future~List~Tarea~~ fetchTareas()
      +Future~void~ addTarea(Tarea tarea)
      +Future~void~ updateTarea(Tarea tarea)
      +Future~void~ deleteTarea(String id)
      +Future~void~ programarNotificacionesTarea(String tareaId)
    }

    class TareaRepositoryImpl {
      -TareaDao tareaDao
      -NotificacionDao notifDao
      -TareaService tareaService
      -PreferencesHelper prefs
      -NotificationScheduler scheduler
    }

    class TasksController {
      -TareaRepository repository
      +List~Tarea~ tareas
      +bool isLoading
      +Future~void~ loadTareas()
      +Future~void~ createTarea(Tarea tarea)
    }

    class TasksPage {
      -TasksController controller
      +Widget build(BuildContext context)
    }

    %% ================= FEATURE: HORARIO =================
    class Clase {
      +String id
      +String materia
      +TimeOfDay inicio
      +TimeOfDay fin
      +String aula
      +bool recurrenteSemanal
    }

    class NotificacionClase {
      +String id
      +String claseId
      +Duration tiempoAntes
      +bool activo
    }

    class ClaseDao {
      -DatabaseHelper dbHelper
    }

    class NotificacionClaseDao {
      -DatabaseHelper dbHelper
    }

    class ClaseRepository {
      <<interface>>
      +Future~List~Clase~~ fetchClases()
      +Future~void~ addClase(Clase clase)
    }

    class ClaseRepositoryImpl {
      -ClaseDao claseDao
      -NotificacionClaseDao notifDao
      -DiasSinClaseDao diasSinClaseDao
      -PreferencesHelper prefs
      -NotificationScheduler scheduler
    }

    class ScheduleController {
      -ClaseRepository repository
      +List~Clase~ clases
      +bool isLoading
      +Future~void~ loadClases()
      +Future~void~ createClase(Clase clase)
    }

    class SchedulePage {
      -ScheduleController controller
      -KalenderController kalenderController
      +Widget build(BuildContext context)
    }

    %% ================= FEATURE: CALENDARIO =================
    class Evento {
      +String id
      +String titulo
      +DateTime fechaInicio
      +DateTime fechaFin
    }

    class DiaSinClase {
      +String id
      +DateTime fechaInicio
      +DateTime fechaFin
      +String motivo
    }

    class EventoDao {
      -DatabaseHelper dbHelper
    }

    class DiasSinClaseDao {
      -DatabaseHelper dbHelper
    }

    class EventoRepository {
      <<interface>>
      +Future~List~Evento~~ fetchEventos()
      +Future~void~ addEvento(Evento evento)
      +Future~List~DiaSinClase~~ fetchDiasSinClase()
      +Future~void~ addDiaSinClase(DiaSinClase dia)
    }

    class EventoRepositoryImpl {
      -EventoDao eventoDao
      -DiasSinClaseDao diasDao
    }

    class CalendarController {
      -EventoRepository repository
      +List~Evento~ eventos
      +List~DiaSinClase~ diasSinClase
      +bool isLoading
      +Future~void~ loadCalendarData()
    }

    class CalendarPage {
      -CalendarController controller
      -KalenderController kalenderController
      +Widget build(BuildContext context)
    }

    %% ================= FEATURE: CONFIGURACION =================
    class SettingsController {
      -PreferencesHelper prefs
      -ClaseRepository claseRepo
      -TareaRepository tareaRepo
      +Duration globalClaseNotif
      +List~Duration~ globalTareaNotifs
      +Future~void~ loadSettings()
      +Future~void~ updateGlobalClaseNotif(Duration d)
      +Future~void~ updateGlobalTareaNotifs(List~Duration~ ds)
    }

    class SettingsPage {
      -SettingsController controller
      +Widget build(BuildContext context)
    }

    class NotificacionConfigWidget {
      -SettingsController controller
      +Widget build()
    }

    %% ================= FEATURE: NAVEGACION =================
    class AppNavigation {
      -int _currentIndex
      -List~Widget~ _pages
      +Widget build(BuildContext context)
    }

    %% ================= RELACIONES =================
    %% DAOs y DB
    TareaDao *-- DatabaseHelper
    NotificacionDao *-- DatabaseHelper
    ClaseDao *-- DatabaseHelper
    NotificacionClaseDao *-- DatabaseHelper
    EventoDao *-- DatabaseHelper
    DiasSinClaseDao *-- DatabaseHelper

    %% Tareas
    TareaRepositoryImpl ..|> TareaRepository
    TareaRepositoryImpl *-- TareaDao
    TareaRepositoryImpl *-- NotificacionDao
    TareaRepositoryImpl *-- TareaService
    TareaRepositoryImpl o-- PreferencesHelper
    TareaRepositoryImpl o-- NotificationScheduler
    TasksController o-- TareaRepository
    TasksPage o-- TasksController

    %% Horario
    ClaseRepositoryImpl ..|> ClaseRepository
    ClaseRepositoryImpl *-- ClaseDao
    ClaseRepositoryImpl *-- NotificacionClaseDao
    ClaseRepositoryImpl *-- DiasSinClaseDao
    ClaseRepositoryImpl o-- PreferencesHelper
    ClaseRepositoryImpl o-- NotificationScheduler
    ScheduleController o-- ClaseRepository
    SchedulePage o-- ScheduleController

    %% Calendario
    EventoRepositoryImpl ..|> EventoRepository
    EventoRepositoryImpl *-- EventoDao
    EventoRepositoryImpl *-- DiasSinClaseDao
    CalendarController o-- EventoRepository
    CalendarPage o-- CalendarController

    %% Configuración
    SettingsController o-- PreferencesHelper
    SettingsController o-- ClaseRepository
    SettingsController o-- TareaRepository
    SettingsPage o-- SettingsController
    NotificacionConfigWidget o-- SettingsController
    SettingsPage *-- NotificacionConfigWidget

    %% Navegación
    AppNavigation *-- TasksPage
    AppNavigation *-- SchedulePage
    AppNavigation *-- CalendarPage
    AppNavigation *-- SettingsPage
```
