import 'package:chedmed/ui/loading/loading_screen.dart';
import 'package:chedmed/ui/session_check/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:store_redirect/store_redirect.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';

class OptionalUpdateDialog extends StatelessWidget {
  const OptionalUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.canvasColor(context),
      titlePadding: EdgeInsets.only(top: 18, right: 24, left: 24, bottom: 0),
      contentPadding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Mise a jour'),
                width: double.infinity,
              ),
              Positioned(
                child: Icon(MaterialCommunityIcons.update),
                right: 0,
              ),
            ],
          ),
          Container(
            height: 0.1,
            width: double.infinity,
            color: Colors.grey,
          )
        ],
      ),
      content: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: 9000,
              child: Container(
                child: Text(
                    "Une nouvelle verion de l'application est disponible, cliquez sur Mettre a jour pour obtenir la derniére version"),
              ))),
      actions: <Widget>[
        MyTextButton(
          onPressed: () {
            StoreRedirect.redirect(androidAppId: "com.sahel.mayva");
          },
          child: const Text('Mettre a jour'),
        ),
        MyTextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SessionLoadingScreen()));
          },
          child: const Text('Continuer'),
        ),
      ],
    );
  }
}

displayOptionalUpdateDialog(BuildContext context) {
  showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => OptionalUpdateDialog());
}
