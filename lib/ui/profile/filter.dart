import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/chips.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.canvasColor(context),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Container(
        height: 37,
        child: Row(
          children: [
            CustomChip(
              text: getTranslation.my_posts,
              isSelected: selected == 0,
              icon: Ionicons.person,
              onPressed: () {
                setState(() {
                  selected = 0;
                });
                profileBloc.switchTo(0);
              },
            ),
            CustomChip(
              text: getTranslation.favorite_posts,
              isSelected: selected == 1,
              icon: Ionicons.heart,
              onPressed: () {
                setState(() {
                  selected = 1;
                });
                profileBloc.switchTo(1);
              },
            )
          ],
        ),
      ),
    );
  }
}
