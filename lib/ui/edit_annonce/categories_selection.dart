import 'package:chedmed/blocs/add_annonce_bloc.dart';
import 'package:chedmed/blocs/edit_annonce_bloc.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../blocs/loading_ressources_bloc.dart';
import '../../models/annonce.dart';
import '../../models/category.dart';
import '../common/buttons.dart';
import '../common/category_presentation.dart';
import '../common/chips.dart';
import '../home/categories.dart';

class CategoriesSelection extends StatefulWidget {
  const CategoriesSelection({Key? key}) : super(key: key);

  @override
  State<CategoriesSelection> createState() => _CategoriesSelectionState();
}

class _CategoriesSelectionState extends State<CategoriesSelection> {
  GlobalKey<DynamicChipViewState> categoryChipsKey = GlobalKey();
  GlobalKey<DynamicChipViewState> typeChipsKey = GlobalKey();

  List<CategoryPresentation> categories = loadingRessourcesBloc.categories
      .map((e) => CategoryPresentation.toCategoryPresentation(
          category: e, selected: false))
      .toList();
  List<UnderCategory> underCategories = loadingRessourcesBloc
      .categories.first.underCategory
      .map((e) => e)
      .toList();

  @override
  void initState() {
    // editAnnonceBloc.getDone.listen((a) {
    //   init();
    //   chipsKey.currentState!.restore();
    // });
    editAnnonceBloc.getInitialAnnonce.listen((event) {
      if (mounted) init(event);
    });
    super.initState();
  }

  init(Annonce annonce) {
    int? selected = annonce.category_id;
    int? selectedType = annonce.underCategory_id;

    int categoryIndex = categories
        .indexOf(categories.firstWhere((element) => element.id == selected));
    categoryChipsKey.currentState!.selectItem(categoryIndex);

    underCategories = loadingRessourcesBloc.categories
        .firstWhere((element) => element.id == selected)
        .underCategory
        .map((e) => e)
        .toList();

    int typeIndex = underCategories.indexOf(
        underCategories.firstWhere((element) => element.id == selectedType));
    typeChipsKey.currentState!.selectItem(typeIndex);

    editAnnonceBloc.category_id = selected;
    editAnnonceBloc.underCategory_id = selectedType;

    setState(() {});
  }

  select(int? categoryId) {
    int? selectedType;
    int? selected = categoryId;
    underCategories = loadingRessourcesBloc.categories
        .firstWhere((element) => element.id == categoryId)
        .underCategory
        .map((e) => e)
        .toList();

    if (underCategories.isNotEmpty)
      selectedType = underCategories.first.id;
    else
      selectedType = null;

    editAnnonceBloc.category_id = selected;
    editAnnonceBloc.underCategory_id = selectedType;

    setState(() {});
  }

  selectType(int? typeId) {
    editAnnonceBloc.underCategory_id = typeId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicChipView(
            key: categoryChipsKey,
            title: getTranslation.category,
            chips: categories
                .map(
                  (e) => ChipModel(
                    title: e.name,
                    icon: e.icon,
                    onPressed: () {
                      select(e.id);
                    },
                  ),
                )
                .toList(),
          ),
          DynamicChipView(
            key: typeChipsKey,
            title: getTranslation.type,
            chips: underCategories
                .map(
                  (e) => ChipModel(
                    title: e.name,
                    onPressed: () {
                      selectType(e.id);
                    },
                  ),
                )
                .toList(),
          ),
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
