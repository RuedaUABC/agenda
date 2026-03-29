import 'package:sqflite/sqflite.dart';
import '../../../core/db/database_helper.dart';
import '../domain/notificacion.dart';

class NotificacionDao {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<int> insertNotificacion(Notificacion notif) async {
    final db = await dbHelper.initDB();
    return await db.insert(
      "notificaciones",
      notif.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Notificacion>> getNotificacionesByTarea(String tareaId) async {
    final db = await dbHelper.initDB();
    final result = await db.query(
      "notificaciones",
      where: "tareaId = ?",
      whereArgs: [tareaId],
    );
    return result.map((map) => Notificacion.fromMap(map)).toList();
  }

  Future<int> updateNotificacion(Notificacion notif) async {
    final db = await dbHelper.initDB();
    return await db.update(
      "notificaciones",
      notif.toMap(),
      where: "id = ?",
      whereArgs: [notif.id],
    );
  }

  Future<int> deleteNotificacion(String id) async {
    final db = await dbHelper.initDB();
    return await db.delete("notificaciones", where: "id = ?", whereArgs: [id]);
  }
}
