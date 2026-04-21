import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  static final LocalDb instance = LocalDb._();
  LocalDb._();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'sugbo_save.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE daily_stats(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            day_key TEXT UNIQUE NOT NULL,
            idle_seconds INTEGER NOT NULL DEFAULT 0,
            php_saved REAL NOT NULL DEFAULT 0,
            liters_saved REAL NOT NULL DEFAULT 0
          )
        ''');
      },
    );
    return _db!;
  }

  Future<Map<String, dynamic>> loadStatsForDay(String dayKey) async {
    final database = await db;
    final rows = await database.query(
      'daily_stats',
      where: 'day_key = ?',
      whereArgs: [dayKey],
      limit: 1,
    );
    if (rows.isEmpty) {
      await database.insert('daily_stats', {
        'day_key': dayKey,
        'idle_seconds': 0,
        'php_saved': 0.0,
        'liters_saved': 0.0,
      });
      return {'idle_seconds': 0, 'php_saved': 0.0, 'liters_saved': 0.0};
    }
    return rows.first;
  }

  Future<void> upsertStats({
    required String dayKey,
    required int idleSeconds,
    required double phpSaved,
    required double litersSaved,
  }) async {
    final database = await db;
    await database.insert('daily_stats', {
      'day_key': dayKey,
      'idle_seconds': idleSeconds,
      'php_saved': phpSaved,
      'liters_saved': litersSaved,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
