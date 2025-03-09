import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_credentials.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE user_credentials(id INTEGER PRIMARY KEY, email TEXT, password TEXT)",
        );
      },
    );
  }

  Future<void> insertUser(String email, String password) async {
    final db = await database;
    await db.insert(
      'user_credentials',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_credentials');
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }


  Future<bool> checkTable() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'user_credentials',
      limit: 1, // Fetch only 1 row to check if there's any data
    );

    // If result is not empty, the table has data
    return result.isNotEmpty;
  }

  Future<void> updateUser(String email, String password) async {
    final db = await database;
    await db.update(
      'user_credentials',
      {'email': email, 'password': password},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('user_credentials');
  }
}