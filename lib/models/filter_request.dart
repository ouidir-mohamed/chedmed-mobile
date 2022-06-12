import 'dart:convert';

import 'package:chedmed/models/city.dart';

class FilterRequest {
  int page;
  City point;
  String query;
  double? rayon;
  int? category_id;
  int? underCategory_id;
  FilterRequest({
    required this.page,
    required this.point,
    required this.query,
    this.rayon,
    this.category_id,
    this.underCategory_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'point': point.toJson(),
      'rayon': rayon,
      'category_id': category_id,
      'query': query,
      'underCategory_id': underCategory_id,
    };
  }
}
