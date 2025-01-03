import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'com.oc.st.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create Table
  Future<void> _onCreate(Database db, int version) async {
    await _onUpgrade(db, 0, version);
  }

  // Upgrade Table
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
      await db.execute('''
        CREATE TABLE address_converter(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          address TEXT
        )
      ''');
    }

    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE work_sheet(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          kind char(5),
          date datetime,
          ymd DATE,
          hms time
        );
      ''');
    }

    // if (oldVersion < 3) {
    //   await db.execute('''
    //     CREATE TABLE ddd(
    //       id INTEGER PRIMARY KEY AUTOINCREMENT,
    //       address TEXT
    //     )
    //   ''');
    // }

    // if (oldVersion < 4) {
    //   await db.execute('''
    //     CREATE TABLE eee(
    //       id INTEGER PRIMARY KEY AUTOINCREMENT,
    //       address TEXT
    //     )
    //   ''');
    // }
  }
}
