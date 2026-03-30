import 'package:sqflite/sqflite.dart';
import 'package:agenda/core/db/database_helper.dart';
import 'package:agenda/features/horario/domain/clase.dart';

class ClaseDao {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<int> insertClase(Clase clase) async {
    final db = await dbHelper.initDB();
    return await db.insert(
      "clases",
      clase.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Clase>> getClases() async {
    final db = await dbHelper.initDB();
    final result = await db.query("clases");
    return result.map((map) => Clase.fromMap(map)).toList();
  }

  Future<int> updateClase(Clase clase) async {
    final db = await dbHelper.initDB();
    return await db.update(
      "clases",
      clase.toMap(),
      where: "id = ?",
      whereArgs: [clase.id],
    );
  }

  Future<int> deleteClase(String id) async {
    final db = await dbHelper.initDB();
    return await db.delete("clases", where: "id = ?", whereArgs: [id]);
  }
}
