import 'package:chedmed/ui/edit_annonce/edit_annonce.dart';
import 'package:chedmed/ui/own_article_details/delete_annonce_dialog.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              "Modifier",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          MyOutlinedButton(
            onPressed: () {
              displayDeleteAnnonceDialog(context, annonceId);
            },
            child: Text(
              "Supprimer",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
