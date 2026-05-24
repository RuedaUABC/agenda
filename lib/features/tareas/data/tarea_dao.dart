import 'package:sqflite/sqflite.dart';
import 'package:agenda/core/db/database_helper.dart';
import 'package:agenda/features/tareas/domain/tarea.dart';

class TareaDao {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<int> insertTarea(Tarea tarea) async {
    final db = await dbHelper.initDB();
    return await db.insert(
      "tareas",
      tarea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Tarea>> getTareas() async {
    final db = await dbHelper.initDB();
    final result = await db.query(
      "tareas",
      where: "eliminada = ?",
      whereArgs: [0],
    );
    return result.map((map) => Tarea.fromMap(map)).toList();
  }

  Future<List<Tarea>> getTareasEliminadas() async {
    final db = await dbHelper.initDB();
    final result = await db.query(
      "tareas",
      where: "eliminada = ?",
      whereArgs: [1],
    );
    return result.map((map) => Tarea.fromMap(map)).toList();
  }

  Future<List<Tarea>> getTodasLasTareas() async {
    final db = await dbHelper.initDB();
    final result = await db.query("tareas");
    return result.map((map) => Tarea.fromMap(map)).toList();
  }

  Future<int> updateTarea(Tarea tarea) async {
    final db = await dbHelper.initDB();
    return await db.update(
      "tareas",
      tarea.toMap(),
      where: "id = ?",
      whereArgs: [tarea.id],
    );
  }

  Future<int> deleteTarea(String id) async {
    final db = await dbHelper.initDB();
    return await db.update(
      "tareas",
      {"eliminada": 1},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteTareaDefinitiva(String id) async {
    final db = await dbHelper.initDB();
    return await db.delete("tareas", where: "id = ?", whereArgs: [id]);
  }

  Future<int> restoreTarea(String id) async {
    final db = await dbHelper.initDB();
    return await db.update(
      "tareas",
      {"eliminada": 0},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTareas() async {
    final db = await dbHelper.initDB();
    return await db.delete("tareas");
  }
}
