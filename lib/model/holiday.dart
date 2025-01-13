class HolidayModel {
  String? date;
  String? localName;
  String? name;
  String? countryCode;
  bool? fixed;
  bool? global;
  String? launchYear;
  String? type;

  HolidayModel({
    this.date,
    this.localName,
    this.name,
    this.countryCode,
    this.fixed,
    this.global,
    this.launchYear,
    this.type,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      date: json['date'],
      localName: json['localName'],
      name: json['name'],
      countryCode: json['countryCode'],
      fixed: json['fixed'],
      global: json['global'],
      launchYear: json['launchYear'],
      type: json['type'],
    );
  }
}
