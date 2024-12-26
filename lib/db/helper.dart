import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'com.oc.ls.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create Table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
      )
    ''');
  }

  // Upgrade Table
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    log('Upgrade Database $oldVersion >>> $newVersion');
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE todos ADD COLUMN date TEXT');
    //   await db.execute('ALTER TABLE todos ADD COLUMN ddd TEXT');
    // }

    // if (oldVersion < 3) {
    //   await db.execute('ALTER TABLE todos ADD COLUMN cccc TEXT');
    //   await db.execute('ALTER TABLE todos ADD COLUMN xxxx TEXT');
    // }
  }
}
