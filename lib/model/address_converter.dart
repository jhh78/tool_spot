class AddressConverterModel {
  int? id;
  late String address;

  AddressConverterModel({this.id, required this.address});

  Map<String, dynamic> toMap() {
    return {
      'address': address,
    };
  }

  AddressConverterModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    address = map['address'];
  }
}
