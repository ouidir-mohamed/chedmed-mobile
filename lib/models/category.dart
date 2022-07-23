import 'dart:convert';

import 'package:collection/collection.dart';

class Category {
  int id;
  String name;
  String nameAr;
  List<UnderCategory> underCategory;
  Category({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.underCategory,
  });

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      nameAr: map['nameAr'] ?? '',
      underCategory: List<UnderCategory>.from(
          map['underCategory']?.map((x) => UnderCategory.fromJson(x))),
    );
  }

  @override
  String toString() =>
      'Category(id: $id, name: $name, underCategory: $underCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        listEquals(other.underCategory, underCategory);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ underCategory.hashCode;
}

class UnderCategory {
  int? id;
  String name;
  String nameAr;
  UnderCategory({required this.id, required this.name, required this.nameAr});

  factory UnderCategory.fromJson(Map<String, dynamic> map) {
    return UnderCategory(
        id: map['id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        nameAr: map["nameAr"] ?? "");
  }

  @override
  String toString() => 'UnderCategory(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UnderCategory && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
