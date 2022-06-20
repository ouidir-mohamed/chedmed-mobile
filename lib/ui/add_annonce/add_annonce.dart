import 'dart:io';

import 'package:chedmed/blocs/add_annonce_bloc.dart';
import 'package:chedmed/utils/language_helper.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(getTranslation.new_post,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  bool loading = false;

  @override
  void initState() {
    addAnnonceBloc.getLoading.listen((event) {
      if (mounted)
        setState(() {
          loading = event;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: MyElevatedButtonWide(
        child: loading
            ? Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))
            : Text(
                getTranslation.add,
              ),
        color: AppTheme.secondaryColor(context),
        onPressed: loading
            ? () {}
            : () {
                addAnnonceBloc.handleValidation();
              },
      ),
    );
  }
}
