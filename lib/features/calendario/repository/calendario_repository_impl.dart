import '../domain/evento.dart';
import '../data/evento_dao.dart';
import 'calendario_repository.dart';

class CalendarioRepositoryImpl implements CalendarioRepository {
  final EventoDao eventoDao;

  CalendarioRepositoryImpl({required this.eventoDao});

  @override
  Future<List<Evento>> fetchEventos() async {
    return await eventoDao.getEventos();
  }

  @override
  Future<void> addEvento(Evento evento) async {
    await eventoDao.insertEvento(evento);
  }

  @override
  Future<void> updateEvento(Evento evento) async {
    await eventoDao.updateEvento(evento);
  }

  @override
  Future<void> deleteEvento(String id) async {
    await eventoDao.deleteEvento(id);
  }
}
