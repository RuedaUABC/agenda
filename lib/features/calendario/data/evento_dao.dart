import 'package:sqflite/sqflite.dart';
import 'package:agenda/core/db/database_helper.dart';
import 'package:agenda/features/calendario/domain/evento.dart';

class EventoDao {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<int> insertEvento(Evento evento) async {
    final db = await dbHelper.initDB();
    return await db.insert(
      "eventos",
      evento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Evento>> getEventos() async {
    final db = await dbHelper.initDB();
    final result = await db.query("eventos");
    return result.map((map) => Evento.fromMap(map)).toList();
  }

  Future<int> updateEvento(Evento evento) async {
    final db = await dbHelper.initDB();
    return await db.update(
      "eventos",
      evento.toMap(),
      where: "id = ?",
      whereArgs: [evento.id],
    );
  }

  Future<int> deleteEvento(String id) async {
    final db = await dbHelper.initDB();
    return await db.delete("eventos", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAllEventos() async {
    final db = await dbHelper.initDB();
    return await db.delete("eventos");
  }
}
