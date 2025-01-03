class WorkSheetModel {
  int? id;
  String kind;
  String date;
  String ymd;
  String hms;

  WorkSheetModel({
    this.id,
    required this.kind,
    required this.date,
    required this.ymd,
    required this.hms,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kind': kind,
      'date': date,
      'ymd': ymd,
      'hms': hms,
    };
  }

  factory WorkSheetModel.fromMap(Map<String, dynamic> map) {
    return WorkSheetModel(
      id: map['id'],
      kind: map['kind'],
      date: map['date'],
      ymd: map['ymd'],
      hms: map['hms'],
    );
  }
}
