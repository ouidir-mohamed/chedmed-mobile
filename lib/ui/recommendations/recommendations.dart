import 'dart:convert';

import 'package:chedmed/blocs/notifications_bloc.dart.dart';
import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/ui/home/annonces.dart';
import 'package:chedmed/ui/recommendations/annonces_loading.dart';
import 'package:flutter/material.dart';

import '../../utils/language_helper.dart';
import '../common/buttons.dart';
import 'annonces.dart';

class Recommendations extends StatefulWidget {
  Recommendations({
    Key? key,
  }) : super(key: key);

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  NotificationsBloc notificationsBloc = NotificationsBloc();
  List<Annonce> annonces = [];
  bool loading = true;
  @override
  void initState() {
    notificationsBloc.getRocommendations();
    notificationsBloc.getLoading.listen((event) {
      setState(() {
        loading = event;
      });
    });

    notificationsBloc.getAnnonces.listen((event) {
      setState(() {
        annonces = event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            loading
                ? AnnoncesLoading()
                : RecommendedAnnonces(
                    annonces: annonces,
                  )
          ],
        ),
      )),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ReturnButton(
                    transparent: true,
                  ),
                  Text("Recommendées",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
