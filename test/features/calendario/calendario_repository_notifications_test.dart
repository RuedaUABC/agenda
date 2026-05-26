import 'package:agenda/core/utils/notification_scheduler.dart';
import 'package:agenda/features/calendario/data/evento_dao.dart';
import 'package:agenda/features/calendario/domain/evento.dart';
import 'package:agenda/features/calendario/repository/calendario_repository_impl.dart';
import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeEventoStore implements EventoStore {
  final List<Evento> eventos;

  _FakeEventoStore([List<Evento>? initial]) : eventos = initial ?? [];

  @override
  Future<int> deleteAllEventos() async {
    eventos.clear();
    return 1;
  }

  @override
  Future<int> deleteEvento(String id) async {
    eventos.removeWhere((evento) => evento.id == id);
    return 1;
  }

  @override
  Future<List<Evento>> getEventos() async => List<Evento>.from(eventos);

  @override
  Future<int> insertEvento(Evento evento) async {
    eventos.add(evento);
    return 1;
  }

  @override
  Future<int> updateEvento(Evento evento) async {
    final index = eventos.indexWhere((item) => item.id == evento.id);
    if (index == -1) {
      eventos.add(evento);
    } else {
      eventos[index] = evento;
    }
    return 1;
  }
}

class _FakeScheduler extends NotificationScheduler {
  final scheduled = <String, DateTime>{};
  final cancelled = <String>[];

  @override
  Future<void> scheduleNotification({
    required String id,
    required DateTime when,
    required String title,
    required String body,
  }) async {
    scheduled[id] = when;
  }

  @override
  Future<void> cancelNotification(String id) async {
    cancelled.add(id);
    scheduled.remove(id);
  }
}

Evento _futureEvento(String id, {DateTime? inicio}) {
  final start = inicio ?? DateTime.now().add(const Duration(days: 3));
  return Evento(
    id: id,
    titulo: 'Parcial',
    inicio: start,
    fin: start.add(const Duration(hours: 1)),
  );
}

Future<PreferencesHelper> _prefs({int eventoMinutes = 30}) async {
  SharedPreferences.setMockInitialValues({
    'evento_notificacion_minutes': eventoMinutes,
  });
  final prefs = PreferencesHelper();
  await prefs.init();
  return prefs;
}

void main() {
  test('agenda aviso futuro al crear evento', () async {
    final scheduler = _FakeScheduler();
    final repo = CalendarioRepositoryImpl(
      eventoStore: _FakeEventoStore(),
      prefs: await _prefs(eventoMinutes: 30),
      scheduler: scheduler,
    );
    final evento = _futureEvento('evt-1');

    await repo.addEvento(evento);

    expect(
      scheduler.scheduled['evento_evt-1'],
      evento.inicio.subtract(const Duration(minutes: 30)),
    );
  });

  test('reprograma evento al actualizar preferencia', () async {
    final scheduler = _FakeScheduler();
    final evento = _futureEvento('evt-2');
    final repo = CalendarioRepositoryImpl(
      eventoStore: _FakeEventoStore([evento]),
      prefs: await _prefs(eventoMinutes: 60),
      scheduler: scheduler,
    );

    await repo.programarNotificacionEvento(evento.id);

    expect(scheduler.cancelled, contains('evento_evt-2'));
    expect(
      scheduler.scheduled['evento_evt-2'],
      evento.inicio.subtract(const Duration(minutes: 60)),
    );
  });

  test('cancela aviso al eliminar evento', () async {
    final scheduler = _FakeScheduler();
    final repo = CalendarioRepositoryImpl(
      eventoStore: _FakeEventoStore([_futureEvento('evt-3')]),
      prefs: await _prefs(),
      scheduler: scheduler,
    );

    await repo.deleteEvento('evt-3');

    expect(scheduler.cancelled, contains('evento_evt-3'));
  });

  test('sin recordatorio cancela y no agenda evento', () async {
    final scheduler = _FakeScheduler();
    final evento = _futureEvento('evt-4');
    final repo = CalendarioRepositoryImpl(
      eventoStore: _FakeEventoStore([evento]),
      prefs: await _prefs(eventoMinutes: 0),
      scheduler: scheduler,
    );

    await repo.programarNotificacionEvento(evento.id);

    expect(scheduler.cancelled, contains('evento_evt-4'));
    expect(scheduler.scheduled, isEmpty);
  });
}
