import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../navigation/bottom_navigation.dart';

class NoArticle extends StatelessWidget {
  const NoArticle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Icon(
            Entypo.shopping_bag,
            size: 90,
            color: AppTheme.headlineColor(context),
          )),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 3),
            child: Text(
              getTranslation.no_posts,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 5),
            child: Text(
              getTranslation.profile_no_posts,
              style: TextStyle(
                  fontSize: 16, color: AppTheme.headlineColor(context)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
