import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'city.dart';

class Annonce {
  int id;
  String createdAt;
  String title;
  String description;
  int price;
  List<String> images;
  City location;
  Annonce({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.location,
  });

  Annonce copyWith({
    int? id,
    String? createdAt,
    String? title,
    String? description,
    int? price,
    List<String>? images,
    City? location,
  }) {
    return Annonce(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'title': title,
      'description': description,
      'price': price,
      'images': images,
      'location': location.toJson(),
    };
  }

  factory Annonce.fromJson(Map<String, dynamic> map) {
    return Annonce(
      id: map['id']?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toInt() ?? 0,
      images: List<String>.from(map['images']),
      location: City.fromJson(map['location']),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Annonce(id: $id, createdAt: $createdAt, title: $title, description: $description, price: $price, images: $images, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Annonce &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        listEquals(other.images, images) &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        images.hashCode ^
        location.hashCode;
  }
}
