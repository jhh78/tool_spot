class SearchZipcode {
  String? message;
  List<ZipResult>? results;
  int status;

  SearchZipcode({
    required this.message,
    required this.results,
    required this.status,
  });

  factory SearchZipcode.fromJson(Map<String, dynamic> json) {
    return SearchZipcode(
      message: json['message'],
      results: json['results'] != null ? List<ZipResult>.from(json['results'].map((x) => ZipResult.fromJson(x))) : [],
      status: json['status'],
    );
  }
}

class ZipResult {
  String address1;
  String address2;
  String address3;
  String kana1;
  String kana2;
  String kana3;
  String prefcode;
  String zipcode;

  ZipResult({
    required this.address1,
    required this.address2,
    required this.address3,
    required this.kana1,
    required this.kana2,
    required this.kana3,
    required this.prefcode,
    required this.zipcode,
  });

  factory ZipResult.fromJson(Map<String, dynamic> json) {
    return ZipResult(
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      kana1: json['kana1'],
      kana2: json['kana2'],
      kana3: json['kana3'],
      prefcode: json['prefcode'],
      zipcode: json['zipcode'],
    );
  }
}
