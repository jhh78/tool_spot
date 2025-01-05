class BreakTimeModel {
  final String work_sheet_id;
  final String start_time;
  final String end_time;
  final int value;

  BreakTimeModel({
    required this.work_sheet_id,
    required this.start_time,
    required this.end_time,
    required this.value,
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
      work_sheet_id: map['work_sheet_id'],
      start_time: map['start_time'],
      end_time: map['end_time'],
      value: map['value'],
    );
  }
}
