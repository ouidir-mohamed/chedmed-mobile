import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/category_presentation.dart';
import 'package:chedmed/ui/home/categories.dart';
import 'package:flutter/material.dart';

import '../../models/category.dart';

class CategoryChip extends StatelessWidget {
  CategoryPresentation category;
  void Function()? onTap;
  CategoryChip({Key? key, required this.category, this.onTap})
      : super(key: key);

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
          onTap: onTap,
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
                        ? AppTheme.primaryColor(context)
                        : AppTheme.headlineColor(context),
                  ),
                ),
                Text(
                  category.name,
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
