import 'dart:io';

import 'package:agenda/core/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory tempDir;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('agenda_migration_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('migra base SQLite antigua a la version actual', () async {
    final path = '${tempDir.path}${Platform.pathSeparator}agenda.db';
    final oldDb = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE tareas (
              id TEXT PRIMARY KEY,
              titulo TEXT NOT NULL,
              asignatura TEXT,
              descripcion TEXT,
              fecha TEXT,
              completada INTEGER NOT NULL
            )
          ''');
          await db.insert('tareas', {
            'id': 't1',
            'titulo': 'Ensayo',
            'asignatura': 'Literatura',
            'descripcion': 'Borrador',
            'fecha': DateTime(2026, 5, 13).toIso8601String(),
            'completada': 0,
          });
        },
      ),
    );
    await oldDb.close();

    final helper = DatabaseHelper(
      databasePath: path,
      databaseFactoryOverride: databaseFactoryFfi,
    );
    final db = await helper.initDB();

    final tareasColumns = await db.rawQuery('PRAGMA table_info(tareas)');
    final columnNames = tareasColumns.map((column) => column['name']).toSet();
    expect(columnNames, contains('eliminada'));

    final tareas = await db.query('tareas');
    expect(tareas.single['titulo'], 'Ensayo');
    expect(tareas.single['eliminada'], 0);

    final clases = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'clases'",
    );
    final eventos = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'eventos'",
    );
    expect(clases, isNotEmpty);
    expect(eventos, isNotEmpty);

    await helper.closeDB();
  });
}
