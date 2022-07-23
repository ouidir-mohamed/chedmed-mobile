import 'package:chedmed/models/category.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../../blocs/home_bloc.dart';
import '../../../blocs/loading_ressources_bloc.dart';
import '../../common/buttons.dart';
import '../../common/category_presentation.dart';
import '../../common/chips.dart';
import '../../home/categories.dart';

class CategoriesSelection extends StatefulWidget {
  const CategoriesSelection({Key? key}) : super(key: key);

  @override
  State<CategoriesSelection> createState() => _CategoriesSelectionState();
}

class _CategoriesSelectionState extends State<CategoriesSelection> {
  GlobalKey<DynamicChipViewState> chipsCategoryKey = GlobalKey();
  GlobalKey<DynamicChipViewState> chipsUnderCategoryKey = GlobalKey();

  List<CategoryPresentation> categories = [
    CategoryPresentation(
        id: null,
        name: getTranslation.all,
        nameAr: getTranslation.all,
        selected: true,
        icon: Icons.select_all)
  ];

  List<UnderCategory> underCategories = [
    UnderCategory(
        id: null, name: getTranslation.all, nameAr: getTranslation.all)
  ];

  @override
  void initState() {
    categories.addAll(loadingRessourcesBloc.categories
        .map((e) => CategoryPresentation.toCategoryPresentation(
            category: e, selected: false))
        .toList());

    underCategories.addAll(loadingRessourcesBloc.categories.first.underCategory
        .map((e) => e)
        .toList());

    homeBloc.getCategorie.listen((event) {
      if (mounted) {
        var index = categories.indexWhere((element) => element.id == event);
        chipsCategoryKey.currentState!.selectItem(index);
        selectCategoty(event);
      }
    });

    homeBloc.getUnderCategorie.listen((event) {
      if (mounted) {
        var index =
            underCategories.indexWhere((element) => element.id == event);
        chipsUnderCategoryKey.currentState!.selectItem(index);
      }
    });

    super.initState();
  }

  selectCategoty(int? categoryId) {
    setState(() {
      selectUnderCategory(null);
      underCategories = [
        UnderCategory(
            id: null, name: getTranslation.all, nameAr: getTranslation.all)
      ];
      chipsUnderCategoryKey.currentState!.selectItem(0);

      if (categoryId != null)
        underCategories.addAll(loadingRessourcesBloc.categories
            .firstWhere((element) => element.id == categoryId)
            .underCategory
            .map((e) => e)
            .toList());
    });
  }

  selectUnderCategory(int? underCategoryId) {
    homeBloc.selectUnderCategorie(underCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    var local = currentLocale(context).languageCode;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicChipView(
            key: chipsCategoryKey,
            title: getTranslation.category,
            chips: categories
                .map(
                  (e) => ChipModel(
                    title: local == "ar" ? e.nameAr : e.name,
                    icon: e.icon,
                    onPressed: () {
                      selectCategoty(e.id);
                      homeBloc.selectCategorie(e.id);
                    },
                  ),
                )
                .toList(),
          ),
          DynamicChipView(
            key: chipsUnderCategoryKey,
            title: getTranslation.type,
            chips: underCategories
                .map(
                  (e) => ChipModel(
                    title: local == "ar" ? e.nameAr : e.name,
                    onPressed: () {
                      selectUnderCategory(e.id);
                    },
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

// class CategoryType {
//   String nom;
//   CategoryType({
//     required this.nom,
//   });
// }
