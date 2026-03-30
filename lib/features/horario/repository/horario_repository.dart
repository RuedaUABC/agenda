import '../domain/clase.dart';

abstract class HorarioRepository {
  Future<List<Clase>> fetchClases();
  Future<void> addClase(Clase clase);
  Future<void> updateClase(Clase clase);
  Future<void> deleteClase(String id);
}
