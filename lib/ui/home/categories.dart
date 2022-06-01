import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';

class Categories extends StatelessWidget {
  Categories({Key? key}) : super(key: key);

  List<Category> categories = [
    Category(
        nom: "Téléphones", icon: MaterialIcons.smartphone, selected: false),
    Category(nom: "Froid", icon: MaterialIcons.smartphone, selected: false),
    Category(nom: "PC", icon: MaterialIcons.smartphone, selected: false),
    Category(nom: "Véhicules", icon: MaterialIcons.smartphone, selected: false),
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

class CategoryChip extends StatelessWidget {
  Category category;
  CategoryChip({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: EdgeInsets.all(5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    category.icon,
                    size: 25,
                    color: category.selected
                        ? AppTheme.secondaryColor(context)
                        : AppTheme.headlineColor(context),
                  ),
                ),
                Text(
                  category.nom,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: category.selected
                          ? AppTheme.textColor(context)
                          : AppTheme.headlineColor(context)),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
