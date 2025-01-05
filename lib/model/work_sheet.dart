import 'package:get/get.dart';
import 'package:life_secretary/model/break_time.dart';

class WorkSheetModel {
  int? id;
  String date;
  String ymd;
  String start_time;
  String? end_time;
  BreakTimeModel? breakTime;

  WorkSheetModel({
    this.id,
    required this.date,
    required this.ymd,
    required this.start_time,
    this.end_time,
    this.breakTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'ymd': ymd,
      'start_time': start_time,
      'end_time': end_time,
    };
  }

  factory WorkSheetModel.fromMap(Map<String, dynamic> map) {
    return WorkSheetModel(
      id: map['id'],
      date: map['date'],
      ymd: map['ymd'],
      start_time: map['start_time'],
      end_time: map['end_time'],
      breakTime: map['breakTime'] != null ? BreakTimeModel.fromMap(map['breakTime']) : null,
    );
  }
}

class WorkSheetViewModel {
  final String kind;
  final String time;
  final String ymd;
  String? start_time;
  String? end_time;
  int? value;

  WorkSheetViewModel({
    required this.kind,
    required this.time,
    required this.ymd,
    this.start_time,
    this.end_time,
    this.value,
  });
}
