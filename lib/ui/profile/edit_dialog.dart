import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({Key? key}) : super(key: key);

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).;
    // var width = MediaQuery.of(context).size.width;
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
                child: Text('Modifier '),
                width: double.infinity,
              ),
              Positioned(
                child: Icon(Entypo.edit),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 20),
                  child: Text("Nom",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                TextFormField(
                  //controller: departureAdressController,
                  //readOnly: true,
                  //  cursorColor: Colors.white,
                  // focusNode: startFocusNode,

                  decoration: InputDecoration(
                      hintText: "Votre nom",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      fillColor: AppTheme.cardColor(context),
                      filled: true),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 20),
                  child: Text("Téléphone",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                TextFormField(
                  //controller: departureAdressController,
                  //readOnly: true,
                  //  cursorColor: Colors.white,
                  // focusNode: startFocusNode,

                  decoration: InputDecoration(
                      hintText: "Votre numéro",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      fillColor: AppTheme.cardColor(context),
                      filled: true),
                ),
                Container(
                  height: 50,
                ),
                Container(
                  height: 0.1,
                  width: double.infinity,
                  color: Colors.grey,
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
          onPressed: () => {Navigator.of(context).pop()},
          child: const Text('OK'),
        ),
      ],
    );
  }
}

displayEditDialog(
  BuildContext context,
) {
  showDialog<String>(
      context: context, builder: (BuildContext context) => EditProfileDialog());
}
