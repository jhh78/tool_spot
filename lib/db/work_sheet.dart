import 'dart:developer';

import 'package:life_secretary/db/helper.dart';
import 'package:life_secretary/model/break_time.dart';
import 'package:life_secretary/model/work_sheet.dart';
import 'package:life_secretary/util/util.dart';
import 'package:sqflite/sqflite.dart';

class WorkSheetHalper {
  final String tableName = 'work_sheet';
  final String breakTimeTableName = 'break_time';

  Future<Database> get database async {
    return await DatabaseHelper().database;
  }

  Future<void> attendanceRecords() async {
    try {
      Database db = await database;
      final DateTime now = DateTime.now();
      final currentTime = convertLocaleDateTimeFormat(now);
      final ymd = convertLocaleDateFormat(now);

      final List<Map<String, dynamic>> list = await db.query(
        tableName,
        where: 'ymd = ?',
        whereArgs: [ymd],
      );

      if (list.isNotEmpty) {
        throw Exception('duplicate');
      }

      await db.insert(tableName, {
        'date': currentTime,
        'ymd': ymd,
        'start_time': currentTime,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, WorkSheetModel>>> getList(DateTime focusDay) async {
    Database db = await database;

    // 현재 날짜의 해당 월의 1일
    DateTime firstDayOfCurrentMonth = DateTime(focusDay.year, focusDay.month, 1);

    // 한 달 전의 해당 월의 1일
    DateTime firstDayOfPreviousMonth = DateTime(firstDayOfCurrentMonth.year, firstDayOfCurrentMonth.month - 1, 1);

    // 한 달 후의 해당 월의 1일
    DateTime firstDayOfNextMonth = DateTime(firstDayOfCurrentMonth.year, firstDayOfCurrentMonth.month + 2, 1);

    // 날짜 형식 지정
    String firstDayOfPreviousMonthStr = convertLocaleDateTimeFormat(firstDayOfPreviousMonth);
    String firstDayOfNextMonthStr = convertLocaleDateTimeFormat(firstDayOfNextMonth);

    log('$firstDayOfPreviousMonthStr ~ $firstDayOfNextMonthStr');

    // 쿼리 실행
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [firstDayOfPreviousMonthStr, firstDayOfNextMonthStr],
    );

    final List<Map<String, WorkSheetModel>> list = [];

    for (Map<String, dynamic> item in result) {
      final List<Map<String, dynamic>> refresh = await db.query(
        breakTimeTableName,
        where: 'work_sheet_id = ?',
        whereArgs: [item['id']],
      );

      final WorkSheetModel workSheetModel = WorkSheetModel.fromMap(item);

      if (refresh.isNotEmpty) {
        workSheetModel.breakTime = refresh.map((e) => BreakTimeModel.fromMap(e)).toList();
      }

      list.add({item['ymd']: workSheetModel});
    }

    return list;
  }

  Future<void> update() async {
    try {
      Database db = await database;
      final DateTime now = DateTime.now();
      final String currentTime = convertLocaleDateTimeFormat(now);
      final String ymd = convertLocaleDateFormat(now);

      final List<Map<String, dynamic>> list = await db.query(
        tableName,
        where: 'ymd = ?',
        whereArgs: [ymd],
      );

      log('>>>>>>>>>>>>>>>>>>>> list: $list');

      if (list.isNotEmpty) {
        final WorkSheetModel workSheetModel = WorkSheetModel.fromMap(list.first);

        if (workSheetModel.end_time != null) {
          throw Exception('The entered quitting time exists.');
        }

        await db.update(
          tableName,
          {
            'end_time': currentTime,
          },
          where: 'id = ?',
          whereArgs: [workSheetModel.id],
        );

        return;
      }

      throw Exception('The entered quitting time does not exist.');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> breakTimeRecords(int value) async {
    try {
      Database db = await database;
      final DateTime now = DateTime.now();
      final String currentTime = convertLocaleDateTimeFormat(now);

      final ymd = convertLocaleDateFormat(now);

      final breakEndTime = convertLocaleDateTimeFormat(now.add(Duration(minutes: value)));

      final List<Map<String, dynamic>> workSheet = await db.query(
        tableName,
        where: 'ymd = ?',
        whereArgs: [ymd],
      );

      if (workSheet.isEmpty) {
        throw Exception('duplicate');
      }

      if (workSheet.first['end_time'] != null) {
        throw Exception('The entered quitting time exists.');
      }

      await db.insert(
        breakTimeTableName,
        {
          'work_sheet_id': workSheet.first['id'],
          'start_time': currentTime,
          'end_time': breakEndTime,
          'value': value,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteBreakTimeItem(String id) async {
    Database db = await database;
    return await db.delete(breakTimeTableName, where: 'id = ?', whereArgs: [id]);
  }
}
