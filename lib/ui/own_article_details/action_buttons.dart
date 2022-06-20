import 'package:chedmed/ui/edit_annonce/edit_annonce.dart';
import 'package:chedmed/ui/own_article_details/delete_annonce_dialog.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';

import 'package:chedmed/ui/common/buttons.dart';

import '../common/transitions.dart';

class ActionButtons extends StatelessWidget {
  int annonceId;
  ActionButtons({
    Key? key,
    required this.annonceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MyElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  SlideBottomRoute(
                      widget: EditAnnonce(
                    annonceId: annonceId,
                  )));
            },
            child: Text(
              getTranslation.edit.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          MyOutlinedButton(
            onPressed: () {
              displayDeleteAnnonceDialog(context, annonceId);
            },
            child: Text(
              getTranslation.delete.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
