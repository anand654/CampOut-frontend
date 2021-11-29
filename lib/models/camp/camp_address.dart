class CampAddress {
  String address;
  String place;
  double lat;
  double long;

  CampAddress({this.address, this.place, this.lat, this.long});
  factory CampAddress.fromJson(Map<String, dynamic> data) {
    final _address = CampAddress(
      address: data['address'] as String,
      place: data['place'] as String,
      lat: data['lat'] as double,
      long: data['long'] as double,
    );
    return _address;
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'place': place,
      'lat': lat,
      'long': long,
    };
  }
}
