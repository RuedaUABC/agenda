import 'package:agenda/core/db/sqlite_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('usa SQLite FFI en Windows y Linux de escritorio', () {
    expect(
      shouldUseSqliteFfi(isWeb: false, platform: TargetPlatform.windows),
      isTrue,
    );
    expect(
      shouldUseSqliteFfi(isWeb: false, platform: TargetPlatform.linux),
      isTrue,
    );
    expect(
      shouldUseSqliteFfi(isWeb: false, platform: TargetPlatform.android),
      isFalse,
    );
    expect(
      shouldUseSqliteFfi(isWeb: true, platform: TargetPlatform.windows),
      isFalse,
    );
  });

  test('smoke SQLite FFI abre y consulta una base en memoria', () async {
    configureSqliteForPlatform(isWeb: false, platform: TargetPlatform.windows);

    final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await db.execute('CREATE TABLE smoke (id INTEGER PRIMARY KEY, name TEXT)');
    await db.insert('smoke', {'name': 'ok'});

    final rows = await db.query('smoke');
    expect(rows.single['name'], 'ok');

    await db.close();
  });
}
