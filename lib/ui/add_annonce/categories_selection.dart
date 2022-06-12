import 'package:chedmed/blocs/add_annonce_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../blocs/loading_ressources_bloc.dart';
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
  GlobalKey<DynamicChipViewState> chipsKey = GlobalKey();

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
    addAnnonceBloc.getDone.listen((a) {
      init();
      chipsKey.currentState!.restore();
    });
    init();
    super.initState();
  }

  init() {
    int? selected = categories.first.id;
    int? selectedType;

    underCategories = loadingRessourcesBloc.categories
        .firstWhere((element) => element.id == selected)
        .underCategory
        .map((e) => e)
        .toList();

    if (underCategories.isNotEmpty)
      selectedType = underCategories.first.id;
    else
      selectedType = null;

    addAnnonceBloc.category_id = selected;
    addAnnonceBloc.underCategory_id = selectedType;

    setState(() {});
  }

  select(int? categoryId) {
    int? selected = categories.first.id;
    int? selectedType;
    selected = categoryId;
    underCategories = loadingRessourcesBloc.categories
        .firstWhere((element) => element.id == categoryId)
        .underCategory
        .map((e) => e)
        .toList();

    if (underCategories.isNotEmpty)
      selectedType = underCategories.first.id;
    else
      selectedType = null;

    addAnnonceBloc.category_id = selected;
    addAnnonceBloc.underCategory_id = selectedType;

    setState(() {});
  }

  selectType(int? typeId) {
    addAnnonceBloc.underCategory_id = typeId;
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
            key: chipsKey,
            title: "Catégorie",
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
            title: "Type",
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
