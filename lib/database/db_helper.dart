import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            counter INTEGER,
            dailyTaps INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertData(int counter, int dailyTaps) async {
    final db = await database;
    await db?.insert('user_data', {'counter': counter, 'dailyTaps': dailyTaps});
  }

  Future<Map<String, dynamic>?> getData() async {
    final db = await database;
    final result = await db?.query('user_data', limit: 1);

    if (result != null && result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> updateData(int counter, int dailyTaps) async {
    final db = await database;
    await db?.update('user_data', {'counter': counter, 'dailyTaps': dailyTaps});
  }
}
