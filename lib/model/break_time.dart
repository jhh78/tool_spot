class BreakTimeModel {
  int? id;
  final int work_sheet_id;
  final String start_time;
  final String end_time;
  final int value;
  final DateTime sortTime;

  BreakTimeModel({
    required this.sortTime,
    required this.work_sheet_id,
    required this.start_time,
    required this.end_time,
    required this.value,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'work_sheet_id': work_sheet_id,
      'start_time': start_time,
      'end_time': end_time,
      'value': value,
    };
  }

  factory BreakTimeModel.fromMap(Map<String, dynamic> map) {
    return BreakTimeModel(
      id: map['id'],
      sortTime: DateTime.parse(map['start_time']),
      work_sheet_id: map['work_sheet_id'],
      start_time: map['start_time'],
      end_time: map['end_time'],
      value: map['value'],
    );
  }
}
