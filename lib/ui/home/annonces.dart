import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/ui/article_details/article_details.dart';
import 'package:chedmed/ui/common/transitions.dart';
import 'package:chedmed/ui/home/annonce_presentation.dart';
import 'package:chedmed/ui/home/no_item_found.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:like_button/like_button.dart';
import '../common/app_theme.dart';
import '../common/no_cache.dart';

class Annonces extends StatefulWidget {
  Annonces({Key? key}) : super(key: key);

  @override
  State<Annonces> createState() => _AnnoncesState();
}

class _AnnoncesState extends State<Annonces> {
  List<AnnoncePresentation> annonces = [];
  bool loading = false;
  bool loadingExtra = false;

  @override
  void initState() {
    homeBloc.getAnnonces.listen((event) {
      if (mounted)
        setState(() {
          annonces = event;
        });
    });

    homeBloc.getLoading.listen((event) {
      if (mounted)
        setState(() {
          loading = event;
        });
    });

    homeBloc.getLoadingExtra.listen((event) {
      if (mounted)
        setState(() {
          loadingExtra = event;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: loading
          ? ArticleCardLoading()
          : annonces.isNotEmpty
              ? _ArticlesListView()
              : NoItemFound(),
    );
  }

  Widget _ArticlesListView() {
    return Column(
      children: [
        Column(
          children: annonces
              .map((e) => ArticleCard(
                    annonce: e,
                  ))
              .toList(),
        ),
        loadingExtra
            ? Container(
                width: 70,
                height: 20,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseRise,
                  colors: [AppTheme.primaryColor(context)],
                  strokeWidth: 0,
                ),
              )
            : Container(),
      ],
    );
  }
}

class ArticleCard extends StatelessWidget {
  AnnoncePresentation annonce;
  ArticleCard({
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
                      widget: ArticleDetails(
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
                      annonce.images.first,
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
                            child: Text(
                              getTranslation
                                  .curreny_var(annonce.prix.toString()),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppTheme.primaryColor(context)),
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
                Stack(
                  children: [
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: LikeButton(
                          likeBuilder: (liked) {
                            if (liked)
                              return Icon(
                                AntDesign.heart,
                                color: AppTheme.secondaryColor(context),
                              );
                            return Icon(
                              AntDesign.hearto,
                              color: AppTheme.secondaryColor(context),
                            );
                          },
                          isLiked: annonce.favorite,
                          onTap: annonce.favorite
                              ? (s) async {
                                  homeBloc.removeFromFavorite(annonce.id);
                                  return false;
                                }
                              : (s) async {
                                  homeBloc.addToFavorite(annonce.id);
                                  return true;
                                }),

                      //  Icon(
                      //   annonce.favorite ? AntDesign.heart : AntDesign.hearto,
                      //   size: 20,
                      //   color: AppTheme.primaryColor(context),
                      // ),
                    ),
                    Positioned(
                        right: 14,
                        bottom: 12,
                        child: Row(
                          children: [
                            Icon(
                              AntDesign.eye,
                              color: AppTheme.headlineColor(context),
                              size: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(annonce.vues.toString()),
                            )
                          ],
                        ))
                  ],
                )
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
