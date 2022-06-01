import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/buttons.dart';
import '../home/categories.dart';

class CategoriesSelection extends StatefulWidget {
  const CategoriesSelection({Key? key}) : super(key: key);

  @override
  State<CategoriesSelection> createState() => _CategoriesSelectionState();
}

class _CategoriesSelectionState extends State<CategoriesSelection> {
  List<Category> categories = [
    Category(nom: "Vetements", icon: Ionicons.ios_shirt, selected: false),
    Category(
        nom: "Téléphones", icon: MaterialIcons.smartphone, selected: false),
    Category(nom: "Froid", icon: Icons.ac_unit, selected: false),
    Category(nom: "PC", icon: MaterialIcons.laptop_mac, selected: false),
    Category(nom: "Véhicules", icon: FontAwesome.car, selected: false),
    Category(
        nom: "Outils", icon: MaterialCommunityIcons.tools, selected: false),
    Category(nom: "Autre", icon: AntDesign.question, selected: false),
  ];

  String selected = "";

  List<CategoryType> categoryTypes = [
    CategoryType(
      nom: "T-Shirts",
    ),
    CategoryType(
      nom: "Chaussures",
    ),
    CategoryType(
      nom: "Vestes",
    ),
    CategoryType(
      nom: "Pontalons",
    ),
    CategoryType(
      nom: "Autre",
    ),
  ];

  String selectedType = "";
  @override
  void initState() {
    selected = categories.first.nom;
    selectedType = categoryTypes.first.nom;

    super.initState();
  }

  select(Category category) {
    setState(() {
      selected = category.nom;
    });
  }

  selectType(CategoryType type) {
    setState(() {
      selectedType = type.nom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text("Catégorie",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Wrap(
            children: categories
                .map(
                  (e) => CustomChip(
                      text: e.nom,
                      icon: e.icon,
                      onPressed: () {
                        select(e);
                      },
                      isSelected: e.nom == selected),
                )
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 3),
            child: Text("Type",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
          Wrap(
            children: categoryTypes
                .map(
                  (e) => CustomChip(
                      text: e.nom,
                      onPressed: () {
                        selectType(e);
                      },
                      isSelected: e.nom == selectedType),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

class CategoryType {
  String nom;
  CategoryType({
    required this.nom,
  });
}
