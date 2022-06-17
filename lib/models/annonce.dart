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
  String phone;
  int nbFavorite;
  User user;
  Annonce({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.location,
    required this.phone,
    required this.nbFavorite,
    required this.user,
  });

  factory Annonce.fromJson(Map<String, dynamic> map) {
    return Annonce(
      id: map['id']?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toInt() ?? 0,
      nbFavorite: map['nbFavorite']?.toInt() ?? 0,
      phone: map['phone'] ?? "",
      images: List<String>.from(map['images']),
      location: City.fromJson(map['location']),
      user: User.fromJson(map['user']),
    );
  }

  @override
  String toString() {
    return 'Annonce(id: $id, createdAt: $createdAt, title: $title, description: $description, price: $price, images: $images, location: $location)';
  }
}

class User {
  int id;
  String username;
  String phone;
  User({
    required this.id,
    required this.username,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
