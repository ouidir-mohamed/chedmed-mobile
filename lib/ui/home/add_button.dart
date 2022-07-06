import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:chedmed/ui/common/app_theme.dart';

import '../navigation/bottom_navigation.dart';

class AddButton extends StatelessWidget {
  bool isExtended;
  AddButton({
    Key? key,
    required this.isExtended,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      enableFeedback: true,
      isExtended: isExtended,
      backgroundColor: AppTheme.primaryColor(context),
      icon: Icon(FontAwesome.plus, color: Colors.white),
      label: Text(getTranslation.new_post,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      onPressed: () {
        navigationController.jumpToTab(1);
        ;
      },
    );
  }
}
