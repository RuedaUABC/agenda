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
    return await db.delete("tareas", where: "id = ?", whereArgs: [id]);
  }
}
