import 'package:flutter/material.dart';

import '../common/app_theme.dart';

class AnnonceForm extends StatefulWidget {
  const AnnonceForm({Key? key}) : super(key: key);

  @override
  State<AnnonceForm> createState() => _AnnonceFormState();
}

class _AnnonceFormState extends State<AnnonceForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text("Titre",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          TextFormField(
            //controller: departureAdressController,
            //readOnly: true,
            //  cursorColor: Colors.white,
            // focusNode: startFocusNode,

            decoration: InputDecoration(
                hintText: "Titre de l'Annonce",
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                fillColor: AppTheme.cardColor(context),
                filled: true),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 3),
            child: Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          TextFormField(
            //controller: departureAdressController,
            //readOnly: true,
            //  cursorColor: Colors.white,
            // focusNode: startFocusNode,
            maxLines: 5,

            decoration: InputDecoration(
                hintText: "Ajouter une description",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                fillColor: AppTheme.cardColor(context),
                filled: true),
          ),
        ],
      ),
    );
  }
}
