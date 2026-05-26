import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _defaultDb;
  Database? _db;

  // Nombre y versión de la base de datos
  static const String _dbName = "agenda.db";
  static const int _dbVersion = 3;
  final String? databasePath;
  final int databaseVersion;
  final DatabaseFactory? databaseFactoryOverride;

  DatabaseHelper({
    this.databasePath,
    this.databaseVersion = _dbVersion,
    this.databaseFactoryOverride,
  });

  // Inicializar la base de datos
  Future<Database> initDB() async {
    if (_usesDefaultDatabase && _defaultDb != null) return _defaultDb!;
    if (!_usesDefaultDatabase && _db != null) return _db!;

    final factory = databaseFactoryOverride ?? databaseFactory;
    final path =
        databasePath ?? join(await factory.getDatabasesPath(), _dbName);

    final openedDb = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );

    if (_usesDefaultDatabase) {
      _defaultDb = openedDb;
    } else {
      _db = openedDb;
    }

    return openedDb;
  }

  bool get _usesDefaultDatabase {
    return databasePath == null &&
        databaseVersion == _dbVersion &&
        databaseFactoryOverride == null;
  }

  // Crear tablas iniciales
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tareas (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        asignatura TEXT,
        descripcion TEXT,
        fecha TEXT,
        completada INTEGER NOT NULL,
        eliminada INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS clases (
        id TEXT PRIMARY KEY,
        materia TEXT NOT NULL,
        inicio TEXT,
        fin TEXT,
        aula TEXT,
        recurrenceRule TEXT,
        color INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS eventos (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        inicio TEXT,
        fin TEXT,
        descripcion TEXT,
        color INTEGER
      )
    ''');
  }

  // Manejo de migraciones futuras
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("DROP TABLE IF EXISTS clases");
      await db.execute("DROP TABLE IF EXISTS eventos");
      await _onCreate(db, newVersion);
    }
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE tareas ADD COLUMN eliminada INTEGER NOT NULL DEFAULT 0",
      );
    }
  }

  // Cerrar la base de datos
  Future<void> closeDB() async {
    if (_usesDefaultDatabase) {
      if (_defaultDb != null) {
        await _defaultDb!.close();
        _defaultDb = null;
      }
      return;
    }

    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
