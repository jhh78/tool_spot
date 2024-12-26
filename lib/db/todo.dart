import 'package:life_secretary/db/helper.dart';
import 'package:sqflite/sqflite.dart';

class Todo {
  Future<Database> get database async {
    return await DatabaseHelper().database;
  }

  Future<int> insertTodo(Map<String, dynamic> todo) async {
    Database db = await database;
    return await db.insert('todos', todo);
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    Database db = await database;
    return await db.query('todos');
  }

  Future<int> updateTodo(Map<String, dynamic> todo) async {
    Database db = await database;
    int id = todo['id'];
    return await db.update('todos', todo, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTodo(int id) async {
    Database db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
