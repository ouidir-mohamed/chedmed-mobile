import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/ui/own_article_details/own_article_details.dart';
import 'package:chedmed/ui/profile/no_profile_article.dart';
import 'package:chedmed/ui/profile/self_annonce_presentation.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../article_details/article_details.dart';
import '../common/app_theme.dart';
import '../common/no_cache.dart';
import '../common/transitions.dart';
import '../home/annonce_presentation.dart';

class SelfAnnonces extends StatefulWidget {
  const SelfAnnonces({Key? key}) : super(key: key);

  @override
  State<SelfAnnonces> createState() => _SelfAnnoncesState();
}

class _SelfAnnoncesState extends State<SelfAnnonces>
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
  List<SelfAnnoncePresentation> annonces = [];

  bool loading = false;

  @override
  void initState() {
    _animationController.forward();
    profileBloc.getSelfAnnonces.listen((event) {
      if (mounted)
        setState(() {
          annonces = event;
        });
    });

    profileBloc.getSelfLoading.listen((event) {
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
                : NoProfileArticle(),
      ),
    );
  }

  Widget _AnnoncesHasData() {
    return Column(
      children: annonces.map((e) => SelfArticleCard(annonce: e)).toList(),
    );
  }
}

class SelfArticleCard extends StatelessWidget {
  SelfAnnoncePresentation annonce;
  SelfArticleCard({
    Key? key,
    required this.annonce,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  SlideRightRoute(
                      widget: OwnArticleDetails(
                    annonce: annonce,
                  )));
            },
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    child: Image.network(
                      AnnoncePresentation.getMiniImage((annonce.images.first)),
                      fit: BoxFit.cover,
                      frameBuilder: (ctx, b, c, d) {
                        if (c == null) return Loading();
                        return b;
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            annonce.titre,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    annonce.prix.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppTheme.primaryColor(context)),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2)),
                                Text(
                                  getTranslation.curreny,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppTheme.primaryColor(context)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        annonce.localisation,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.headlineColor(context)),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
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
