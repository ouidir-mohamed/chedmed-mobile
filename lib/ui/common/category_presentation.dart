import 'dart:convert';

import 'package:chedmed/main.dart';
import 'package:chedmed/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../utils/language_helper.dart';

class CategoryPresentation {
  int? id;
  String name;
  String nameAr;
  bool selected;
  IconData icon;
  CategoryPresentation(
      {required this.id,
      required this.name,
      required this.nameAr,
      required this.selected,
      required this.icon});

  static CategoryPresentation toCategoryPresentation(
      {required Category category, required bool selected}) {
    IconData icon;
    switch (category.id) {
      case 1:
        icon = Ionicons.shirt;
        break;
      case 2:
        icon = MaterialCommunityIcons.sofa;
        break;
      case 3:
        icon = Icons.smartphone;
        break;
      case 4:
        icon = MaterialCommunityIcons.car_estate;
        break;
      case 5:
        icon = FontAwesome.home;
        break;
      case 6:
        icon = Entypo.game_controller;
        break;
      case 7:
        icon = MaterialCommunityIcons.lipstick;
        break;
      case 8:
        icon = MaterialCommunityIcons.bookshelf;
        break;
      case 9:
        icon = MaterialCommunityIcons.balloon;
        break;
      case 10:
        icon = MaterialCommunityIcons.necklace;
        break;
      case 11:
        icon = MaterialIcons.sports_basketball;
        break;
      case 12:
        icon = MaterialCommunityIcons.tractor;
        break;
      case 13:
        icon = Entypo.laptop;
        break;
      case 14:
        icon = MaterialCommunityIcons.tools;
        break;
      case 15:
        icon = MaterialIcons.pets;
        break;
      case 16:
        icon = Fontisto.island;
        break;
      case 17:
        icon = MaterialIcons.electric_scooter;
        break;
      case 18:
        icon = MaterialCommunityIcons.dots_horizontal;
        break;
      case 19:
        icon = MaterialIcons.engineering;
        break;
      default:
        icon = Icons.question_mark;
        break;
    }

    return CategoryPresentation(
        id: category.id,
        name: category.name,
        nameAr: category.nameAr,
        selected: selected,
        icon: icon);
  }
}
