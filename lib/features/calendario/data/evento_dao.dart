import 'package:sqflite/sqflite.dart';
import 'package:agenda/core/db/database_helper.dart';
import 'package:agenda/features/calendario/domain/evento.dart';

abstract class EventoStore {
  Future<int> insertEvento(Evento evento);
  Future<List<Evento>> getEventos();
  Future<int> updateEvento(Evento evento);
  Future<int> deleteEvento(String id);
  Future<int> deleteAllEventos();
}

class EventoDao implements EventoStore {
  final DatabaseHelper dbHelper;

  EventoDao({DatabaseHelper? dbHelper})
    : dbHelper = dbHelper ?? DatabaseHelper();

  @override
  Future<int> insertEvento(Evento evento) async {
    final db = await dbHelper.initDB();
    return await db.insert(
      "eventos",
      evento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Evento>> getEventos() async {
    final db = await dbHelper.initDB();
    final result = await db.query("eventos");
    return result.map((map) => Evento.fromMap(map)).toList();
  }

  @override
  Future<int> updateEvento(Evento evento) async {
    final db = await dbHelper.initDB();
    return await db.update(
      "eventos",
      evento.toMap(),
      where: "id = ?",
      whereArgs: [evento.id],
    );
  }

  @override
  Future<int> deleteEvento(String id) async {
    final db = await dbHelper.initDB();
    return await db.delete("eventos", where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<int> deleteAllEventos() async {
    final db = await dbHelper.initDB();
    return await db.delete("eventos");
  }
}
