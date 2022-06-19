import 'dart:io';

import 'package:chedmed/blocs/edit_annonce_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chedmed/blocs/add_annonce_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../common/app_theme.dart';
import '../common/buttons.dart';
import '../home/categories.dart';
import 'annonce_form.dart';
import 'categories_selection.dart';
import 'image_selection.dart';

class EditAnnonce extends StatefulWidget {
  int annonceId;
  EditAnnonce({
    Key? key,
    required this.annonceId,
  }) : super(key: key);

  @override
  State<EditAnnonce> createState() => _EditAnnonceState();
}

class _EditAnnonceState extends State<EditAnnonce> {
  bool loading = true;
  @override
  void initState() {
    editAnnonceBloc.loadInitialAnnonce(widget.annonceId);
    editAnnonceBloc.getDone.listen((event) {
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    });

    editAnnonceBloc.getInitLoading.listen((event) {
      if (mounted)
        setState(() {
          loading = event;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: loading ? 0 : 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Header(),
                    CategoriesSelection(),
                    AnnonceForm(),
                    ImageSelection(),
                    EditButton()
                  ],
                ),
              ),
            ),
            loading ? _Loading(context) : Container()
          ],
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
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReturnButton(transparent: true),
              Text("Modifier l'annonce",
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

class EditButton extends StatefulWidget {
  const EditButton({Key? key}) : super(key: key);

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  bool loading = false;

  @override
  void initState() {
    editAnnonceBloc.getEditLoading.listen((event) {
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
                "Modifier",
              ),
        color: AppTheme.secondaryColor(context),
        onPressed: loading
            ? () {}
            : () {
                editAnnonceBloc.handleValidation();
              },
      ),
    );
  }
}

Widget _Loading(BuildContext context) {
  var brightness = Theme.of(context).brightness;
  Color baseColor;
  Color highlightColor;
  if (brightness == Brightness.light) {
    baseColor = Colors.white;
    highlightColor = Colors.grey[200]!;
  } else {
    baseColor = Color(0xFF1D1D1D);
    highlightColor = Color(0XFF3C4042);
  }
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: Duration(milliseconds: 700),
          child: Container(
            height: 15,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: AppTheme.canvasColor(context)),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 3)),
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: Duration(milliseconds: 700),
          child: Container(
            height: 15,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: AppTheme.canvasColor(context)),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 30)),
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: Duration(milliseconds: 700),
          child: Container(
            height: 15,
            width: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: AppTheme.canvasColor(context)),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: Duration(milliseconds: 700),
          child: Container(
            height: 15,
            width: 230,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: AppTheme.canvasColor(context)),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: Duration(milliseconds: 700),
          child: Container(
            height: 15,
            width: 210,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: AppTheme.canvasColor(context)),
          ),
        ),
      ],
    ),
  );
}
