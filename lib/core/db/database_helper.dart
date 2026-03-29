import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  // Nombre y versión de la base de datos
  static const String _dbName = "agenda.db";
  static const int _dbVersion = 1;

  // Inicializar la base de datos
  Future<Database> initDB() async {
    if (_db != null) return _db!;

    String path = join(await getDatabasesPath(), _dbName);

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _db!;
  }

  // Crear tablas iniciales
  Future<void> _onCreate(Database db, int version) async {
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

    await db.execute('''
      CREATE TABLE clases (
        id TEXT PRIMARY KEY,
        materia TEXT NOT NULL,
        inicio TEXT,
        fin TEXT,
        aula TEXT,
        recurrenteSemanal INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE eventos (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        fechaInicio TEXT,
        fechaFin TEXT
      )
    ''');
  }

  // Manejo de migraciones futuras
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Aquí puedes manejar cambios de esquema
  }

  // Cerrar la base de datos
  Future<void> closeDB() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
