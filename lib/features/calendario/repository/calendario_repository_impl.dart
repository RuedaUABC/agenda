import '../domain/evento.dart';
import '../data/evento_dao.dart';
import 'calendario_repository.dart';
import '../../configuracion/preferences_helper.dart';
import '../../../core/utils/notification_scheduler.dart';

class CalendarioRepositoryImpl implements CalendarioRepository {
  final EventoStore eventoStore;
  final PreferencesHelper? prefs;
  final NotificationScheduler? scheduler;

  CalendarioRepositoryImpl({
    EventoStore? eventoStore,
    EventoDao? eventoDao,
    this.prefs,
    this.scheduler,
  }) : eventoStore = eventoStore ?? eventoDao ?? EventoDao();

  @override
  Future<List<Evento>> fetchEventos() async {
    return await eventoStore.getEventos();
  }

  @override
  Future<void> addEvento(Evento evento) async {
    await eventoStore.insertEvento(evento);
    await programarNotificacionEvento(evento.id);
  }

  @override
  Future<void> updateEvento(Evento evento) async {
    await eventoStore.updateEvento(evento);
    await programarNotificacionEvento(evento.id);
  }

  @override
  Future<void> deleteEvento(String id) async {
    await eventoStore.deleteEvento(id);
    await scheduler?.cancelNotification(_notificationId(id));
  }

  @override
  Future<void> programarNotificacionEvento(String eventoId) async {
    final scheduler = this.scheduler;
    final prefs = this.prefs;
    if (scheduler == null || prefs == null) return;

    await scheduler.cancelNotification(_notificationId(eventoId));

    final anticipation = prefs.getGlobalEventoNotificacion();
    if (anticipation == Duration.zero) return;

    final eventos = await eventoStore.getEventos();
    final matching = eventos.where((evento) => evento.id == eventoId);
    if (matching.isEmpty) return;

    final evento = matching.first;
    final when = evento.inicio.subtract(anticipation);
    if (!when.isAfter(DateTime.now())) return;

    await scheduler.scheduleNotification(
      id: _notificationId(evento.id),
      when: when,
      title: 'Recordatorio de evento',
      body: evento.titulo,
    );
  }

  String _notificationId(String eventoId) {
    return 'evento_$eventoId';
  }
}
