import 'dart:convert';

import 'package:collection/collection.dart';

class Category {
  int id;
  String name;
  List<UnderCategory> underCategory;
  Category({
    required this.id,
    required this.name,
    required this.underCategory,
  });

  Category copyWith({
    int? id,
    String? name,
    List<UnderCategory>? underCategory,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      underCategory: underCategory ?? this.underCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'underCategory': underCategory.map((x) => x.toMap()).toList(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      underCategory: List<UnderCategory>.from(
          map['underCategory']?.map((x) => UnderCategory.fromJson(x))),
    );
  }

  String toJson() => json.encode(toMap());

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
  UnderCategory({
    required this.id,
    required this.name,
  });

  UnderCategory copyWith({
    int? id,
    String? name,
  }) {
    return UnderCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory UnderCategory.fromJson(Map<String, dynamic> map) {
    return UnderCategory(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

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
