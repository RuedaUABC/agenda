import '../domain/clase.dart';
import '../data/clase_dao.dart';
import 'horario_repository.dart';

class HorarioRepositoryImpl implements HorarioRepository {
  final ClaseDao claseDao;

  HorarioRepositoryImpl({required this.claseDao});

  @override
  Future<List<Clase>> fetchClases() async {
    return await claseDao.getClases();
  }

  @override
  Future<void> addClase(Clase clase) async {
    await claseDao.insertClase(clase);
  }

  @override
  Future<void> updateClase(Clase clase) async {
    await claseDao.updateClase(clase);
  }

  @override
  Future<void> deleteClase(String id) async {
    await claseDao.deleteClase(id);
  }
}
