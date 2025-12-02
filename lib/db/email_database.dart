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
