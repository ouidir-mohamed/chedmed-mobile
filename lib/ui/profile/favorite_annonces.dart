import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/ui/home/annonce_presentation.dart';
import 'package:chedmed/ui/home/annonces.dart';
import 'package:chedmed/ui/profile/no_favorite_article.dart';
import 'package:chedmed/ui/profile/no_profile_article.dart';
import 'package:chedmed/ui/profile/self_annonce_presentation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../article_details/article_details.dart';
import '../common/app_theme.dart';
import '../common/no_cache.dart';
import '../common/transitions.dart';

class FavoriteAnnonces extends StatefulWidget {
  const FavoriteAnnonces({Key? key}) : super(key: key);

  @override
  State<FavoriteAnnonces> createState() => _FavoriteAnnoncesState();
}

class _FavoriteAnnoncesState extends State<FavoriteAnnonces>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    lowerBound: 0.3,
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeIn,
  );
  List<AnnoncePresentation> annonces = [];

  bool loading = false;

  @override
  void initState() {
    _animationController.forward();
    profileBloc.getFavoriteAnnonces.listen((event) {
      if (mounted)
        setState(() {
          annonces = event;
        });
    });

    profileBloc.getFavoriteLoading.listen((event) {
      if (mounted)
        setState(() {
          loading = event;
        });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: loading
            ? ArticleCardLoading()
            : annonces.isNotEmpty
                ? _AnnoncesHasData()
                : NoFavoriteArticle(),
      ),
    );
  }

  Widget _AnnoncesHasData() {
    return AnimatedSize(
      duration: Duration(milliseconds: 150),
      curve: Curves.easeIn,
      child: Column(
        children: annonces.map((e) => ArticleCard(annonce: e)).toList(),
      ),
    );
  }
}

class ArticleCardLoading extends StatelessWidget {
  const ArticleCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).canvasColor;
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

    return Column(
        children: [1, 1, 1]
            .map((e) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: backgroundColor),
                    ),
                  ),
                ))
            .toList());
  }
}
