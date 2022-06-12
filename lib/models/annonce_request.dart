import 'dart:convert';

import 'package:dio/dio.dart';

class AnnonceRequest {
  String title;
  String description;
  int price;
  int? category_id;
  int? underCategory_id;
  int location_id;
  List<String> imagePaths;
  AnnonceRequest({
    required this.title,
    required this.description,
    required this.price,
    this.category_id,
    this.underCategory_id,
    required this.location_id,
    required this.imagePaths,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category_id': category_id,
      'underCategory_id': underCategory_id,
      'location_id': location_id,
    };
  }

  Future<FormData> toFormData() async {
    var formData = FormData.fromMap(toMap());
    for (var file in imagePaths) {
      formData.files.addAll([
        MapEntry("images", await MultipartFile.fromFile(file)),
      ]);
    }
    return formData;
  }

  @override
  String toString() {
    return 'AnnonceRequest(title: $title, description: $description, price: $price, category_id: $category_id, underCategory_id: $underCategory_id, location_id: $location_id, imagePaths: $imagePaths)';
  }
}
