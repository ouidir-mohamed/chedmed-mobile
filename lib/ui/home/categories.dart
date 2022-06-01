import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';

class Categories extends StatelessWidget {
  Categories({Key? key}) : super(key: key);

  List<Category> categories = [
    Category(nom: "Tout", icon: MaterialIcons.select_all, selected: true),
    Category(
        nom: "Téléphones", icon: MaterialIcons.smartphone, selected: false),
    Category(nom: "Froid", icon: Icons.ac_unit, selected: false),
    Category(nom: "PC", icon: MaterialIcons.laptop_mac, selected: false),
    Category(nom: "Véhicules", icon: FontAwesome.car, selected: false),
    Category(
        nom: "Outils", icon: MaterialCommunityIcons.tools, selected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories
                .map((e) =>
                    // CategoryChip(
                    //       category: e,
                    //     )
                    CustomChip(
                      text: e.nom,
                      icon: e.icon,
                      onPressed: () {},
                      isSelected: e.selected,
                    ))
                .toList(),
          ),
        ));
  }
}

class Category {
  String nom;
  IconData icon;
  bool selected;
  Category({
    required this.nom,
    required this.icon,
    required this.selected,
  });
}
