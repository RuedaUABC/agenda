import '../domain/evento.dart';

abstract class CalendarioRepository {
  Future<List<Evento>> fetchEventos();
  Future<void> addEvento(Evento evento);
  Future<void> updateEvento(Evento evento);
  Future<void> deleteEvento(String id);
}
