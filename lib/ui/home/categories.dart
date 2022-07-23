import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/blocs/loading_ressources_bloc.dart';
import 'package:chedmed/blocs/settings_bloc.dart';
import 'package:chedmed/ui/common/category_presentation.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';
import '../common/chips.dart';

class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  GlobalKey<DynamicChipViewState> chipsKey = GlobalKey();

  List<CategoryPresentation> categories = [];

  @override
  void initState() {
    initCategories();
  }

  initCategories() {
    categories.clear();
    categories.add(CategoryPresentation(
        id: null,
        name: getTranslation.all,
        nameAr: getTranslation.all,
        selected: true,
        icon: Icons.select_all));
    categories.addAll(loadingRessourcesBloc.categories
        .map((e) => CategoryPresentation.toCategoryPresentation(
            category: e, selected: false))
        .toList());
    super.initState();

    homeBloc.getCategorie.listen((event) {
      chipsKey.currentState!
          .selectItem(categories.indexWhere((element) => element.id == event));
    });

    homeBloc.selectCategorie(null);
  }

  @override
  Widget build(BuildContext context) {
    var local = currentLocale(context).languageCode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: DynamicChipView(
        key: chipsKey,
        title: getTranslation.category,
        chips: categories
            .map(
              (e) => ChipModel(
                title: local == "ar" ? e.nameAr : e.name,
                icon: e.icon,
                onPressed: () {
                  homeBloc.selectCategorieAndAply(e.id);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

// class Category {
//   String nom;
//   IconData icon;
//   bool selected;
//   Category({
//     required this.nom,
//     required this.icon,
//     required this.selected,
//   });
// }
