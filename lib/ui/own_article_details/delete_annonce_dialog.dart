import 'package:chedmed/blocs/delete_annonce_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/buttons.dart';

class DeleteAnnonceDialog extends StatefulWidget {
  int annonceId;
  DeleteAnnonceDialog({
    Key? key,
    required this.annonceId,
  }) : super(key: key);

  @override
  State<DeleteAnnonceDialog> createState() => _DeleteAnnonceDialogState();
}

class _DeleteAnnonceDialogState extends State<DeleteAnnonceDialog> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color captionColor = Theme.of(context).textTheme.caption!.color!;

    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 18, right: 24, left: 24, bottom: 0),
      contentPadding: EdgeInsets.only(top: 20, right: 24, left: 24, bottom: 0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Supprimer l'annonce"),
                width: double.infinity,
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
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Voulez vous supprimer votre annonce ?"),
            Container(
              margin: EdgeInsets.only(top: 20),
            )
          ],
        )),
      ),
      actions: <Widget>[
        MyTextButton(
          onPressed: () => Navigator.pop(context, 'Annuler'),
          child: const Text('Annuler'),
        ),
        MyTextButton(
          onPressed: () {
            deleteAnnonceBloc.deleteAnnonce(widget.annonceId);

            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

displayDeleteAnnonceDialog(BuildContext context, int annonceId) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          DeleteAnnonceDialog(annonceId: annonceId));
}
