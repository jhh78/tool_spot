import 'package:life_secretary/db/helper.dart';
import 'package:life_secretary/model/work_sheet.dart';
import 'package:life_secretary/util/util.dart';
import 'package:sqflite/sqflite.dart';

class WorkSheetHalper {
  final String tableName = 'work_sheet';

  Future<Database> get database async {
    return await DatabaseHelper().database;
  }

  Future<void> attendanceRecords() async {
    try {
      Database db = await database;
      final DateTime now = DateTime.now();

      final List<Map<String, dynamic>> list = await db.query(
        tableName,
        where: 'ymd = ?',
        whereArgs: [convertLocaleDateFormat(now)],
      );

      if (list.isNotEmpty) {
        throw Exception('duplicate');
      }

      await db.insert(
          tableName,
          WorkSheetModel(
            date: convertLocaleDateTimeFormat(now),
            ymd: convertLocaleDateFormat(now),
            start_time: convertLocaleTimeFormat(now),
          ).toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, WorkSheetModel>>> getList() async {
    Database db = await database;

    // 현재 날짜의 해당 월의 1일
    DateTime now = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);

    // 한 달 전의 해당 월의 1일
    DateTime firstDayOfPreviousMonth = DateTime(firstDayOfCurrentMonth.year, firstDayOfCurrentMonth.month - 1, 1);

    // 한 달 후의 해당 월의 1일
    DateTime firstDayOfNextMonth = DateTime(firstDayOfCurrentMonth.year, firstDayOfCurrentMonth.month + 2, 1);

    // 날짜 형식 지정
    String firstDayOfPreviousMonthStr = convertLocaleDateTimeFormat(firstDayOfPreviousMonth);
    String firstDayOfNextMonthStr = convertLocaleDateTimeFormat(firstDayOfNextMonth);

    // 쿼리 실행
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'ymd BETWEEN ? AND ?',
      whereArgs: [firstDayOfPreviousMonthStr, firstDayOfNextMonthStr],
    );

    final List<Map<String, WorkSheetModel>> list = [];

    for (Map<String, dynamic> item in result) {
      list.add({item['ymd']: WorkSheetModel.fromMap(item)});
    }

    return list;
  }

  Future<void> update() async {
    // Database db = await database;

    // final List<Map<String, dynamic>> list = await db.query(
    //   tableName,
    //   where: 'ymd = ?',
    //   whereArgs: [params.ymd],
    // );

    // int id = todo['id'];
    // return await db.update(tableName, todo, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
