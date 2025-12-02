import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EmailDatabase {
  static final EmailDatabase instance = EmailDatabase._init();
  static Database? _database;

  EmailDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('emails.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE emails (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertEmail(String subject, String content) async {
    final db = await instance.database;
    return await db.insert('emails', {
      'subject': subject,
      'content': content,
      'date': DateTime.now().toIso8601String()
    });
  }

  Future<List<Map<String, dynamic>>> getEmails() async {
    final db = await instance.database;
    return await db.query('emails', orderBy: 'date DESC');
  }

  Future<int> deleteEmail(int id) async {
    final db = await instance.database;
    return await db.delete('emails', where: 'id = ?', whereArgs: [id]);
  }
}