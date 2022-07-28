import 'package:chedmed/ui/home/annonce_presentation.dart';
import 'package:chedmed/ui/home/annonces.dart';
import 'package:flutter/material.dart';

import '../../models/annonce.dart';

class RecommendedAnnonces extends StatelessWidget {
  List<Annonce> annonces;
  RecommendedAnnonces({
    Key? key,
    required this.annonces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: annonces.map((e) {
          return ArticleCard(
              annonce: AnnoncePresentation.toAnnoncePresentation(e));
        }).toList(),
      ),
    );
  }
}
