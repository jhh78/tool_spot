class WorkSheetModel {
  int? id;
  String date;
  String ymd;
  String start_time;
  String? end_time;

  WorkSheetModel({
    this.id,
    required this.date,
    required this.ymd,
    required this.start_time,
    this.end_time = '',
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
    );
  }
}
