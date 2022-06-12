import 'dart:convert';

import 'package:chedmed/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryPresentation {
  int? id;
  String name;
  bool selected;
  IconData icon;
  CategoryPresentation(
      {required this.id,
      required this.name,
      required this.selected,
      required this.icon});

  static CategoryPresentation toCategoryPresentation(
      {required Category category, required bool selected}) {
    IconData icon;
    switch (category.id) {
      case 2:
        icon = Icons.smartphone;
        break;
      case 3:
        icon = Icons.smartphone;
        break;
      case 4:
        icon = Icons.smartphone;
        break;
      case 5:
        icon = Icons.smartphone;
        break;
      case 6:
        icon = Icons.smartphone;
        break;
      case 7:
        icon = Icons.smartphone;
        break;
      case 8:
        icon = Icons.smartphone;
        break;
      default:
        icon = Icons.question_mark;
        break;
    }
    return CategoryPresentation(
        id: category.id, name: category.name, selected: selected, icon: icon);
  }
}
