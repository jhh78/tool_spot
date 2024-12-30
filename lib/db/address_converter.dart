import 'package:life_secretary/db/helper.dart';
import 'package:sqflite/sqflite.dart';

class AddressConverterHelper {
  final String tableName = 'address_converter';

  Future<Database> get database async {
    return await DatabaseHelper().database;
  }

  Future<int> insert(Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await database;
    return await db.query(tableName);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
