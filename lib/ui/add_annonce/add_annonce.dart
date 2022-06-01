import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import 'package:chedmed/ui/add_annonce/annonce_form.dart';
import 'package:chedmed/ui/add_annonce/categories_selection.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';
import '../home/categories.dart';
import 'package:image_picker/image_picker.dart';

import 'image_selection.dart';

class AddAnnonce extends StatelessWidget {
  const AddAnnonce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              CategoriesSelection(),
              AnnonceForm(),
              ImageSelection(),
              AddButton()
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReturnButton(
                transparent: true,
              ),
              Text("Nouvelle annonce",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: MyElevatedButtonWide(
        child: Text(
          "Ajouter",
        ),
        color: AppTheme.secondaryColor(context),
        onPressed: () {},
      ),
    );
  }
}
