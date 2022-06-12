import 'dart:convert';

class City {
  int id;
  String name;
  double lat;
  double long;
  String wilaya;
  City({
    required this.id,
    required this.name,
    required this.lat,
    required this.long,
    required this.wilaya,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'long': long,
      'wilaya': wilaya,
    };
  }

  factory City.fromJson(Map<String, dynamic> map) {
    return City(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
      wilaya: map['wilaya'] ?? '',
    );
  }

  @override
  String toString() {
    return '$name, $wilaya';
  }
}
