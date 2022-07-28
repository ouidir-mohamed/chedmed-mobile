import 'package:chedmed/ui/home/annonces.dart';
import 'package:flutter/material.dart';

class AnnoncesLoading extends StatelessWidget {
  const AnnoncesLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ArticleCardLoading());
  }
}
